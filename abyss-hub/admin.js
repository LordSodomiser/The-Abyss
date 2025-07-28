const express = require('express');
const router = express.Router();
const { getDb } = require('./db');

const ADMIN_USER = 'admin';
const ADMIN_PASS = 'admin123'; // Change in production

router.get('/', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Admin Panel</title>
            <link rel="stylesheet" href="/styles.css">
        </head>
        <body>
            <header>Welcome to the Anonymous Chat</header>
            <div class="container">
                <h2>Admin Panel</h2>
                <input type="text" id="username" placeholder="Username" class="input-glow">
                <input type="password" id="password" placeholder="Password" class="input-glow">
                <button onclick="login()">Login</button>
                <div id="admin-posts"></div>
                <a href="/forum.html">Back to Forum</a>
            </div>
            <footer>© 2025 Anon Chat & Forum</footer>
            <script>
                function login() {
                    const username = document.getElementById('username').value;
                    const password = document.getElementById('password').value;
                    if (username === '${ADMIN_USER}' && password === '${ADMIN_PASS}') {
                        loadPosts();
                    } else {
                        alert('Invalid credentials');
                    }
                }

                function loadPosts() {
                    fetch('/posts')
                        .then(res => res.json())
                        .then(posts => {
                            const postsDiv = document.getElementById('admin-posts');
                            postsDiv.innerHTML = posts.map(post => `
                                <div class="post">
                                    <h3>${post.title}</h3>
                                    <p>${post.content}</p>
                                    ${post.media ? \`<img src="/uploads/${post.media}" alt="Media" style="max-width: 300px;">\` : ''}
                                    <button onclick="deletePost(${post.id})">Delete</button>
                                </div>
                            `).join('');
                        });
                }

                function deletePost(postId) {
                    fetch('/delete-post', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ postId })
                    })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            loadPosts();
                        }
                    });
                }
            </script>
        </body>
        </html>
    `);
});

router.post('/delete-post', async (req, res) => {
    const db = getDb();
    const { postId } = req.body;
    await db.run('DELETE FROM posts WHERE id = ?', [postId]);
    await db.run('DELETE FROM comments WHERE post_id = ?', [postId]);
    res.json({ success: true });
});

module.exports = router;