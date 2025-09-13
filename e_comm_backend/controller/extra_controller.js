const db = require("../databases/user_db.js");
const asyncHandler = require("express-async-handler");
const bcrypt = require("bcrypt");
const fs = require("fs");

const updatePassword = asyncHandler(async (req, res) => {
  const { email, newPass } = req.body;
  if (!email || !newPass) {
    return res
      .status(400)
      .json({ status: 1, message: "All feilds are mandatory" });
  }

  const [row] = await db.query("SELECT * FROM registerUser WHERE email = ?", [
    email,
  ]);

  if (!row) {
    return res.status(400).json({ status: 1, message: "user not found" });
  }

  const hashPass = await bcrypt.hash(newPass, 10);

  const result = await db.query(
    "UPDATE registerUser SET password = ? WHERE email = ?",
    [hashPass, email]
  );

  if (!result) {
    return res.status(400).json({ status: 1, message: "unable to update" });
  } else {
    return res
      .status(200)
      .json({ status: 0, message: "password is updated successfully" });
  }
});



const uploadImage = asyncHandler(async (req, res) => {
  const file = req.file;
  const id = req.body.id;
  if (!file || !id) {
    return res
      .status(400)
      .json({ status: 1, message: "All feilds are mandatory" });
  }

  const filepath = `/images/${file.filename}`;

  const resul = await db.query("SELECT name FROM registerUser WHERE id = ?", [
    id,
  ]);

  if (!resul) {
    return res.status(401).json({ status: 1, message: "User not found" });
  }

  const result = await db.query(
    "UPDATE registerUser SET image = ? WHERE id = ?",
    [filepath, id]
  );

  if (!result) {
    return res.status(400).json({
      status: 1,
      message: "error in uploading image",
      response: result,
    });
  }

  const imagePath = `http://10.0.2.2:5000/images/${req.file.filename}`;

  if (fs.existsSync(imagePath)) {
    console.log("Image Exists");
  } else {
    console.log("image not exists");
  }

  res.status(200).json({
    status: 0,
    message: "Image uploaded successfully",
    path: imagePath,
  });
});

module.exports = {updatePassword,uploadImage};