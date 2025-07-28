 ▄████▄   ▒█████   ███▄ ▄███▓ ██▓ ███▄    █   ▄████    
▒██▀ ▀█  ▒██▒  ██▒▓██▒▀█▀ ██▒▓██▒ ██ ▀█   █  ██▒ ▀█▒   
▒▓█    ▄ ▒██░  ██▒▓██    ▓██░▒██▒▓██  ▀█ ██▒▒██░▄▄▄░   
▒▓▓▄ ▄██▒▒██   ██░▒██    ▒██ ░██░▓██▒  ▐▌██▒░▓█  ██▓   
▒ ▓███▀ ░░ ████▓▒░▒██▒   ░██▒░██░▒██░   ▓██░░▒▓███▀▒   
░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒░   ░  ░░▓  ░ ▒░   ▒ ▒  ░▒   ▒    
  ░  ▒     ░ ▒ ▒░ ░  ░      ░ ▒ ░░ ░░   ░ ▒░  ░   ░    
░        ░ ░ ░ ▒  ░      ░    ▒ ░   ░   ░ ░ ░ ░   ░    
░ ░          ░ ░         ░    ░           ░       ░    
░                                                      
  ██████  ▒█████   ▒█████   ███▄    █                  
▒██    ▒ ▒██▒  ██▒▒██▒  ██▒ ██ ▀█   █                  
░ ▓██▄   ▒██░  ██▒▒██░  ██▒▓██  ▀█ ██▒                 
  ▒   ██▒▒██   ██░▒██   ██░▓██▒  ▐▌██▒                 
▒██████▒▒░ ████▓▒░░ ████▓▒░▒██░   ▓██░                 
▒ ▒▓▒ ▒ ░░ ▒░▒░▒░ ░ ▒░▒░▒░ ░ ▒░   ▒ ▒                  
░ ░▒  ░ ░  ░ ▒ ▒░   ░ ▒ ▒░ ░ ░░   ░ ▒░                 
░  ░  ░  ░ ░ ░ ▒  ░ ░ ░ ▒     ░   ░ ░                  
      ░      ░ ░      ░ ░           ░                  
                                            


Anonymous Chat & Forum App

A secure, anonymous chat and forum application with a dark, Berserk-inspired, goth MySpace aesthetic, featuring a black and red color scheme with pulsating red input boxes. Deployable on both clearnet (HTTPS) and dark web (Tor). Features include end-to-end encrypted public and private chat rooms, a 4chan/Reddit-style forum with media uploads, and an admin panel for moderation.
Prerequisites

    Arch Linux

    Node.js (v20.x or higher)

    SQLite3

    Nginx (for clearnet HTTPS)

    Tor (for dark web deployment)

    OpenSSL (for generating SSL certificates)

Installation and Setup

    Update System and Install Dependencies

    sudo pacman -Syu
    sudo pacman -S nodejs npm sqlite nginx tor openssl

    Create Project Directory

    mkdir anon-chat-forum
    cd anon-chat-forum

    Copy Project FilesPlace all provided files (index.html, public.html, private.html, forum.html, styles.css, script.js, server.js, db.js, encryption.js, admin.js, schema.sql, deploy.sh) into the project directory with the provided structure.

    Initialize Database

    sqlite3 anon.db < schema.sql

    Install Node.js Dependencies

    npm install express ws sqlite3 crypto-js helmet sanitize-html uuid multer

    Generate SSL Certificates (for testing, comment out for local use)

    openssl req -x509 -newkey rsa:2048 -nodes -sha256 -keyout key.pem -out cert.pem -days 365

    Configure Nginx for Clearnet (HTTPS)Create /etc/nginx/sites-available/anon-chat-forum:

    server {
        listen 80;
        server_name your_domain.com;
        return 301 https://$host$request_uri;
    }
    server {
        listen 443 ssl;
        server_name your_domain.com;
        ssl_certificate /path/to/cert.pem;
        ssl_certificate_key /path/to/key.pem;
        location / {
            proxy_pass http://localhost:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
        }
    }

    Enable the site:

    sudo ln -s /etc/nginx/sites-available/anon-chat-forum /etc/nginx/sites-enabled/
    sudo systemctl restart nginx

    Configure Tor for Dark WebEdit /etc/tor/torrc:

    HiddenServiceDir /var/lib/tor/anon-chat-forum/
    HiddenServicePort 80 127.0.0.1:3000

    Restart Tor:

    sudo systemctl restart tor

    Find the .onion address in /var/lib/tor/anon-chat-forum/hostname.

    Run Deployment Script

    chmod +x deploy.sh
    ./deploy.sh

    Create tar.xz Archive

    tar -cJf chat-0.0.1.tar.xz .

    Verify the archive:

    tar -tvf chat-0.0.1.tar.xz

    Access the App

        Clearnet: https://your_domain.com

        Dark web: Use the .onion address via Tor Browser

File Structure

anon-chat-forum/
├── public/
│   ├── index.html
│   ├── public.html
│   ├── private.html
│   ├── forum.html
│   ├── styles.css
│   └── script.js
├── uploads/
├── server.js
├── db.js
├── encryption.js
├── admin.js
├── schema.sql
├── deploy.sh
└── README.md

Security Features

    End-to-end encryption for chats using AES-256.

    Minimal logging (only essential data, purged after 24 hours for chats).

    Automatic logout after 5 minutes of inactivity.

    Sanitized inputs to prevent XSS.

    Secure headers via Helmet.

    SQLite with prepared statements to prevent SQL injection.

    Media upload validation to prevent malicious files.

Admin Panel

    Access at /admin with credentials (default: admin/admin123, change in admin.js).

    Allows post removal and category management.

Notes

    Replace the encryption key in encryption.js and admin credentials in admin.js before deployment.

    Uncomment HTTPS in server.js for production with valid certificates.
