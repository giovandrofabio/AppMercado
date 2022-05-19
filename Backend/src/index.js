import express from 'express';

const app = express();

//Middleware JSON
app.use(express.json());

/*
    Verbos HTTP:
    -------------------------
    GET -> Retornar dados
    POST -> Cadastrar dados
    PUT -> Editar dados
    DELETE -> Excluir dados
*/

//Query Params...
app.get("/clientes", function(request, response){
    return response.send("Listando todos os clientes ordenados por: " + request.query.ordem + 
    " listando e apenas " + request.query.top + " registros");    
});

//URI Params...
app.get("/clientes/:id", function(request, response){
    return response.send("Listando somente o cliente: " + request.params.id);    
});

app.post("/clientes", function(request, response){
    const body = request.body
    return response.send("Novo cliente: " + body.nome + " - " +
    body.email);    
});

app.put("/clientes", function(request, response){
    return response.send("Alterando um cliente com PUT");    
});

app.patch("/clientes", function(request, response){
    return response.send("Alterando um cliente com PATCH");    
});

app.delete("/clientes", function(request, response){
    return response.send("Excluindo Clientes");    
});

app.listen(3000, function(){
    console.log('Servidor no ar.');
});