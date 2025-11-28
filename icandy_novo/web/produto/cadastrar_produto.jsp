<%@ page import="model.Produto" %>
<%@ page import="model.DAO.ProdutoDAO" %>
<%@ page import="model.Cliente" %>
<%@ page import="jakarta.servlet.http.Part" %>
<%@ page import="java.io.InputStream" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    Cliente cliente = (Cliente) session.getAttribute("clienteLogado");
    
    if(cliente == null) {
        response.sendRedirect("../index.html");
        return;
    }
    
    if(!cliente.isAdmin()) {
        response.sendRedirect("../home/home.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cadastrar Produto - iCandy</title>
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
        input[type="number"],
        input[type="file"],
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #CCC;
            background: white;
            font-size: 14px;
            font-family: 'Georgia', serif;
        }
        
        input[type="file"] {
            padding: 8px;
        }
        
        input:focus,
        textarea:focus {
            outline: none;
            border-color: #A67C52;
        }
        
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        /* imagem */
        .preview-container {
            margin-top: 10px;
            text-align: center;
        }
        
        #preview-img {
            max-width: 300px;
            max-height: 300px;
            display: none;
            margin: 10px auto;
            border: 2px solid #A67C52;
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
        <h2>Cadastrar Produto</h2>
        
        <%
            if(request.getMethod().equalsIgnoreCase("POST")) {
                
                
                Part filePart = request.getPart("imagem");
                
                Produto p = new Produto();
                p.setNome(request.getParameter("nome"));
                p.setDescricao(request.getParameter("descricao"));
                p.setPreco(Double.parseDouble(request.getParameter("preco")));
                p.setEstoque(Integer.parseInt(request.getParameter("estoque")));
                
           
                if (filePart != null && filePart.getSize() > 0) {
                    try (InputStream inputStream = filePart.getInputStream()) {
                        byte[] imagemBytes = inputStream.readAllBytes();
                        p.setImagemBlob(imagemBytes);
                    }
                }
                
                ProdutoDAO dao = new ProdutoDAO();
                
                if(dao.cadastrar(p)) {
        %>
                    <div class="mensagem">
                        <p>Produto cadastrado com sucesso!</p>
                        <a href="listar_produtos.jsp">Ver produtos</a>
                    </div>
        <%
                } else {
        %>
                    <div class="mensagem">
                        <p>Erro ao cadastrar produto</p>
                        <a href="cadastrar_produto.jsp">Tentar novamente</a>
                    </div>
        <%
                }
            } else {
        %>
        
        <form action="cadastrar_produto.jsp" method="post" enctype="multipart/form-data">
            <label for="nome">Nome do Produto:</label>
            <input type="text" id="nome" name="nome" required>
            
            <label for="descricao">Descrição:</label>
            <textarea id="descricao" name="descricao"></textarea>
            
            <label for="preco">Preço (R$):</label>
            <input type="number" id="preco" name="preco" step="0.01" required>
            
            <label for="estoque">Estoque:</label>
            <input type="number" id="estoque" name="estoque" required>
            
            <label for="imagem">Imagem do Produto:</label>
            <input type="file" id="imagem" name="imagem" accept="image/*" onchange="previewImagem(event)">
            
            <!-- Preview da imagem -->
            <div class="preview-container">
                <img id="preview-img" alt="Preview">
            </div>
            
            <div class="botoes">
                <button type="submit">Cadastrar</button>
                <a href="listar_produtos.jsp" class="btn-link">Cancelar</a>
            </div>
        </form>
        
        <script>
           
            function previewImagem(event) {
                const file = event.target.files[0];
                const preview = document.getElementById('preview-img');
                
                if (file) {
                    const reader = new FileReader();
                    
                    reader.onload = function(e) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                    }
                    
                    reader.readAsDataURL(file);
                } else {
                    preview.style.display = 'none';
                }
            }
        </script>
        
        <%
            }
        %>
    </div>
</body>
</html>