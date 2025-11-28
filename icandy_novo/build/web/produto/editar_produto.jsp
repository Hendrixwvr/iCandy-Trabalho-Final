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
    

    boolean isPost = request.getMethod().equalsIgnoreCase("POST");
    String contentType = request.getContentType();
    boolean isMultipart = contentType != null && contentType.toLowerCase().startsWith("multipart/form-data");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Produto - iCandy</title>
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
        
        /* Imagem atual */
        .imagem-atual {
            text-align: center;
            margin: 20px 0;
        }
        
        .imagem-atual img {
            max-width: 300px;
            max-height: 300px;
            border: 2px solid #A67C52;
        }
        
        .imagem-atual p {
            color: #A67C52;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
 
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
        <h2>Editar Produto</h2>
        
        <%
            if(isPost && isMultipart) {
                // Processa o formulário com upload
                
                Part idPart = request.getPart("id");
                int id = Integer.parseInt(new String(idPart.getInputStream().readAllBytes()));
                
                Part nomePart = request.getPart("nome");
                String nome = new String(nomePart.getInputStream().readAllBytes());
                
                Part descricaoPart = request.getPart("descricao");
                String descricao = new String(descricaoPart.getInputStream().readAllBytes());
                
                Part precoPart = request.getPart("preco");
                double preco = Double.parseDouble(new String(precoPart.getInputStream().readAllBytes()));
                
                Part estoquePart = request.getPart("estoque");
                int estoque = Integer.parseInt(new String(estoquePart.getInputStream().readAllBytes()));
                
                Produto p = new Produto();
                p.setId(id);
                p.setNome(nome);
                p.setDescricao(descricao);
                p.setPreco(preco);
                p.setEstoque(estoque);
                
                // Processa a nova imagem se foi enviada
                Part filePart = request.getPart("imagem");
                
                if (filePart != null && filePart.getSize() > 0) {
                
                    try (InputStream inputStream = filePart.getInputStream()) {
                        byte[] imagemBytes = inputStream.readAllBytes();
                        p.setImagemBlob(imagemBytes);
                    }
                } else {
                 
                    ProdutoDAO daoTemp = new ProdutoDAO();
                    byte[] imagemAntiga = daoTemp.buscarImagem(id);
                    p.setImagemBlob(imagemAntiga);
                }
                
                ProdutoDAO dao = new ProdutoDAO();
                
                if(dao.atualizar(p)) {
        %>
                    <div class="mensagem">
                        <p>Produto atualizado com sucesso!</p>
                        <a href="listar_produtos.jsp">Ver produtos</a>
                    </div>
        <%
                } else {
        %>
                    <div class="mensagem">
                        <p>Erro ao atualizar produto</p>
                        <a href="editar_produto.jsp?id=<%= p.getId() %>">Tentar novamente</a>
                    </div>
        <%
                }
            } else {
               
                String idParam = request.getParameter("id");
                
                if(idParam == null || idParam.isEmpty()) {
        %>
                    <div class="mensagem">
                        <p>ID do produto não informado</p>
                        <a href="listar_produtos.jsp">Voltar</a>
                    </div>
        <%
                } else {
                    int id = Integer.parseInt(idParam);
                    ProdutoDAO dao = new ProdutoDAO();
                    Produto p = dao.buscarPorId(id);
                    
                    if(p == null) {
        %>
                        <div class="mensagem">
                            <p>Produto não encontrado</p>
                            <a href="listar_produtos.jsp">Voltar</a>
                        </div>
        <%
                    } else {
        %>
        
        <form action="editar_produto.jsp" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%= p.getId() %>">
            
            <label for="nome">Nome do Produto:</label>
            <input type="text" id="nome" name="nome" value="<%= p.getNome() %>" required>
            
            <label for="descricao">Descrição:</label>
            <textarea id="descricao" name="descricao"><%= p.getDescricao() != null ? p.getDescricao() : "" %></textarea>
            
            <label for="preco">Preço (R$):</label>
            <input type="number" id="preco" name="preco" step="0.01" value="<%= p.getPreco() %>" required>
            
            <label for="estoque">Estoque:</label>
            <input type="number" id="estoque" name="estoque" value="<%= p.getEstoque() %>" required>
            
            <!-- Mostra a imagem atual -->
            <%
                if(dao.temImagem(p.getId())) {
            %>
            <div class="imagem-atual">
                <p><strong>Imagem Atual:</strong></p>
                <img src="<%= request.getContextPath() %>/imagem-produto?id=<%= p.getId() %>" alt="Imagem atual">
            </div>
            <%
                }
            %>
            
            <label for="imagem">Nova Imagem (deixe em branco para manter a atual):</label>
            <input type="file" id="imagem" name="imagem" accept="image/*" onchange="previewImagem(event)">
            
         
            <div class="preview-container">
                <img id="preview-img" alt="Preview">
            </div>
            
            <div class="botoes">
                <button type="submit">Atualizar</button>
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
                }
            }
        %>
    </div>
</body>
</html>