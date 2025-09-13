const swaggerjsdoc = require("swagger-jsdoc");
const dotenv = require("dotenv").config();

const port = process.env.PORT;

const swaggerOptions = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "E-comm application",
      version: "1.0.0",
      description: "Backend api for app",
    },
    servers: [
      {
        url: `http://localhost:${port}/api`,
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: "http",
          scheme: "bearer",
          bearerFormat: "JWT",
        },
      },
    },
  },
  apis: ["./routes/*.js"],
};

const swaggerDocs = swaggerjsdoc(swaggerOptions);

module.exports = swaggerDocs;
