const sqlite3 = require('sqlite3').verbose();
let db;

function getDb() {
    if (!db) {
        db = new sqlite3.Database('anon.db', (err) => {
            if (err) {
                console.error('Database connection error:', err);
            }
        });
    }
    return db;
}

module.exports = { getDb };