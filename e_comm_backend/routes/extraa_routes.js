const express = require("express");
const router = express.Router();
const cont = require("../controller/extra_controller.js");
const upload = require('../middleware/image_middleware.js');

/**
 * @swagger
 * tags:
 *   name: User
 */

/**
 * @swagger
 * /user/updatePassword:
 *    post:
 *      summary: Updating the password for signin / login
 *      tags: [User]
 *      requestBody:
 *        required: true
 *        content:
 *          application/json:
 *            schema:
 *              type: object
 *              properties:
 *                email:
 *                  type: string
 *                newPass:
 *                  type: string
 *      responses:
 *        200:
 *          description: Success
 *        400:
 *          description: Missing or Invalid parameters
 */
router.route("/updatePassword").post(cont.updatePassword);

/**
 * @swagger
 * /user/uploadImage:
 *    post:
 *      summary: UFor uploading Image
 *      tags: [User]
 *      requestBody:
 *        required: true
 *        content:
 *          multipart/form-data:
 *            schema:
 *              type: object
 *              properties:
 *                id:
 *                  type: string
 *                image:
 *                  type: string
 *                  format: binary
 *      responses:
 *        200:
 *          description: Success
 *        400:
 *          description: Missing or Invalid parameters
 *        401:
 *          description: User not found
 */
router.route("/uploadImage").post(upload.single('image'),cont.uploadImage);

module.exports = router;