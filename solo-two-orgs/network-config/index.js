'use strict'

const express = require('express');
const org1 = require('./org1.json')
const org2 = require('./org2.json')

const modifyConfig = require('./util.js').modifyConfig

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/org1', (req, res) => {
  res.send(modifyConfig(org1));
});

app.get('/org2', (req, res) => {
  res.send(modifyConfig(org2));
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);