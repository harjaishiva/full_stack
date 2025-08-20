const db = require("../databases/user_db.js");
const asyncHandler = require("express-async-handler");
const bcrypt = require("bcrypt");
const jwt = require('jsonwebtoken');
const mailer = require("nodemailer");
const dotenv = require("dotenv").config();
const logger = require("../logger.js");
const path = require('path');
const fs = require('fs');

const transporter = mailer.createTransport({
    service: "gmail",
    auth: {
        user: process.env.MYEMAIL,
        pass:"tuiw mcri tsph vkyh"
    }
});


const signUp = asyncHandler(async (req, res) => {
  const { name, email, password } = req.body;
  if (!name || !email || !password) {
    res.status(400).json({status:1,message:"All feilds are amndatory"});
  } else {
    const [rows] = await db.query("SELECT email FROM registerUser WHERE name = ?",[name]);
    if (rows.length > 0 && rows[0].email == email) {
      res.status(409).json({status:1,message:"user already exist"});
    } else {
      const hashPass = await bcrypt.hash(password, 10);
      const [rows] = await db.query(
        " INSERT INTO registerUser(name,email,password) VALUES(?, ?, ?)",
        [name, email, hashPass]
      );
      res.status(200).json({ status: 0, message: "user is registered"});
    }
  }
});

const signIn = asyncHandler(async (req, res) => {
  const { email, password} = req.body;
  if (!email || !password) {
    res.status(400).send({status:1,message:"All feilds are mandatory"});
  } else {
    const [rows] = await db.execute(
      "SELECT * FROM registerUser WHERE email = ?",
      [email]
    );

     if (rows.length <= 0) {
      res.status(404).send({status:1,message:"Data Not Found"});
    }
    const result = await bcrypt.compare(password,rows[0].password);
   
    
    if (result) {
        const user = {name:rows[0].name,email:rows[0].email};
        const secretKey = process.env.JWT_SECRET;
        const token = jwt.sign(user, secretKey, {expiresIn: '10h'});
        const imagepath = path.join(process.cwd(),rows[0].image);
        res
        .status(200)
        .json({ status: 0, message: "User authenticated", userId: rows[0].id , name: rows[0].name, email: rows[0].email,image: rows[0].image, token:token});
      await db.execute(
        " INSERT INTO loginUser(email,token) VALUES(?, ?) ON DUPLICATE KEY UPDATE logged_in_at = CURRENT_TIMESTAMP",
        [email, token]
      );
      
    }
    else{
        res.status(400).send({status:1,message:"Incorrect password"});
    }
  }
});

const getData = asyncHandler(
  async(req,res)=>{
    const [rows] = await db.query('SELECT * FROM homeData');
    if(!rows){
      logger.info({
    message: 'API hit: /api/sign/deleteFromCart',
    date: new Date().toISOString(),
    //ip: userIp,
    method: req.method,
    parameters: req.body,
    headers: req.headers,
    response: rows
  });
      res.status(500).json({status:1, message:"Unkown error in fetching data",data:null});
    }
    else{
      const products = rows.map(row=>({
        "id": row.id,
        "title": row.title,
        "nprice": row.new_price,
        "mprice": row.market_price,
        "description": row.descriptions,
        "category": row.category,
        "image": row.image,
        "rating": {
          "rate": row.rating_rate,
          "count": row.rating_count
        }
      }));
      logger.info({
    message: 'API hit: /api/sign/deleteFromCart',
    date: new Date().toISOString(),
    //ip: userIp,
    method: req.method,
    parameters: req.body,
    headers: req.headers,
    response: rows
  });
      res.status(200).json({status:0,message:"success",data:products});
    }
  }
);

const getOneData = asyncHandler(
  async(req,res)=>{
    const id = req.params.id;
    if(!id){res.status(400).json({status:1,message:"id is empty"});}
    const [rows] = await db.query('SELECT * FROM homeData WHERE id = ?',[id]);
    
    if(!rows){
      res.status(500).json({status:1, message:"Item not found",data:null});
    }

    else{
      const [row] = rows;
      const products = {
        "id": row.id,
        "title": row.title,
        "nprice": row.new_price,
        "mprice": row.market_price,
        "description": row.descriptions,
        "category": row.category,
        "image": row.image,
        "rating": {
          "rate": row.rating_rate,
          "count": row.rating_count
        }
      };
      res.status(200).json({status:0,message:"success",data:products});
    }
  }
);

const tokenVerified = (req,res)=>{
  res.status(200).json({status:0,message:"Token verified"});
}

function getOtpExpiry(){
  const now = new Date();
  now.setMinutes(now.getMinutes() + 5);

  const hour = now.getHours();
  const minutes = now.getMinutes();
  const seconds = now.getSeconds();

  const timeline = `${String(hour).padStart(2,'0')}:${String(minutes).padStart(2,'0')}:${String(seconds).padStart(2,'0')}`;
  return timeline;
}

