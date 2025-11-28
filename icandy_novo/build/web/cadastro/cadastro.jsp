<%@ page import="model.Cliente" %>
<%@ page import="model.DAO.ClienteDAO" %>
<%@ page import="config.MD5Util" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URI" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    String action = request.getParameter("action");
    
    if("buscarCep".equals(action)) {
        response.setContentType("application/json");
        String cep = request.getParameter("cep");
        
        if(cep != null && !cep.trim().isEmpty()){
            cep = cep.replaceAll("[^0-9]", "");
            String urlCEP = "https://viacep.com.br/ws/" + cep + "/json/";
        
            try{
                URL url = URI.create(urlCEP).toURL();
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                
                if (conn.getResponseCode() == HttpURLConnection.HTTP_OK){
                    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    String linha;
                    StringBuilder resposta = new StringBuilder();
                    
                    while ((linha = in.readLine()) != null){
                        resposta.append(linha);
                    }
                    in.close();
                    
                    JSONObject json = new JSONObject(resposta.toString());
                    
                    if (json.has("erro")){
                        out.print("{\"erro\": true}");
                    } else {
                        out.print(resposta.toString());
                    }
                }
            } catch (Exception ex){
                out.print("{\"erro\": true}");
            }
        }
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cadastro - iCandy</title>
    <style>
      
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        /* Corpo da página */
        body {
            font-family: 'Georgia', serif;
            background-color: #FAF7F2;
            padding: 40px 20px;
        }
        
        /* Container do formulário */
        .cadastro-container {
            max-width: 600px;
            margin: 0 auto;
        }
        
        /* Título com linha */
        h2 {
            color: #A67C52;
            font-size: 28px;
            font-weight: normal;
            text-align: center;
            padding-bottom: 15px;
            border-bottom: 2px solid #A67C52;
            margin-bottom: 40px;
        }
        
        /* Labels */
        label {
            display: block;
            color: #A67C52;
            font-size: 16px;
            margin-bottom: 8px;
            margin-top: 20px;
        }
        
        /* Campos de entrada */
        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #CCC;
            background: white;
            font-size: 14px;
            font-family: 'Georgia', serif;
        }
        
        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #A67C52;
        }
        
        /* Grupo de campos (CEP com botão) */
        .cep-group {
            display: flex;
            gap: 10px;
            align-items: flex-end;
        }
        
        .cep-group input {
            flex: 1;
        }
        
        .btn-buscar {
            padding: 10px 20px;
            background-color: #A67C52;
            color: white;
            border: none;
            cursor: pointer;
            font-family: 'Georgia', serif;
            white-space: nowrap;
            transition: all 0.3s ease;
        }
        
        .btn-buscar:hover {
            background-color: #8B6342;
        }
        
        /* Mensagem do CEP */
        #msg {
            color: #A67C52;
            font-size: 14px;
            margin-left: 10px;
            font-weight: bold;
        }
        
        /* Botão Cadastrar */
        .btn-cadastrar {
            display: block;
            width: 200px;
            margin: 40px auto 20px;
            padding: 12px 30px;
            background-color: #A67C52;
            color: white;
            border: none;
            font-size: 18px;
            cursor: pointer;
            font-family: 'Georgia', serif;
            transition: all 0.3s ease;
        }
        
        .btn-cadastrar:hover {
            background-color: #8B6342;
        }
        
        /* Link voltar */
        .voltar {
            text-align: center;
            margin-top: 20px;
        }
        
        .voltar a {
            color: #A67C52;
            text-decoration: none;
            font-size: 16px;
        }
        
        .voltar a:hover {
            text-decoration: underline;
        }
        
        /* Mensagem de sucesso/erro */
        .mensagem {
            text-align: center;
            padding: 30px;
            margin: 20px 0;
        }
        
        .mensagem h3 {
            color: #A67C52;
            font-size: 24px;
            font-weight: normal;
            margin-bottom: 20px;
        }
        
        .mensagem a {
            color: #A67C52;
            text-decoration: none;
            font-size: 16px;
            padding: 10px 20px;
            border: 2px solid #A67C52;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .mensagem a:hover {
            background-color: #A67C52;
            color: white;
        }
    </style>
</head>
<body>
    <%
        if(request.getMethod().equalsIgnoreCase("POST")) {
            Cliente cli = new Cliente();
            cli.setNome(request.getParameter("nome"));
            cli.setEmail(request.getParameter("email"));
            cli.setCep(request.getParameter("cep"));
            cli.setSenha(request.getParameter("senha"));
            cli.setRua(request.getParameter("endereco"));
            cli.setNumero(request.getParameter("numero"));
            cli.setBairro(request.getParameter("bairro"));
            cli.setComplemento(request.getParameter("complemento"));
            cli.setCidade(request.getParameter("cidade"));
            
            ClienteDAO dao = new ClienteDAO();
            
            if(dao.cadastrar(cli)) {
    %>
                <div class="mensagem">
                    <h3>✓ Cliente cadastrado com sucesso!</h3>
                    <a href="../index.html">Ir para Login</a>
                </div>
    <%
            } else {
    %>
                <div class="mensagem">
                    <h3>✗ Erro ao cadastrar</h3>
                    <a href="cadastro.html">Tentar novamente</a>
                </div>
    <%
            }
        } else {
            response.sendRedirect("cadastro.html");
        }
    %>
</body>
</html>