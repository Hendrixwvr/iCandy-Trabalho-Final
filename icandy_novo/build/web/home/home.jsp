<%-- 
    Author     : hendrix_kauane_murilo
--%>
<%@ page import="model.Cliente" %>
<%@ page import="model.Produto" %>
<%@ page import="model.DAO.ProdutoDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    Cliente cliente = (Cliente) session.getAttribute("clienteLogado");
    
    if(cliente == null) {
        response.sendRedirect("../index.html");
        return;
    }
    
    if(session.getAttribute("carrinho") == null) {
        session.setAttribute("carrinho", new HashMap<Integer, Integer>());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home - iCandy</title>
    <style>
        /* Reset básico */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        /* Corpo da página */
        body {
            font-family: 'Georgia', serif;
            background-color: #FAF7F2;
        }
        
        /* Barra HOME no topo */
        .top-bar {
            background-color: #E8F5F3;
            padding: 8px 0;
            text-align: right;
            padding-right: 40px;
        }
        
        .top-bar span {
            color: #A67C52;
            font-size: 14px;
            letter-spacing: 1px;
        }
        
        /* Header com logo */
        .header {
            background-color: #A67C52;
            padding: 15px 0;
            text-align: center;
        }
        
        .logo-img {
            height: 80px;
            width: auto;
        }
        
        /* Menu de navegação */
        .menu {
            background-color: white;
            border-top: 2px solid #D4A574;
            border-bottom: 2px solid #D4A574;
            padding: 15px 0;
            text-align: center;
        }
        
        .menu a {
            color: #A67C52;
            text-decoration: none;
            margin: 0 20px;
            font-size: 16px;
        }
        
        .menu a:hover {
            text-decoration: underline;
        }
        
        /* Banner principal */
        .banner {
            width: 100%;
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .banner img {
            width: 100%;
            display: block;
        }
        
        /* Container dos produtos */
        .produtos-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        /* Grid de produtos */
        .produtos {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }
        
        /* Card de cada produto */
        .produto {
            background: white;
            text-align: center;
            padding: 20px;
            border: 1px solid #E0E0E0;
        }
        
        /* Imagem do produto */
        .produto img {
            width: 100%;
            height: 250px;
            object-fit: cover;
            margin-bottom: 15px;
        }
        
        .produto .sem-imagem {
            width: 100%;
            height: 250px;
            background: #F0F0F0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #999;
            margin-bottom: 15px;
        }
        
        /* Nome do produto */
        .produto h4 {
            color: #A67C52;
            font-size: 14px;
            text-transform: uppercase;
            margin-bottom: 10px;
            font-weight: normal;
            letter-spacing: 1px;
        }
        
        /* Descrição do produto */
        .produto-descricao {
            color: #666;
            font-size: 13px;
            line-height: 1.5;
            margin: 10px 0;
            text-align: center;
            min-height: 40px;
        }
        
        /* Controles de quantidade (+ e -) */
        .quantidade-controle {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            margin: 15px 0;
        }
        
        .btn-quantidade {
            width: 30px;
            height: 30px;
            background-color: transparent;
            border: 1px solid #A67C52;
            color: #A67C52;
            font-size: 20px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-quantidade:hover {
            background-color: #A67C52;
            color: white;
        }
        
        .quantidade-valor {
            color: #666;
            font-size: 16px;
            min-width: 30px;
            text-align: center;
        }
        
        /* Botão "Adicionar ao carrinho" */
        .btn-adicionar {
            background-color: transparent;
            color: #A67C52;
            border: none;
            padding: 8px 16px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: underline;
            font-family: 'Georgia', serif;
        }
        
        .btn-adicionar:hover {
            color: #8B6342;
        }
        
        .btn-adicionar:disabled {
            color: #CCC;
            cursor: not-allowed;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <!-- Barra superior -->
    <div class="top-bar">
        <span>HOME</span>
    </div>
    
    <!-- Header com logo -->
    <div class="header">
        <img src="../imagem/logo.png" alt="iCandy Logo" class="logo-img">
    </div>
    
    <!-- Menu de navegação -->
    <div class="menu">
        <a href="carrinho.jsp">Carrinho</a>
        <a href="../pedido/meus_pedidos.jsp">Meus pedidos</a>
        <a href="../cliente/perfil.jsp">Meu perfil</a>
        
        <% if(cliente.isAdmin()) { %>
            <a href="../produto/cadastrar_produto.jsp">Cadastrar produto</a>
            <a href="../produto/listar_produtos.jsp">Gerenciar Produtos</a>
        <% } %>
    </div>
    
    <!-- Banner principal -->
    <div class="banner">
        <img src="../imagem/banner.jpeg" alt="Banner iCandy">
    </div>
    
    <!-- Container dos produtos -->
    <div class="produtos-container">
        <div class="produtos">
            <%
                ProdutoDAO dao = new ProdutoDAO();
                List<Produto> produtos = dao.listar();
                
                if(produtos.isEmpty()) {
            %>
                    <p>Nenhum produto cadastrado ainda</p>
            <%
                } else {
                    for(Produto p : produtos) {
            %>
                    <div class="produto">
                        <!-- Imagem do produto VINDA DO BANCO -->
                        <%
                            if(dao.temImagem(p.getId())) {
                        %>
                            <img src="<%= request.getContextPath() %>/imagem-produto?id=<%= p.getId() %>" alt="<%= p.getNome() %>">
                        <%
                            } else {
                        %>
                            <div class="sem-imagem">Sem imagem</div>
                        <%
                            }
                        %>
                        
                        <!-- Nome do produto -->
                        <h4><%= p.getNome().toUpperCase() %></h4>
                        
                        <!-- DESCRIÇÃO DO PRODUTO -->
                        <% if(p.getDescricao() != null && !p.getDescricao().isEmpty()) { %>
                            <p class="produto-descricao"><%= p.getDescricao() %></p>
                        <% } else { %>
                            <p class="produto-descricao" style="color: #CCC;">Sem descrição</p>
                        <% } %>
                        
                        <!-- Controles de quantidade + e - -->
                        <div class="quantidade-controle">
                            <button type="button" class="btn-quantidade" onclick="diminuir(<%= p.getId() %>)">-</button>
                            <span class="quantidade-valor" id="qtd_<%= p.getId() %>">( 0 )</span>
                            <button type="button" class="btn-quantidade" onclick="aumentar(<%= p.getId() %>, <%= p.getEstoque() %>)">+</button>
                        </div>
                        
                        <!-- Formulário para adicionar ao carrinho -->
                        <form action="adicionar_carrinho.jsp" method="post" id="form_<%= p.getId() %>">
                            <input type="hidden" name="id_produto" value="<%= p.getId() %>">
                            <input type="hidden" name="quantidade" id="hidden_qtd_<%= p.getId() %>" value="0">
                            <button type="submit" class="btn-adicionar" id="btn_<%= p.getId() %>" disabled>
                                Adicionar ao carrinho
                            </button>
                        </form>
                    </div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <script>
        const quantidades = {};
        
        <%
            for(Produto p : produtos) {
        %>
            quantidades[<%= p.getId() %>] = 0;
        <%
            }
        %>
        
        function aumentar(id, estoqueMax) {
            if (quantidades[id] < estoqueMax) {
                quantidades[id]++;
                atualizarDisplay(id);
            }
        }
        
        function diminuir(id) {
            if (quantidades[id] > 0) {
                quantidades[id]--;
                atualizarDisplay(id);
            }
        }
        
        function atualizarDisplay(id) {
            const qtd = quantidades[id];
            document.getElementById('qtd_' + id).textContent = '( ' + qtd + ' )';
            document.getElementById('hidden_qtd_' + id).value = qtd;
            
            const btn = document.getElementById('btn_' + id);
            if (qtd > 0) {
                btn.disabled = false;
            } else {
                btn.disabled = true;
            }
        }
    </script>
</body>
</html>