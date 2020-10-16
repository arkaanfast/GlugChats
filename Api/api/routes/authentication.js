// Authentication routes
const express = require("express");
const bcrypt = require("bcrypt");
const admin = require("firebase-admin");
const jwt = require("jsonwebtoken");

var admin = require("firebase-admin");

var serviceAccount = require("../../glugchats-firebase-adminsdk-mimva-9dd786e570.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://glugchats.firebaseio.com"
});

const router = express.Router();
const db = admin.firestore();

// user signUp
router.post("/signup", async (req, res, next) => {
  const userEmail = req.body.email;
  const username = req.body.userName;
  const password = req.body.password;
  const title = req.body.title;
  const userEmailExits = await db
    .collection("users")
    .where("email", "==", userEmail)
    .get();
  if (userEmailExits.docs.length > 0) {
    return res.status(409).json({
      message: "Email already exists",
    });
  }

  const userNameExits = await db
    .collection("users")
    .where("username", "==", username)
    .get();
  if (userNameExits.docs.length > 0) {
    return res.status(409).json({
      message: "User Name already exists",
    });
  }

  bcrypt.hash(password, 10, (err, hash) => {
    if (err) {
      return res.status(500).json({
        error: err,
      });
    }
    db.collection("users")
      .add({
        email: userEmail,
        username: username,
        password: hash,
        title: title,
      })
      .then((result) => {
        return res.status(200).json({
          message: "Created user",
          userId: result._path.segments[1],
        });
      })
      .catch((err) => {
        return res.status(500).json({
          error: err,
        });
      });
  });
});

// user sign in
router.post("/signin", async (req, res, next) => {
  const userName = req.body.userName;
  const password = req.body.password;
  const user = await db
    .collection("users")
    .where("username", "==", userName)
    .get();
  if (user.docs.length == 0) {
    return res.status(404).json({
      message: "Auth Failed",
    });
  } else {
    const userDetails = user.docs[0];
    const userData = userDetails.data();
    const name = userData.username;
    const email = userData.email;
    const userPass = userData.password;
    const title = userData.title;
    bcrypt.compare(password, userPass, (err, result) => {
      if (err) {
        return res.status(401).json({
          message: "Auth Failed incorrect password",
        });
      }
      if (!result) {
        return res.status(401).json({
          message: "Auth Failed incorrect password",
        });
      }
      if (result) {
        const token = jwt.sign(
          {
            email: email,
            name: name,
          },
          "secret"
        );
        return res.status(200).json({
          message: "Done",
          userName: name,
          userEmail: email,
          userTitle: title,
          token: token,
        });
      }
    });
  }
});

module.exports = router;
