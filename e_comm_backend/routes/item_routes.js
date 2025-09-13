const express = require("express");
const router = express.Router();
const cont = require("../controller/item_controller.js");
const verifyToken = require('../middleware/token_verification.js');

/**
 * @swagger
 * tags:
 *   name: Item Data
 */

/**
 * @swagger
 * /item/getData:
 *   get:
 *      summary: Get all items
 *      tags: [Item Data]
 *      security:
 *        - bearerAuth: []
 *      responses:
 *        200:
 *          description: Success
 *        404:
 *          description: Data not found
 */
router.route("/getData").get(verifyToken,cont.getData);

/**
 * @swagger
 * /item/getOneItem/{id}:
 *   get:
 *      summary: Get one item
 *      tags: [Item Data]
 *      parameters:
 *        - in: path
 *          name: id
 *          schema:
 *            type: string
 *            required: true
 *      responses:
 *        200:
 *          description: Success
 *        400:
 *          description: Missing or Invalid parameter
 *        500:
 *          description: Internal Server Error
 *        
 */
router.route("/getOneItem/:id").get(cont.getOneData);

module.exports = router;