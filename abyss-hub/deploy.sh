#!/bin/bash

# Install dependencies
npm install express ws sqlite3 crypto-js helmet sanitize-html uuid multer

# Initialize database
sqlite3 anon.db < schema.sql

# Create uploads directory
mkdir -p uploads

# Start server
node server.js