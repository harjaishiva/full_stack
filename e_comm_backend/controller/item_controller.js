const db = require("../databases/user_db.js");
const asyncHandler = require("express-async-handler");

const getData = asyncHandler(async (req, res) => {
  const [rows] = await db.query("SELECT * FROM homeData");
  if (!rows) {
    return res.status(404).json({
      status: 1,
      message: "No data found",
      data: null,
    });
  } else {
    const products = rows.map((row) => ({
      id: row.id,
      title: row.title,
      nprice: row.new_price,
      mprice: row.market_price,
      description: row.descriptions,
      category: row.category,
      image: row.image,
      rating: {
        rate: row.rating_rate,
        count: row.rating_count,
      },
    }));
    res.status(200).json({ status: 0, message: "success", data: products });
  }
});

const getOneData = asyncHandler(async (req, res) => {
  const id = req.params.id;
  if (!id) {
    return res.status(400).json({ status: 1, message: "id is empty" });
  }
  const [rows] = await db.query("SELECT * FROM homeData WHERE id = ?", [id]);

  if (!rows) {
    return res
      .status(500)
      .json({ status: 1, message: "Item not found", data: null });
  } else {
    const [row] = rows;
    const products = {
      id: row.id,
      title: row.title,
      nprice: row.new_price,
      mprice: row.market_price,
      description: row.descriptions,
      category: row.category,
      image: row.image,
      rating: {
        rate: row.rating_rate,
        count: row.rating_count,
      },
    };
    res.status(200).json({ status: 0, message: "success", data: products });
  }
});

module.exports = {getData,getOneData};