const express = require('express');
const Pool = require('pg').Pool
const app = express();
const bodyParser = require('body-parser');
require('dotenv').config();
const os = require('os');
app.set("view engine", "ejs")
app.use(bodyParser.urlencoded({ extended: false }))

const pool = new Pool({
    user: process.env.PG_USER,
    host: process.env.PG_HOST,
    database: process.env.PG_DB,
    password: process.env.PG_PASSWORD,
    port: process.env.PG_PORT
})

app.get('/', (req, res, next) => {
    //res.sendFile( __dirname + '/index.html');
    hostname = os.networkInterfaces().eth1[0].address;
    //console.log(hostname);
    data = {
        usersVar: [],
        host : hostname
    }
   /* if(hostname.equals("web-1")){
        res.render("index", {usersVar: []})
    }else{
        res.render("index2", {usersVar: []})
    }*/
    res.render("index", {myData: data})
    
  });


app.post('/adduser', (req, res) => {
    const id = parseInt(req.body.idnumber)

    const data = {idnumber: id, name: req.body.name, lastname: req.body.lastname};

    //first look for the id
    pool.query('SELECT * FROM person where idnumber = $1', [data.idnumber], (err, resp)=>{

        if(err){
            console.log(pool);
            console.log(err)
        }
        console.log(resp)
        console.log('pool: '+ pool);
        if(resp.rows==0){
            pool.query('INSERT INTO person(idnumber,person_name,lastname) VALUES ($1,$2,$3)', [data.idnumber,data.name,data.lastname], (err, resp) =>{
                if(err){
                    console.log(err)
                }else{
                    return res.send('The user was succesfully created')
                }
            })
        }else{
            return res.send("A user with the given id is already created. Try again!")
        }
    })

    
  });

app.get('/users/:personid',(req,res)=> {
    
    const idnumber = parseInt(req.params.personid);

    pool.query('SELECT * FROM person where idnumber = $1', [idnumber], (err, resp) =>{
        if(err){
            console.log(err)
        }
        console.log(resp)
        if(resp.rows.length!=0){
            hostname = os.networkInterfaces().eth1[0].address;
            data = {
                usersVar: resp.rows,
                host : hostname
            }
            res.render("index", {myData : data})
            /*res.render("index", {usersVar: resp.rows})*/
        }else{
            res.send("There is not any person with that given id")
        }
        
    })
});

app.get("*", (req, res) => res.redirect("/"));

app.listen(4000, function () {
    console.log('Server is running.. on Port 4000');
});