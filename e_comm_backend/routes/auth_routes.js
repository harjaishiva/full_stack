const express = require("express");
const router = express.Router();
const cont = require("../controller/auth_controller.js");
const verifyToken = require('../middleware/token_verification.js');

/**
 * @swagger
 * tags: 
 *   name: Auth
 */

/**
 * @swagger
 * /auth/verifyToken:
 *   get:
 *      summary: Verifies the token
 *      tags: [Auth]
 *      security:
 *        - bearerAuth: []
 *      responses:
 *        200:
 *          description: Success
 *        401:
 *          description: Missing or Invalid Token
 *        403:
 *          description: User is forbidden
 *        500:
 *          description: Internal Server Error
 */
router.route("/verifyToken").get(verifyToken,cont.tokenVerified);

/**
 * @swagger
 * /auth/signUp:
 *   post:
 *      summary: User sign up / register for first time
 *      tags: [Auth]
 *      requestBody:
 *          required: true
 *          content:
 *            application/json:
 *              schema:
 *                type: object
 *                properties:
 *                  name:
 *                    type: string
 *                  email:
 *                    type: string
 *                  password:
 *                    type: string
 *      responses:
 *        200:
 *          description: Success
 *        400:
 *          description: Missing or Invalid parameters
 *        409:
 *          description: User alredy exists
 */
router.route("/signUp").post(cont.signUp);

/**
 * @swagger
 * /auth/signIn:
 *   post:
 *      summary: For user sign in / login
 *      tags: [Auth]
 *      requestBody:
 *          required: true
 *          content:
 *            application/json:
 *              schema:
 *                type: object
 *                properties:
 *                  email:
 *                    type: string
 *                  password:
 *                    type: string
 *      responses:
 *        200:
 *          description: Success
 *        400:
 *          description: Missing or Invalid parameters
 *        404:
 *          description: User not found
 */
router.route("/signIn").post(cont.signIn);

/**
 * @swagger
 * /auth/requestOtp:
 *   post:
 *      summary: Sends the otp for verification
 *      tags: [Auth]
 *      requestBody:
 *          required: true
 *          content:
 *            application/json:
 *              schema:
 *                type: object
 *                properties:
 *                  email:
 *                    type: string
 *      responses:
 *        200:
 *          description: Success
 *        400:
 *          description: Missing or Invalid parameters
 */
router.route("/requestOtp").post(cont.requestOtp);

/**
 * @swagger
 * /auth/verifyOtp:
 *   post:
 *      summary: Verifies the otp for user validation
 *      tags: [Auth]
 *      requestBody:
 *          required: true
 *          content:
 *            application/json:
 *              schema:
 *                type: object
 *                properties:
 *                  email:
 *                    type: string
 *                  otp:
 *                    type: string
 *      responses:
 *        200:
 *          description: Success
 *        400:
 *          description: Missing or Invalid parameters
 *        401:
 *          description: Unauthorized access
 *        403:
 *          description: User not found
 *        410:
 *          description: Expired
 */
router.route("/verifyOtp").post(cont.verifyOtp);

module.exports = router;