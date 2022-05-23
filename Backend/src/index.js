import express from "express";
import cors from "cors";
import db from "./config/database.js";
//import controllerMercados from "./controllers/controller.mercados.js";
//import {controllerUsuarios} from "./controllers/controller.usuarios.js";

const app = express();

//Middleware JSON
app.use(express.json());

//Middleware CORS
app.use(cors());

//Controllers
//app.use(controllerUsuarios);
//app.use(controllerMercados);

/*
    Verbos HTTP:
    -------------------------
    GET -> Retornar dados
    POST -> Cadastrar dados
    PUT -> Editar dados
    DELETE -> Excluir dados
*/
//Query Params...
app.get("/usuarios", function(request, response){

    let ssql = "select * from usuario"
    db.query(ssql, function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(200).json(result);
        }
    })    
});

//URI Params...
app.get("/usuarios/:id_usuario", function(request, response){

    let ssql = "select * from usuario where id_usuario = ?"
    db.query(ssql, [request.params.id_usuario], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(result.length > 0 ? 200 : 404).json(result[0]);
        }
    })    
});

app.post("/usuarios/login", function(request, response){
    
    let ssql = "select id_usuario, nome, email, endereco, bairro, uf, cep, "
    ssql += "date_format(dt_cadastro, '%d/%m/%Y %H:%i:%s') as dt_cadastro "
    ssql += " from usuario where email=? and senha=?"

    db.query(ssql, [request.body.email, request.body.senha], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(result.length > 0 ? 200 : 401).json(result[0]);
        }
    })    
});

app.post("/usuarios/cadastro", function(request, response){
    let body = request.body 
    let ssql = "INSERT INTO usuario (nome, email, senha, endereco, bairro, cidade, uf, cep, dt_cadastro) "
    ssql += " VALUES(?,?,?,?,?,?,?,?,current_timestamp()) "
 
    db.query(ssql, [body.nome,
                    body.email,
                    body.senha,
                    body.endereco,
                    body.bairro,
                    body.cidade,
                    body.uf,
                    body.cep], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(201).json({id_usuario: result.insertId});
        }
    })    
});

app.put("/usuarios/:id_usuario", function(request, response){
    let body = request.body 
    let ssql = "UPDATE usuario SET nome=?, email=?, senha=?, endereco=?, bairro=?, cidade=?, uf=?, cep=? "
    ssql += " WHERE id_usuario = ? "
 
    db.query(ssql, [body.nome,
                    body.email,
                    body.senha,
                    body.endereco,
                    body.bairro,
                    body.cidade,
                    body.uf,
                    body.cep,
                    request.params.id_usuario,], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(200).json({id_usuario: request.params.id_usuario});
        }
    })    
});

app.delete("/usuarios/:id", function(request, response){
    let body = request.body 
    let ssql = "DELETE FROM usuarios WHERE id_usuario = ? "
 
    db.query(ssql, [request.params.id,], function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(result.length > 0 ? 200 : 401).json(result[0]);
        }
    })    
});

app.get("/mercados", function(request, response){

    let filtro = [];
    let ssql = "select * from mercado ";
    ssql += "where id_mercado >0";

    if(request.query.busca){
        ssql += "and nome =? ";
        filtro.push(request.query.busca);    
    }

    if(request.query.ind_entrega){
        ssql += "and ind_entrega =? ";
        filtro.push(request.query.ind_entrega);    
    } 

    if(request.query.ind_retira){
        ssql += "and ind_retira =? ";
        filtro.push(request.query.ind_retira);    
    }     

    db.query(ssql, filtro,function(err, result){
        if (err){
            return response.status(500).send(err);
        }else{
            return response.status(200).json(result);
        }
    })    
});

app.listen(3000, function(){
    console.log('Servidor no ar.');
});