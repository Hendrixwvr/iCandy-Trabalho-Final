<%@ page import="model.Produto" %>
<%@ page import="model.DAO.ProdutoDAO" %>
<%@ page import="model.Cliente" %>
<%@ page import="java.util.List" %>
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
    <title>Gerenciar Produtos - iCandy</title>
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
            max-width: 1200px;
            margin: 0 auto;
        }
        
  
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
        
        /* Título da página */
        h2 {
            color: #A67C52;
            font-size: 28px;
            font-weight: normal;
            margin-bottom: 20px;
            text-align: center;
        }
        
        /* Links de navegação */
        .navegacao {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .navegacao a {
            color: #A67C52;
            text-decoration: none;
            margin: 0 15px;
            font-size: 16px;
        }
        
        .navegacao a:hover {
            text-decoration: underline;
        }
        
        /* Tabela de produtos */
        table {
            width: 100%;
            background: white;
            border-collapse: collapse;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        th {
            background-color: #A67C52;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: normal;
        }
        
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #E0E0E0;
            color: #666;
        }
        
        tr:hover {
            background-color: #F9F9F9;
        }
        
        /* Imagem na tabela */
        td img {
            border-radius: 4px;
            object-fit: cover;
        }
        
        /* Links de ação */
        .acoes a {
            color: #A67C52;
            text-decoration: none;
            margin-right: 10px;
        }
        
        .acoes a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
  
    <div class="header">
        <img src="../imagem/logo.png" alt="iCandy Logo" class="logo-img">
    </div>
    
    <div class="container">
        <h2>Gerenciar Produtos</h2>
        
    
        <div class="navegacao">
            <a href="cadastrar_produto.jsp">Cadastrar novo produto</a> | 
            <a href="../home/home.jsp">Voltar para Home</a>
        </div>
        
      
        <table>
            <tr>
                <th>ID</th>
                <th>Imagem</th>
                <th>Nome</th>
                <th>Descrição</th>
                <th>Preço</th>
                <th>Estoque</th>
                <th>Ações</th>
            </tr>
            
            <%
                ProdutoDAO dao = new ProdutoDAO();
                List<Produto> lista = dao.listar();
                
                if(lista.isEmpty()) {
            %>
                    <tr>
                        <td colspan="7" style="text-align:center;">Nenhum produto cadastrado</td>
                    </tr>
            <%
                } else {
                    for(Produto p : lista) {
            %>
                    <tr>
                        <td><%= p.getId() %></td>
                        <td>
                            <% if(dao.temImagem(p.getId())) { %>
                                <img src="<%= request.getContextPath() %>/imagem-produto?id=<%= p.getId() %>" 
                                     width="80" height="80" style="object-fit:cover;">
                            <% } else { %>
                                <span style="color: #999;">Sem imagem</span>
                            <% } %>
                        </td>
                        <td><%= p.getNome() %></td>
                        <td><%= p.getDescricao() != null ? p.getDescricao() : "-" %></td>
                        <td>R$ <%= String.format("%.2f", p.getPreco()) %></td>
                        <td><%= p.getEstoque() %></td>
                        <td class="acoes">
                            <a href="editar_produto.jsp?id=<%= p.getId() %>">Editar</a>
                            <a href="excluir_produto.jsp?id=<%= p.getId() %>" onclick="return confirm('Tem certeza?')">Excluir</a>
                        </td>
                    </tr>
            <%
                    }
                }
            %>
        </table>
    </div>
</body>
</html>