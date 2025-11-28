<%@ page import="model.Cliente" %>
<%@ page import="model.DAO.ClienteDAO" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Login - iCandy</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        
        /* Container principal */
        .container {
            max-width: 500px;
            width: 100%;
        }
        
        /* Header com logo */
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo-img {
            height: 80px;
            width: auto;
        }
        
        /* Card de mensagem */
        .mensagem-card {
            background: white;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        /* Ícone de erro */
        .icone-erro {
            font-size: 60px;
            margin-bottom: 20px;
            color: #D9534F;
        }
        
        /* Título */
        h3 {
            color: #D9534F;
            font-size: 24px;
            font-weight: normal;
            margin-bottom: 20px;
        }
        
        /* Texto */
        p {
            color: #666;
            font-size: 16px;
            margin-bottom: 30px;
        }
        
        /* Botão */
        .btn {
            display: inline-block;
            padding: 12px 40px;
            background-color: #A67C52;
            color: white;
            text-decoration: none;
            font-size: 16px;
            font-family: 'Georgia', serif;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn:hover {
            background-color: #8B6342;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>
    <%
        if(request.getMethod().equalsIgnoreCase("POST")) {
            String email = request.getParameter("email");
            String senha = request.getParameter("senha");
            
            ClienteDAO dao = new ClienteDAO();
            Cliente cliente = dao.validarLogin(email, senha);
            
            if(cliente != null) {
                session.setAttribute("clienteLogado", cliente);
                response.sendRedirect("home/home.jsp");
            } else {
    %>
    
    <div class="container">
        <!-- Card de erro -->
        <div class="mensagem-card">
            <h3>Email ou senha incorretos</h3>
            <p>Verifique suas credenciais e tente novamente.</p>
            <a href="index.html" class="btn">Tentar novamente</a>
        </div>
    </div>
    
    <%
            }
        } else {
            response.sendRedirect("index.html");
        }
    %>
</body>
</html>