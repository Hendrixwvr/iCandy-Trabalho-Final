<%-- 
    Document   : alterar_senha
    Created on : 20 de nov. de 2025, 08:13:51
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
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Alterar Senha - iCandy</title>
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
            max-width: 600px;
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
            padding-bottom: 15px;
            border-bottom: 2px solid #A67C52;
            margin-bottom: 30px;
        }
        
        /* Formulário */
        label {
            display: block;
            color: #A67C52;
            font-size: 16px;
            margin-bottom: 8px;
            margin-top: 20px;
        }
        
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #CCC;
            background: white;
            font-size: 14px;
            font-family: 'Georgia', serif;
        }
        
        input:focus {
            outline: none;
            border-color: #A67C52;
        }
        
        /* Botões */
        .botoes {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        
        button,
        .btn-link {
            padding: 12px 30px;
            border: none;
            font-size: 16px;
            cursor: pointer;
            font-family: 'Georgia', serif;
            text-decoration: none;
            display: inline-block;
        }
        
        button {
            background-color: #A67C52;
            color: white;
        }
        
        button:hover {
            background-color: #8B6342;
        }
        
        .btn-link {
            background-color: #CCC;
            color: #333;
        }
        
        .btn-link:hover {
            background-color: #AAA;
        }
        
        /* Mensagens */
        .mensagem {
            text-align: center;
            padding: 20px;
            margin: 20px 0;
        }
        
        .mensagem.sucesso p {
            color: #5CB85C;
            font-size: 18px;
            margin-bottom: 15px;
        }
        
        .mensagem.erro p {
            color: #D9534F;
            font-size: 18px;
            margin-bottom: 15px;
        }
        
        .mensagem a {
            color: #A67C52;
            text-decoration: none;
        }
        
        .mensagem a:hover {
            text-decoration: underline;
        }
         
        /* Dicas de segurança */ 
        .dicas { 
            background-color: #FFF3CD;
            border-left: 4px solid #A67C52;
            padding: 15px;
            margin-top: 30px;
        }
        
        .dicas h4 {
            color: #A67C52;
            font-size: 16px;
            margin-bottom: 10px;
        }
        
        .dicas ul {
            margin-left: 20px;
            color: #666;
        }
        
        .dicas li {
            margin: 5px 0;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <!-- Header com logo -->
    <div class="header">
        <img src="../imagem/logo.png" alt="iCandy Logo" class="logo-img">
    </div>
    
    <div class="container">
        <h2>Alterar Senha</h2>
        
        <%
            if (request.getMethod().equalsIgnoreCase("POST")) {
                
                String senhaAtual = request.getParameter("senha_atual");
                String novaSenha = request.getParameter("nova_senha");
                String confirmarSenha = request.getParameter("confirmar_senha");
                
                // Valida se a nova senha e a confirmação são iguais
                if (!novaSenha.equals(confirmarSenha)) {
        %>
                    <div class="mensagem erro">
                        <p>❌ Erro: As senhas não coincidem</p>
                        <a href="alterar_senha.jsp">Tentar novamente</a>
                    </div>
        <%
                } else {
                    ClienteDAO dao = new ClienteDAO();
                    
                    if (dao.atualizarSenha(cliente.getId(), senhaAtual, novaSenha)) {
        %>
                    <div class="mensagem sucesso">
                        <p>✓ Senha alterada com sucesso!</p>
                        <a href="perfil.jsp">Voltar para o perfil</a>
                    </div>
        <%
                    } else {
        %>
                    <div class="mensagem erro">
                        <p>❌ Erro: Senha atual incorreta</p>
                        <a href="alterar_senha.jsp">Tentar novamente</a>
                    </div>
        <%
                    }
                }
            } else {
        %>
        
        <!-- Formulário para alterar senha -->
        <form action="alterar_senha.jsp" method="post">
          
            <label for="senha_atual">Senha Atual:</label>
            <input type="password" id="senha_atual" name="senha_atual" required>
            
       
            <label for="nova_senha">Nova Senha:</label>
            <input type="password" id="nova_senha" name="nova_senha" required>
            
           
            <label for="confirmar_senha">Confirmar Nova Senha:</label>
            <input type="password" id="confirmar_senha" name="confirmar_senha" required>
            
           
            <div class="botoes">
                <button type="submit">Alterar Senha</button>
                <a href="perfil.jsp" class="btn-link">Cancelar</a>
            </div>
        </form>
        
        
        <div class="dicas">
            <h4>💡 Dicas para uma senha segura:</h4>
            <ul>
                <li>Use pelo menos 8 caracteres</li>
                <li>Combine letras maiúsculas e minúsculas</li>
                <li>Inclua números e caracteres especiais</li>
                <li>Não use informações pessoais óbvias</li>
                <li>Evite senhas que você já usou antes</li>
            </ul>
        </div>
        
        <%
            }
        %>
    </div>
</body>
</html>