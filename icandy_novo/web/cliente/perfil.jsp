<%@ page import="model.Cliente" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    Cliente cliente = (Cliente) session.getAttribute("clienteLogado");
    
    if (cliente == null) {
        response.sendRedirect("../index.html");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Meu Perfil - iCandy</title>
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
            padding: 20px;
        }
        
        /* Container principal */
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        /* Header com logo */
        .header {
            background-color: #A67C52;
            padding: 15px 0;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo-img {
            height: 60px;
            width: auto;
        }
        
        /* Título */
        h2 {
            color: #A67C52;
            font-size: 28px;
            font-weight: normal;
            text-align: center;
            margin-bottom: 30px;
        }
        
        /* Navegação */
        .navegacao {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .navegacao a {
            color: #A67C52;
            text-decoration: none;
            font-size: 16px;
        }
        
        .navegacao a:hover {
            text-decoration: underline;
        }
        
   
        .info-card {
            background: white;
            padding: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .info-card h3 {
            color: #A67C52;
            font-size: 20px;
            font-weight: normal;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #E0E0E0;
        }
        
        .info-linha {
            display: flex;
            padding: 10px 0;
            border-bottom: 1px solid #F5F5F5;
        }
        
        .info-label {
            color: #A67C52;
            font-weight: bold;
            width: 150px;
            flex-shrink: 0;
        }
        
        .info-valor {
            color: #666;
        }
        
        /* Botões */
        .acoes {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            font-size: 16px;
            cursor: pointer;
            font-family: 'Georgia', serif;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-editar {
            background-color: #A67C52;
            color: white;
        }
        
        .btn-editar:hover {
            background-color: #8B6342;
        }
        
        .btn-senha {
            background-color: #CCC;
            color: #333;
        }
        
        .btn-senha:hover {
            background-color: #AAA;
        }
        
        .btn-excluir {
            background-color: #D9534F;
            color: white;
        }
        
        .btn-excluir:hover {
            background-color: #C9302C;
        }
    </style>
</head>
<body>
 
    <div class="header">
        <img src="../imagem/logo.png" alt="iCandy Logo" class="logo-img">
    </div>
    
    <div class="container">
        <h2>Meu Perfil</h2>
        
        <div class="navegacao">
            <a href="../home/home.jsp">Voltar para Home</a>
        </div>
        
        <div class="info-card">
            <h3>Dados Pessoais</h3>
            
            <div class="info-linha">
                <span class="info-label">Nome:</span>
                <span class="info-valor"><%= cliente.getNome() %></span>
            </div>
            
            <div class="info-linha">
                <span class="info-label">Email:</span>
                <span class="info-valor"><%= cliente.getEmail() %></span>
            </div>
            
            <div class="info-linha">
                <span class="info-label">Tipo:</span>
                <span class="info-valor"><%= cliente.isAdmin() ? "Administrador" : "Cliente" %></span>
            </div>
        </div>
        
        <div class="info-card">
            <h3>Endereço</h3>
            
            <div class="info-linha">
                <span class="info-label">CEP:</span>
                <span class="info-valor"><%= cliente.getCep() %></span>
            </div>
            
            <div class="info-linha">
                <span class="info-label">Rua:</span>
                <span class="info-valor"><%= cliente.getRua() %>, <%= cliente.getNumero() %></span>
            </div>
            
            <% if(cliente.getComplemento() != null && !cliente.getComplemento().isEmpty()) { %>
            <div class="info-linha">
                <span class="info-label">Complemento:</span>
                <span class="info-valor"><%= cliente.getComplemento() %></span>
            </div>
            <% } %>
            
            <div class="info-linha">
                <span class="info-label">Bairro:</span>
                <span class="info-valor"><%= cliente.getBairro() %></span>
            </div>
            
            <div class="info-linha">
                <span class="info-label">Cidade:</span>
                <span class="info-valor"><%= cliente.getCidade() %></span>
            </div>
        </div>
        
        <div class="acoes">
            <a href="editar_perfil.jsp" class="btn btn-editar">Editar Dados</a>
            <a href="alterar_senha.jsp" class="btn btn-senha">Alterar Senha</a>
            <a href="excluir_conta.jsp" class="btn btn-excluir" onclick="return confirm('Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita!')">Excluir Conta</a>
        </div>
    </div>
</body>
</html>