const requestOtp = asyncHandler(
  async(req,res)=>{
    const {email} = req.body;
    if(!email){res.status(400).json({status:1,message:"Feild is mandatory"})}

    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    const expirey = getOtpExpiry();

    const mailOtions = {
      from: process.env.MYEMAIL,
      to: email,
      subject: "Verification via OTP",
      text: `OTP for your email verification is ${otp}.\nOtp will expire in 5 minutes`
    };
    await db.execute("INSERT INTO otp_details(email,otp,otp_expiery) Values(?,?,?) ON DUPLICATE KEY UPDATE otp = ?, otp_expiery = ?",[email,otp,expirey,otp,expirey]);

    transporter.sendMail(mailOtions,(err)=>{
      if(err){
        res.status(400).json({status:1,message:err});
      }
      else{
        res.status(200).json({status:0,message:"OTP sent successfully"});
      }
    });
  }
);

const verifyOtp = asyncHandler(
  async(req,res)=>{
    const {email, otp} = req.body;

    if(!email || !otp){
      res.status(400).json({status:1,message:"All feilds are mandatory"});
    }

    const [row] = await db.query('SELECT * FROM otp_details WHERE email = ?',[email]);

    if(!row){
      res.status(400).json({status:1,message:"user does not exist"});
    }
    else{
      if(otp === row[0].otp){
        const now = new Date();
        const timeline = `${String(now.getHours()).padStart(2,'0')}:${String(now.getMinutes()).padStart(2,'0')}:${String(now.getSeconds()).padStart(2,'0')}`;
        if(timeline < row[0].otp_expiery){
          res.status(200).json({status:0,message:"success"});
        }
        else{
          res.status(400).json({status:1,message:"OTP expired"});
        }
      }
      else{
        res.status(400).json({status:1,message:"OTP does not match"});
      }
    }
  }
);

const updatePassword = asyncHandler(
  async(req,res)=>{
    const {email,pass} = req.body;
    if(!email||!pass){
      res.status(400).json({status:1,message:"All feilds are mandatory"});
    }

    const [row] = await db.query('SELECT * FROM registerUser WHERE email = ?',[email]);

    if(!row){res.status(400).json({status:1,message:"user not found"})}

    const hashPass = await bcrypt.hash(pass,10);

    const result = await db.query('UPDATE registerUser SET password = ? WHERE email = ?',[hashPass,email]);

    if(!res){
      res.status(400).json({status:1,message:"unable to update"});
    }
    else{
      res.status(200).json({status:0,message:"password is updated successfully"});
    }
  }
);

const addToCart = asyncHandler(
  async(req,res)=>{
    const {user_id,item_id,image,category,quantity,price, totalPrice,title} = req.body;

    if(!user_id||!item_id||!image||!category||!quantity||!price||!totalPrice||!title){
      res.status(400).json({status:1,message:"all feilds are mandatory"});
    }

    const result = await db.query('INSERT INTO cart(user_id,item_id,image,category,quantity,price,tprice,title) VALUE(?,?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity), tprice = price * quantity',[user_id,item_id,image,category,quantity,price,totalPrice,title]);

    console.log(result);

    res.status(200).json({status:0,message:"Added to the cart"});
  }
);

const getCart = asyncHandler(
  async(req,res)=>{
    const id = req.params.id;
    if(!id){res.status(400).json({status:1,message:"Alll feilds are mandatory"});}
    const result = await db.query("SELECT * FROM cart WHERE user_id = ?",[id]);
    const [rows] = result;

    if(!rows){res.status(400).json({status:1,message:"No data found"});}
    else{
      const data = rows.map(row=>({
        "image":row.image,
        "category":row.category,
        "quantity":row.quantity,
        "price":row.price,
        "tprice": row.tprice,
        "title":row.title,
      })) ;

      res.status(200).json({status:0,message:"success",data:rows});
    }
  }
);

const deleteFromCart = asyncHandler(
  async (req, res) => {

    const id = req.params.id;

    if(!id){res.status(400).json({status:1,message:"all feilds are mandatory"});}

    const result = await db.query('SELECT * FROM cart WHERE id = ?',[id]);

    if(!result){res.status(401).json({status:1,message:"Id not found"});}

    const response = await db.query('DELETE FROM cart WHERE id = ?',[id]);

    console.log(response);

    res.status(200).json({status:0,message:"Removed the order from cart"});
  }
);


const uploadImage = asyncHandler(
  async(req,res)=>{
    const file = req.file;
    const id = req.body.id;
    if(!file || !id){res.status(400).json({status:1,message:"All feilds are mandatory"});}

    const filepath = `/images/${file.filename}`;

    const resul = await db.query('SELECT name FROM registerUser WHERE id = ?',[id]);

    if(!resul){res.status(401).json({status:1,message:"User not found"});}

    const result = await db.query('UPDATE registerUser SET image = ? WHERE id = ?',[filepath,id]);

    if(!result){res.status(400).json({status:1,message:"error in uploading image",response: result});}

    const imagePath = `http://10.0.2.2:5000/images/${req.file.filename}`;

    if(fs.existsSync(imagePath)){console.log("Image Exists");}
    else{console.log("image not exists");}

    res.status(200).json({status:0,message:"Image uploaded successfully",path:imagePath});
  }
);
module.exports = { signUp, signIn, getData, getOneData, tokenVerified, requestOtp, verifyOtp, updatePassword, addToCart, getCart, deleteFromCart, uploadImage};
