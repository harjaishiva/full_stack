const express = require("express");
const router = express.Router();
const cont = require("../controller/sign_in_and_up_controller.js");
const verifyToken = require('../middleware/token_verification.js');
const upload = require('../middleware/image_middleware.js');

router.route("/verifyToken").get(verifyToken,cont.tokenVerified);
router.route("/signUp").post(cont.signUp);
router.route("/signIn").post(cont.signIn);
router.route("/getData").get(verifyToken,cont.getData);
router.route("/getOneItem/:id").get(cont.getOneData);
router.route("/requestOtp").post(cont.requestOtp);
router.route("/verifyOtp").post(cont.verifyOtp);
router.route("/updatePassword").post(cont.updatePassword);
router.route("/addToCart").post(cont.addToCart);
router.route("/getCart/:id").get(cont.getCart);
router.route("/deleteFromCart/:id").delete(cont.deleteFromCart);
router.route("/uploadImage").post(upload.single('image'),cont.uploadImage);

module.exports = router;