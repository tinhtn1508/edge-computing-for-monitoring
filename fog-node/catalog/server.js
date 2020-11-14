const express = require("express");
const server = express();

const morgan = require("morgan");
const cors = require("cors");

const usersRouter = require("./routes/users-router.js");
const configRouter = require("./routes/config-router.js");


// Middleware
server.use(cors());
server.use(morgan("dev"));
server.use(express.json());

// Routers
server.use("/api/users", usersRouter);
server.use("/api/config", configRouter);


//Routes
server.get("/", (req, res) => {
  res.status(200).json({ hello: "World!" });
});

module.exports = server;
