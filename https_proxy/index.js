const fs = require('fs');
const http = require('http');
const https = require('https');
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');

if (!process.env.TARGET) {
  console.error('TARGET env variable is not set');
  process.exit(1);
}

const app = express();

app.use(createProxyMiddleware({
  target: process.env.TARGET,
  ws: true,
}));

const httpServer = http.createServer(app);
const httpsServer = https.createServer({
  key: fs.readFileSync('key.pem', 'utf8'),
  cert: fs.readFileSync('cert.pem', 'utf8')
}, app);

httpServer.listen(80);
httpsServer.listen(443);
