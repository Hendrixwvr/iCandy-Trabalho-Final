<%-- 
    Document   : excluir_conta
    Created on : 20 de nov. de 2025, 08:14:07
    Author     : hendrix_kauane_murilo
--%>
<%@ page import="model.Cliente" %>
<%@ page import="model.DAO.ClienteDAO" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    Cliente cliente = (Cliente) session.getAttribute("clienteLogado");
    
    if (cliente == null) {
        response.sendRedirect("../index.html");
        return;
    }
    
    ClienteDAO dao = new ClienteDAO();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Excluir Conta - iCandy</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        
        /* Container principal */
        .container {
            max-width: 600px;
            text-align: center;
        }
        
        /* Header com logo */
        .header {
            background-color: #A67C52;
            padding: 15px 0;
            text-align: center;
            margin-bottom: 40px;
        }
        
        .logo-img {
            height: 60px;
            width: auto;
        }
        
        /* Card de mensagem */
        .mensagem-card {
            background: white;
            padding: 50px 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        /* Ícone */
        .icone {
            font-size: 80px;
            margin-bottom: 20px;
        }
        
        /* Título */
        h2 {
            color: #A67C52;
            font-size: 28px;
            font-weight: normal;
            margin-bottom: 20px;
        }
        
        h2.erro {
            color: #D9534F;
        }
        
        /* Texto */
        p {
            color: #666;
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        
  
        .btn-login,
        .btn-voltar {
            display: inline-block;
            padding: 12px 40px;
            background-color: #A67C52;
            color: white;
            text-decoration: none;
            font-size: 16px;
            font-family: 'Georgia', serif;
            transition: all 0.3s ease;
        }
        
        .btn-login:hover,
        .btn-voltar:hover {
            background-color: #8B6342;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>
    <div class="header">
        <img src="../imagem/logo.png" alt="iCandy Logo" class="logo-img">
    </div>
    
    <div class="container">
        <%
            try {
                if (dao.deletar(cliente.getId())) {
                    // Sucesso 
                    session.removeAttribute("clienteLogado");
                    session.invalidate();
        %>
                    <div class="mensagem-card">
                        <div class="icone">👋</div>
                        <h2>Conta excluída com sucesso</h2>
                        <p>Sua conta foi removida do sistema.<br>
                        Esperamos vê-lo novamente em breve!</p>
                        <a href="../index.html" class="btn-login">Ir para o Login</a>
                    </div>
        <%
                } else {
                    // Falha - cliente tem pedidos
        %>
                    <div class="mensagem-card">
                        <div class="icone">⚠️</div>
                        <h2 class="erro">Não é possível excluir a conta</h2>
                        <p>Sua conta possui pedidos vinculados e não pode ser excluída.<br><br>
                        <strong>Motivo:</strong> Para manter o histórico de pedidos, contas com pedidos não podem ser removidas.<br><br>
                        Se desejar parar de usar o sistema, você pode simplesmente fazer logout.</p>
                        <a href="perfil.jsp" class="btn-voltar">Voltar para o perfil</a>
                    </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
                <div class="mensagem-card">
                    <div class="icone">❌</div>
                    <h2 class="erro">Erro ao excluir conta</h2>
                    <p>Ocorreu um erro ao tentar excluir sua conta.<br>
                    Por favor, tente novamente mais tarde.<br><br>
                    <strong>Detalhes técnicos:</strong> <%= e.getMessage() %></p>
                    <a href="perfil.jsp" class="btn-voltar">Voltar para o perfil</a>
                </div>
        <%
            }
        %>
    </div>
</body>
</html>