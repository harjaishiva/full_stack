const db = require("../databases/user_db.js");
const asyncHandler = require("express-async-handler");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const mailer = require("nodemailer");
const dotenv = require("dotenv").config();
const path = require("path");


const transporter = mailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.MYEMAIL,
    pass: process.env.MAIL_PASS,
  },
});

const tokenVerified = (req, res) => {
  res.status(200).json({ status: 0, message: "Token verified" });
};

const signUp = asyncHandler(async (req, res) => {
  const { name, email, password } = req.body;
  if (!name || !email || !password) {
    return res
      .status(400)
      .json({ status: 1, message: "All feilds are amndatory" });
  } else {
    const [rows] = await db.query(
      "SELECT email FROM registerUser WHERE name = ?",
      [name]
    );
    if (rows.length > 0 && rows[0].email == email) {
      return res.status(409).json({ status: 1, message: "user already exist" });
    } else {
      const hashPass = await bcrypt.hash(password, 10);
      const [rows] = await db.query(
        " INSERT INTO registerUser(name,email,password) VALUES(?, ?, ?)",
        [name, email, hashPass]
      );
      res.status(200).json({ status: 0, message: "user is registered" });
    }
  }
});

const signIn = asyncHandler(async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res
      .status(400)
      .send({ status: 1, message: "All feilds are mandatory" });
  } else {
    const [rows] = await db.execute(
      "SELECT * FROM registerUser WHERE email = ?",
      [email]
    );

    if (rows.length <= 0) {
      return res.status(404).send({ status: 1, message: "User Not Found" });
    }
    const result = await bcrypt.compare(password, rows[0].password);

    if (result) {
      const user = { name: rows[0].name, email: rows[0].email };
      const secretKey = process.env.JWT_SECRET;
      const token = jwt.sign(user, secretKey, { expiresIn: "10h" });
      const imagepath = path.join(process.cwd(), rows[0].image);
      res.status(200).json({
        status: 0,
        message: "User authenticated",
        userId: rows[0].id,
        name: rows[0].name,
        email: rows[0].email,
        image: imagepath,//rows[0].image,
        token: token,
      });
      await db.execute(
        " INSERT INTO loginUser(email,token) VALUES(?, ?) ON DUPLICATE KEY UPDATE logged_in_at = CURRENT_TIMESTAMP",
        [email, token]
      );
    } else {
      res.status(400).send({ status: 1, message: "Incorrect password" });
    }
  }
});

function getOtpExpiry() {
  const now = new Date();
  now.setMinutes(now.getMinutes() + 5);

  const hour = now.getHours();
  const minutes = now.getMinutes();
  const seconds = now.getSeconds();

  const timeline = `${String(hour).padStart(2, "0")}:${String(minutes).padStart(
    2,
    "0"
  )}:${String(seconds).padStart(2, "0")}`;
  return timeline;
}

const requestOtp = asyncHandler(async (req, res) => {
  const { email } = req.body;
  if (!email) {
    return res.status(400).json({ status: 1, message: "Feild is mandatory" });
  }

  const otp = Math.floor(1000 + Math.random() * 9000).toString();
  const expirey = getOtpExpiry();

  const mailOtions = {
    from: process.env.MYEMAIL,
    to: email,
    subject: "Verification via OTP",
    text: `OTP for your email verification is ${otp}.\nOtp will expire in 5 minutes`,
  };
  await db.execute(
    "INSERT INTO otp_details(email,otp,otp_expiery) Values(?,?,?) ON DUPLICATE KEY UPDATE otp = ?, otp_expiery = ?",
    [email, otp, expirey, otp, expirey]
  );

  transporter.sendMail(mailOtions, (err) => {
    if (err) {
      return res.status(400).json({ status: 1, message: err });
    } else {
      return res
        .status(200)
        .json({ status: 0, message: "OTP sent successfully" });
    }
  });
});

const verifyOtp = asyncHandler(async (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res
      .status(400)
      .json({ status: 1, message: "All feilds are mandatory" });
  }

  const [row] = await db.query("SELECT * FROM otp_details WHERE email = ?", [
    email,
  ]);

  if (!row) {
    return res.status(403).json({ status: 1, message: "user does not exist" });
  } else {
    if (otp === row[0].otp) {
      const expirey = new Date(row[0].otp_expiery);
      if (new Date() < expirey) {
        return res.status(200).json({ status: 0, message: "success" });
      } else {
        return res.status(410).json({ status: 1, message: "OTP expired" });
      }
    } else {
      return res.status(401).json({ status: 1, message: "OTP does not match" });
    }
  }
});

module.exports = {tokenVerified,signIn,signUp,verifyOtp,requestOtp};