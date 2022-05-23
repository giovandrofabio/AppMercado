import express from "express";
import cors from "cors";
import db from "./config/database.js";
import controllerMercados from "./controllers/controller.mercados.js";
import controllerUsuarios from "./controllers/controller.usuarios.js";

const app = express();

//Middleware JSON
app.use(express.json());

//Middleware CORS
app.use(cors());

//Controllers
app.use(controllerUsuarios);
app.use(controllerMercados);

/*
    Verbos HTTP:
    -------------------------
    GET -> Retornar dados
    POST -> Cadastrar dados
    PUT -> Editar dados
    DELETE -> Excluir dados
*/

app.listen(3000, function(){
    console.log('Servidor no ar.');
});