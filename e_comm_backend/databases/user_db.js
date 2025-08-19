const mysql = require("mysql2");
const dotenv = require("dotenv").config();

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: false
});

pool.getConnection((err,connection)=>{
    if(err){
        console.log("Unable to connect DB");
    }
    else{
        console.log("DB connected successfully");
    }
});

module.exports = pool.promise();