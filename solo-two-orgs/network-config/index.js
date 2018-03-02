'use strict'

const express = require('express');
const modifyConfig = require('./util.js').modifyConfig
const org1Config = modifyConfig(require('./org1.json'))
const org2Config = modifyConfig(require('./org2.json'))

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/org1', (req, res) => {
  res.send(org1Config);
});

app.get('/org2', (req, res) => {
  res.send(org2Config);
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);