require('dotenv').config();
const jwt = require('jsonwebtoken');

const verifyToken = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ status:1,message: 'No token provided' });
  }

  const token = authHeader.split(' ')[1];

  try {
    const secretKey = process.env.JWT_SECRET;
    const decoded = jwt.verify(token, secretKey);
    req.user = decoded; // now accessible in next routes
    next();
  } catch (err) {
    console.error("JWT verification error:", err.name, err.message);
     if (err.name === "TokenExpiredError") {
      return res.status(401).json({ status:1,message: "Token has expired" });
    } else if (err.name === "JsonWebTokenError") {
      return res.status(403).json({ status:1,message: "Invalid token" });
    } else {
      return res.status(500).json({ status:1,message: "Token verification failed" });
    }
  }
};

module.exports = verifyToken;