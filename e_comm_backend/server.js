const express = require("express");
const dotenv = require("dotenv").config();
const morgan = require('morgan');
const logger = require('./logger');
const fs = require('fs');
const path = require('path');
const cors = require('cors');

const app = express();
const port = process.env.PORT;

app.use(cors());

app.use(express.json());

if (!fs.existsSync(path.join(process.cwd(), 'logs'))) {
  fs.mkdirSync(path.join(process.cwd(), 'logs'));
}

app.use("/images", express.static("images"));

// Morgan logs each request
app.use(morgan('combined', {
  stream: fs.createWriteStream(path.join(process.cwd(), 'logs', 'access.log'), { flags: 'a' })
}));

// Also log to console via winston
app.use(morgan('dev'));

app.use((err, req, res, next) => {
  logger.error({
    message: 'Unhandled error',
    error: err.message,
    stack: err.stack,
    url: req.originalUrl,
    method: req.method,
    body: req.body,
    query: req.query,
    headers: req.headers
  });
  res.status(500).json({ error: 'Internal Server Error' });
});

app.use("/api/sign",require("./routes/sign_in_and_up_routes.js"));

app.listen(port,()=>{
    console.log(`Server is connected at port ${port}`);
});