const express = require("express");
const router = express.Router();
const cont = require("../controller/cart_controller");


/**
 * @swagger
 * tags: 
 *   name: Cart
 */

/**
 * @swagger
 * /cart/addToCart:
 *    post:
 *      summary: Adding product to the cart
 *      tags: [Cart]
 *      requestBody:
 *        required: true
 *        content:
 *          application/json:
 *            schema:
 *              type: object
 *              properties:
 *                user_id:
 *                  type: string
 *                item_id:
 *                  type: string
 *                image:
 *                  type: string
 *                category:
 *                  type: string
 *                quantity:
 *                  type: string
 *                price:
 *                  type: string
 *                totalPrice:
 *                  type: string
 *                title:
 *                  type: string
 *      responses:
 *        200:
 *          description: Success
 *        400:
 *          description: Missing or Invalid parameters
 */
router.route("/addToCart").post(cont.addToCart);

/**
 * @swagger
 * /cart/getCart/{id}:
 *    get:
 *      summary: Getting all items in cart
 *      tags: [Cart]
 *      parameters:
 *        -  in: path
 *           name: id
 *           required: true
 *           schema:
 *             type: string
 *      responses:
 *        200:
 *          description: Success
 *        400:
 *          description: Missing or Invalid parameters
 */
router.route("/getCart/:id").get(cont.getCart);

/**
 * @swagger
 * /cart/deleteFromCart/{id}:
 *    post:
 *      summary: Deleting from cart
 *      tags: [Cart]
 *      parameters:
 *        -  in: path
 *           name: id
 *           required: true
 *           schema:
 *             type: string
 *      responses:
 *        200:
 *          description: Success
 *        400:
 *          description: Missing or Invalid parameters
 */
router.route("/deleteFromCart/:id").delete(cont.deleteFromCart);

module.exports = router;