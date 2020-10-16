const express = require("express");
const morgan = require("morgan");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();

// MiddleWares
app.use(morgan("dev"));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(
  cors({
    origin: "*",
    methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
    preflightContinue: false,
    optionsSuccessStatus: 204,
  })
);

// Routes
const authenticationRoute = require("./api/routes/authentication");
const getUserRoute = require("./api/routes/user");
const chatRouter = require("./api/routes/chats");
app.use("/auth", authenticationRoute);
app.use("/user", getUserRoute);
app.use("/chat", chatRouter);

const port = process.env.PORT_NO || 3000;

app.listen(port, () => console.log("Started server"));
