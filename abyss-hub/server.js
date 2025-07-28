const express = require('express');
const WebSocket = require('ws');
const https = require('https');
const fs = require('fs');
const helmet = require('helmet');
const sanitizeHtml = require('sanitize-html');
const multer = require('multer');
const { v4: uuidv4 } = require('uuid');
const { encrypt, decrypt } = require('./encryption');
const { getDb } = require('./db');
const adminRoutes = require('./admin');

const app = express();
const upload = multer({ dest: 'uploads/' });

// Middleware
app.use(helmet());
app.use(express.json());
app.use(express.static('public'));
app.use('/uploads', express.static('uploads'));
app.use('/admin', adminRoutes);

// SQLite database
const db = getDb();

// WebSocket server
// const server = https.createServer({
//     cert: fs.readFileSync('cert.pem'),
//     key: fs.readFileSync('key.pem')
// }, app);
const server = app; // Comment out HTTPS for local testing
const wss = new WebSocket.Server({ server: server.listen(3000) });

let users = new Set();
let rooms = new Map();

wss.on('connection', (ws) => {
    ws.on('message', async (message) => {
        const data = JSON.parse(message);
        const sanitizedMessage = data.message ? sanitizeHtml(data.message) : null;

        if (data.type === 'join') {
            users.add(data.username);
            broadcast({ type: 'system', message: `${data.username} has entered the room` });
            broadcastUserCount();
            cleanupMessages();
        } else if (data.type === 'logout') {
            users.delete(data.username);
            broadcast({ type: 'system', message: `${data.username} has left the room` });
            broadcastUserCount();
            await db.run('DELETE FROM users WHERE username = ?', [data.username]);
        } else if (data.type === 'message') {
            const encryptedMessage = encrypt(sanitizedMessage);
            await db.run('INSERT INTO messages (username, room_id, content, timestamp) VALUES (?, ?, ?, ?)',
                [data.username, data.roomId || 'public', encryptedMessage, Date.now()]);
            broadcast({
                type: 'message',
                username: data.username,
                message: sanitizedMessage,
                timestamp: Date.now()
            }, data.roomId);
        } else if (data.type === 'joinRoom') {
            const room = await db.get('SELECT * FROM rooms WHERE id = ?', [data.roomId]);
            if (room) {
                rooms.set(data.username, data.roomId);
                broadcast({ type: 'system', message: `${data.username} has joined the room` }, data.roomId);
            }
        } else if (data.type === 'authRoom') {
            const room = await db.get('SELECT * FROM rooms WHERE id = ?', [data.roomId]);
            if (room && room.passphrase === data.passphrase) {
                rooms.set(data.username, data.roomId);
                ws.send(JSON.stringify({ type: 'system', message: 'Joined private room' }));
            } else {
                ws.send(JSON.stringify({ type: 'authError' }));
            }
        } else if (data.type === 'invite') {
            const targetWs = [...wss.clients].find(client => client.username === data.to);
            if (targetWs) {
                targetWs.send(JSON.stringify({ type: 'invite', from: data.from, roomId: data.roomId }));
            }
        } else if (data.type === 'acceptInvite') {
            rooms.set(data.username, data.roomId);
            broadcast({ type: 'system', message: `${data.username} has joined the room` }, data.roomId);
        } else if (data.type === 'declineInvite') {
            const inviterWs = [...wss.clients].find(client => client.username === data.from);
            if (inviterWs) {
                inviterWs.send(JSON.stringify({ type: 'system', message: `${data.username} declined your invite` }));
            }
        }
    });

    ws.on('close', () => {
        if (ws.username) {
            users.delete(ws.username);
            broadcast({ type: 'system', message: `${ws.username} has left the room` });
            broadcastUserCount();
        }
    });
});

function broadcast(data, roomId = null) {
    wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN && (!roomId || rooms.get(client.username) === roomId)) {
            client.send(JSON.stringify(data));
        }
    });
}

function broadcastUserCount() {
    broadcast({ type: 'userCount', count: users.size });
}

async function cleanupMessages() {
    const oneDayAgo = Date.now() - 24 * 60 * 60 * 1000;
    await db.run('DELETE FROM messages WHERE timestamp < ?', [oneDayAgo]);
}

app.post('/check-username', async (req, res) => {
    const { username } = req.body;
    const user = await db.get('SELECT * FROM users WHERE username = ?', [username]);
    if (user) {
        res.json({ available: false });
    } else {
        await db.run('INSERT INTO users (username) VALUES (?)', [username]);
        res.json({ available: true });
    }
});

app.post('/create-room', async (req, res) => {
    const { roomName, passphrase, username } = req.body;
    const roomId = uuidv4();
    await db.run('INSERT INTO rooms (id, name, passphrase) VALUES (?, ?, ?)', [roomId, roomName, passphrase]);
    res.json({ roomId });
});

app.get('/active-users', (req, res) => {
    res.json([...users]);
});

app.post('/create-post', upload.single('media'), async (req, res) => {
    const { category, title, content } = req.body;
    const media = req.file ? req.file.filename : null;
    await db.run('INSERT INTO posts (category, title, content, media) VALUES (?, ?, ?, ?)',
        [category, sanitizeHtml(title), sanitizeHtml(content), media]);
    res.json({ success: true });
});

app.get('/posts', async (req, res) => {
    const posts = await db.all('SELECT * FROM posts');
    res.json(posts);
});

app.get('/comments/:postId', async (req, res) => {
    const comments = await db.all('SELECT * FROM comments WHERE post_id = ?', [req.params.postId]);
    res.json(comments);
});

app.post('/add-comment', async (req, res) => {
    const { postId, comment } = req.body;
    await db.run('INSERT INTO comments (post_id, content) VALUES (?, ?)', [postId, sanitizeHtml(comment)]);
    res.json({ success: true });
});

// Cleanup inactive users
setInterval(async () => {
    const inactiveTime = Date.now() - 5 * 60 * 1000;
    const inactiveUsers = await db.all('SELECT username FROM users WHERE last_activity < ?', [inactiveTime]);
    for (const user of inactiveUsers) {
        users.delete(user.username);
        await db.run('DELETE FROM users WHERE username = ?', [user.username]);
        broadcast({ type: 'system', message: `${user.username} has been logged out due to inactivity` });
    }
    broadcastUserCount();
}, 60 * 1000);

console.log('Server running on port 3000');