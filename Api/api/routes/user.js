const express = require("express");
const admin = require("firebase-admin");
const checkAuth = require("../midlewares/check_auth");

const router = express.Router();
const db = admin.firestore();

router.get("/allfriends/:username", checkAuth, async (req, res, next) => {
  const friends = [];
  const friendRef = await db
    .collection("friends")
    .doc(req.params.username)
    .collection("MyFriends")
    .get();

  if (friendRef.docs.length == 0) {
    return res.status(409).json({
      message: "No friends macha",
    });
  }

  friendRef.docs.map((userDoc) => {
    friends.push(userDoc.data());
  });

  return res.status(200).json({
    message: "You have friends ",
    friendsData: friends,
  });
});

router.get("/:username/:friendname", checkAuth, async (req, res, next) => {
  const userName = req.params.friendname;
  const user = await db
    .collection("users")
    .where("username", "==", userName)
    .get();
  if (user.docs.length == 0) {
    return res.status(404).json({
      message: "No user exists",
    });
  }
  const userDetails = user.docs[0];
  const userData = userDetails.data();
  const friend = await db
    .collection("friends")
    .doc(req.params.username)
    .collection("MyFriends")
    .where("friendName", "==", userData.username)
    .get();
  if (friend.docs.length > 0) {
    return res.status(200).json({
      message: "Already added",
      friendName: userData.username,
      friendTitle: userData.title,
    });
  }
  res.status(200).json({
    message: "User data",
    friendName: userData.username,
    friendTitle: userData.title,
  });
});

router.post("/addfriend", checkAuth, async (req, res, next) => {
  const friend = await db
    .collection("friends")
    .doc(req.body.userName)
    .collection("MyFriends")
    .where("friendName", "==", req.body.friendName)
    .get();

  if (friend.docs.length > 0) {
    return res.status(409).json({
      message: "Already Added",
      alreadyAdded: true,
    });
  }

  while (true) {
    var r = Math.random().toString(36).substring(7);
    const randomCollection = await db
      .collection("ChatRoomIds")
      .where("chatID", "==", r)
      .get();
    if (randomCollection.docs.length > 0) {
      continue;
    } else {
      await db.collection("ChatRoomIds").add({
        chatRoomID: r,
      });
      break;
    }
  }
  db.collection("friends")
    .doc(req.body.userName)
    .collection("MyFriends")
    .doc(req.body.friendName)
    .create({
      friendName: req.body.friendName,
      friendTitle: req.body.friendTitle,
      chatRoomID: r,
    })
    .then(async () => {
      return await db
        .collection("friends")
        .doc(req.body.friendName)
        .collection("MyFriends")
        .doc(req.body.userName)
        .create({
          friendName: req.body.userName,
          friendTitle: req.body.title,
          chatRoomID: r,
        });
    })
    .then((result) => {
      res.status(200).json({
        message: "Friend added",
        friendName: req.body.friendName,
        friendTitle: req.body.friendTitle,
        chatRoomID: r,
      });
    })
    .catch((err) => {
      res.status(409).json({
        message: "Error",
        error: err,
      });
    });
});

module.exports = router;
