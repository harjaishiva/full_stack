const db = require("../databases/user_db.js");
const asyncHandler = require("express-async-handler");

const addToCart = asyncHandler(async (req, res) => {
  const {
    user_id,
    item_id,
    image,
    category,
    quantity,
    price,
    totalPrice,
    title,
  } = req.body;

  if (
    !user_id ||
    !item_id ||
    !image ||
    !category ||
    !quantity ||
    !price ||
    !totalPrice ||
    !title
  ) {
    return res
      .status(400)
      .json({ status: 1, message: "all feilds are mandatory" });
  }

  const result = await db.query(
    "INSERT INTO cart(user_id,item_id,image,category,quantity,price,tprice,title) VALUE(?,?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity), tprice =(quantity + VALUES(quantity)) * price",
    [user_id, item_id, image, category, quantity, price, totalPrice, title]
  );

  console.log(result);

  res.status(200).json({ status: 0, message: "Added to the cart" });
});

const getCart = asyncHandler(async (req, res) => {
  const id = req.params.id;
  if (!id) {
    return res
      .status(400)
      .json({ status: 1, message: "Alll feilds are mandatory" });
  }
  const result = await db.query("SELECT * FROM cart WHERE user_id = ?", [id]);
  const [rows] = result;

  if (!rows) {
    return res.status(400).json({ status: 1, message: "No data found" });
  } else {
    const data = rows.map((row) => ({
      image: row.image,
      category: row.category,
      quantity: row.quantity,
      price: row.price,
      tprice: row.tprice,
      title: row.title,
    }));

    return res.status(200).json({ status: 0, message: "success", data: rows });
  }
});

const deleteFromCart = asyncHandler(async (req, res) => {
  const id = req.params.id;

  if (!id) {
    return res
      .status(400)
      .json({ status: 1, message: "all feilds are mandatory" });
  }

  const result = await db.query("SELECT * FROM cart WHERE id = ?", [id]);

  if (!result) {
    return res.status(401).json({ status: 1, message: "Id not found" });
  }

  const response = await db.query("DELETE FROM cart WHERE id = ?", [id]);

  console.log(response);

  res.status(200).json({ status: 0, message: "Removed the order from cart" });
});

module.exports = {addToCart,getCart,deleteFromCart};