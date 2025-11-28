<%-- 
    Document   : editar_perfil
    Created on : 20 de nov. de 2025, 08:13:26
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
    <title>Editar Perfil - iCandy</title>
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
        
        input[type="text"],
        input[type="email"] {
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
        }
        
        .btn-buscar:hover {
            background-color: #8B6342;
        }
        
        /* Mensagem do CEP */
        #msg {
            color: #A67C52;
            font-size: 14px;
            margin-left: 10px;
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
        
        .mensagem p {
            color: #A67C52;
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
    </style>
</head>
<body>
   
    <div class="header">
        <img src="../imagem/logo.png" alt="iCandy Logo" class="logo-img">
    </div>
    
    <div class="container">
        <h2>Editar Perfil</h2>
        
        <%
            if (request.getMethod().equalsIgnoreCase("POST")) {
                
                cliente.setNome(request.getParameter("nome"));
                cliente.setEmail(request.getParameter("email"));
                cliente.setCep(request.getParameter("cep"));
                cliente.setRua(request.getParameter("rua"));
                cliente.setNumero(request.getParameter("numero"));
                cliente.setBairro(request.getParameter("bairro"));
                cliente.setComplemento(request.getParameter("complemento"));
                cliente.setCidade(request.getParameter("cidade"));
                
                ClienteDAO dao = new ClienteDAO();
                
                if (dao.atualizar(cliente)) {
                    session.setAttribute("clienteLogado", cliente);
        %>
                    <div class="mensagem">
                        <p>Dados atualizados com sucesso!</p>
                        <a href="perfil.jsp">Voltar para o perfil</a>
                    </div>
        <%
                } else {
        %>
                    <div class="mensagem">
                        <p>Erro ao atualizar dados</p>
                        <a href="editar_perfil.jsp">Tentar novamente</a>
                    </div>
        <%
                }
            } else {
        %>
        
        <!-- Formulário com os dados do cliente -->
        <form action="editar_perfil.jsp" method="post">
            
            <label for="nome">Nome Completo:</label>
            <input type="text" id="nome" name="nome" value="<%= cliente.getNome() %>" required>
                   
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="<%= cliente.getEmail() %>" required>
            
            <label for="cep">CEP:</label>
            <div class="cep-group">
                <input type="text" id="cep" name="cep" value="<%= cliente.getCep() %>" maxlength="9" required>
                <button type="button" class="btn-buscar" onclick="buscarCEP()">Buscar</button>
                <span id="msg"></span>
            </div>
            
            <label for="rua">Rua:</label>
            <input type="text" id="rua" name="rua" value="<%= cliente.getRua() %>" required>
            
            <label for="numero">Número:</label>
            <input type="text" id="numero" name="numero" value="<%= cliente.getNumero() %>" required>
            
            <label for="bairro">Bairro:</label>
            <input type="text" id="bairro" name="bairro" value="<%= cliente.getBairro() %>" required>
            
            <label for="complemento">Complemento:</label>
            <input type="text" id="complemento" name="complemento" value="<%= cliente.getComplemento() != null ? cliente.getComplemento() : "" %>">

            <label for="cidade">Cidade:</label>
            <input type="text" id="cidade" name="cidade" value="<%= cliente.getCidade() %>" required>

            <div class="botoes">
                <button type="submit">Salvar Alterações</button>
                <a href="perfil.jsp" class="btn-link">Cancelar</a>
            </div>
        </form>
        
        <%
            }
        %>
    </div>
    
    <script>
        /**
         * Função que busca o endereço pelo CEP
         */
        function buscarCEP() {
            var cep = document.getElementById('cep').value.replace(/\D/g, '');
            var msg = document.getElementById('msg');
            
            if (cep.length != 8) {
                msg.innerHTML = 'CEP inválido';
                return;
            }
            
            msg.innerHTML = 'Buscando...';
            
            fetch('../cadastro/cadastro.jsp?action=buscarCep&cep=' + cep)
                .then(response => response.json())
                .then(data => {
                    if (!data.erro) {
                        document.getElementById('rua').value = data.logradouro;
                        document.getElementById('bairro').value = data.bairro;
                        document.getElementById('cidade').value = data.localidade;
                        msg.innerHTML = 'OK';
                    } else {
                        msg.innerHTML = 'Não encontrado';
                    }
                })
                .catch(error => {
                    msg.innerHTML = 'Erro';
                });
        }
    </script>
</body>
</html>