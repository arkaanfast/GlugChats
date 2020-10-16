const express = require("express");
const admin = require("firebase-admin");
const checkAuth = require("../midlewares/check_auth");

const router = express.Router();
const db = admin.firestore();

router.post("/", checkAuth, async (req, res, next) => {
  db.collection("ChatRoom")
    .doc(req.body.chatRoomId)
    .collection("Messages")
    .add({
      message: req.body.message,
      sendBy: req.body.sendBy,
      time: req.body.time,
    })
    .then((result) => {
      res.status(200).json({
        message: "Sent",
      });
    });
});

module.exports = router;
