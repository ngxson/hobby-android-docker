var httpProxy = require('http-proxy');
var fs = require('fs');

if (!process.env.TARGET) {
  console.error('TARGET env variable is not set');
  process.exit(1);
}

httpProxy.createProxyServer({
  target: process.env.TARGET,
  ssl: {
    key: fs.readFileSync('key.pem', 'utf8'),
    cert: fs.readFileSync('cert.pem', 'utf8')
  }
}).listen(443).on('error', console.error);
