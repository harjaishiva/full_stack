const express = require("express");
const dotenv = require("dotenv").config();
const morgan = require("morgan");
const logger = require("./logger");
const fs = require("fs");
const path = require("path");
const cors = require("cors");
const swaggerUi = require('swagger-ui-express');
const swaggerDocs = require('./swagger/swaggerjsdoc.js');

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.use('/api-docs',swaggerUi.serve, swaggerUi.setup(swaggerDocs));

app.use("/images", express.static("images"));

app.use("/api/auth", require("./routes/auth_routes.js"));
app.use("/api/item", require("./routes/item_routes.js"));
app.use("/api/cart", require("./routes/cart_routes.js"));
app.use("/api/user", require("./routes/extraa_routes.js"));

app.listen(port, () => {
  console.log(`✅ Server running at http://localhost:${port}`);
  console.log(`Swagger : http://localhost:${port}/api-docs`);
});

process.on("unhandledRejection", (err) => {
  logger.error(`Unhandled Rejection: ${err.message}`);
});

process.on("uncaughtException", (err) => {
  logger.error(`Uncaught Exception: ${err.message}`);
  process.exit(1);
});
