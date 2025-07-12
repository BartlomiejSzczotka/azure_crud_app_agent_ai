#!/usr/bin/env node

const app = require('./src/server');
const PORT = process.env.PORT || 8080;

// Override the port for Azure App Service
if (process.env.PORT) {
  console.log(`Azure App Service detected. Using PORT: ${process.env.PORT}`);
}

// The app.listen is already in server.js, so we don't need to duplicate it here
// This file serves as an entry point that can be customized for Azure deployment
