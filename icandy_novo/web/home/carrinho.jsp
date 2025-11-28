<%@ page import="model.Cliente" %>
<%@ page import="model.Produto" %>
<%@ page import="model.DAO.ProdutoDAO" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    Cliente cliente = (Cliente) session.getAttribute("clienteLogado");
    
    if (cliente == null) {
        response.sendRedirect("../index.html");
        return;
    }
    
    HashMap<Integer, Integer> carrinho = (HashMap<Integer, Integer>) session.getAttribute("carrinho");
    
    if (carrinho == null) {
        carrinho = new HashMap<>();
        session.setAttribute("carrinho", carrinho);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Carrinho - iCandy</title>
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
            max-width: 1000px;
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
            margin-bottom: 20px;
            text-align: center;
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
        
        /* Card de carrinho vazio */
        .carrinho-vazio {
            background: white;
            padding: 60px 40px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .carrinho-vazio p {
            color: #666;
            font-size: 18px;
            margin-bottom: 30px;
        }
        
        .carrinho-vazio .icone {
            font-size: 60px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        /* Lista de itens */
        .itens-container {
            background: white;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .item-carrinho {
            display: flex;
            gap: 20px;
            padding: 20px;
            border-bottom: 1px solid #E0E0E0;
            align-items: center;
        }
        
        .item-carrinho:last-child {
            border-bottom: none;
        }
        
        /* Imagem do item */
        .item-imagem {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border: 1px solid #E0E0E0;
        }
        
        .item-imagem-placeholder {
            width: 100px;
            height: 100px;
            background: #F0F0F0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #999;
            font-size: 12px;
            border: 1px solid #E0E0E0;
        }
        
        /* Info do item */
        .item-info {
            flex: 1;
        }
        
        .item-nome {
            color: #A67C52;
            font-size: 18px;
            margin-bottom: 10px;
        }
        
        .item-preco {
            color: #666;
            font-size: 16px;
        }
        
        /* Quantidade */
        .item-quantidade {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn-qtd {
            width: 30px;
            height: 30px;
            background-color: transparent;
            border: 1px solid #A67C52;
            color: #A67C52;
            font-size: 18px;
            cursor: pointer;
        }
        
        .btn-qtd:hover {
            background-color: #A67C52;
            color: white;
        }
        
        .qtd-valor {
            color: #666;
            font-size: 16px;
            min-width: 30px;
            text-align: center;
        }
        
        /* Botão remover */
        .btn-remover {
            background-color: #D9534F;
            color: white;
            border: none;
            padding: 8px 16px;
            cursor: pointer;
            font-size: 14px;
            font-family: 'Georgia', serif;
        }
        
        .btn-remover:hover {
            background-color: #C9302C;
        }
        
        /* Total */
        .total-container {
            background: white;
            padding: 30px;
            margin-top: 20px;
            text-align: right;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .total-label {
            color: #A67C52;
            font-size: 24px;
            margin-bottom: 20px;
        }
        
        .total-valor {
            color: #A67C52;
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 30px;
        }
        
        .btn-finalizar {
            background-color: #A67C52;
            color: white;
            border: none;
            padding: 15px 40px;
            cursor: pointer;
            font-size: 18px;
            font-family: 'Georgia', serif;
        }
        
        .btn-finalizar:hover {
            background-color: #8B6342;
        }
    </style>
</head>
<body>
    <!-- Header com logo -->
    <div class="header">
        <img src="../imagem/logo.png" alt="iCandy Logo" class="logo-img">
    </div>
    
    <div class="container">
        <h2>Meu Carrinho</h2>
        
        <!-- Navegação -->
        <div class="navegacao">
            <a href="home.jsp">Continuar Comprando</a>
        </div>
        
        <%
            if (carrinho.isEmpty()) {
        %>
                <!-- Carrinho vazio -->
                <div class="carrinho-vazio">
                    <div class="icone">🛒</div>
                    <p>Seu carrinho está vazio</p>
                    <a href="home.jsp" style="color: #A67C52; text-decoration: none; font-size: 16px;">Ir para a loja</a>
                </div>
        <%
            } else {
                ProdutoDAO dao = new ProdutoDAO();
                double totalGeral = 0;
        %>
                <!-- Lista de itens -->
                <div class="itens-container">
                    <%
                        for (Map.Entry<Integer, Integer> item : carrinho.entrySet()) {
                            Produto p = dao.buscarPorId(item.getKey());
                            
                            if (p != null) {
                                double subtotal = p.getPreco() * item.getValue();
                                totalGeral += subtotal;
                    %>
                    <div class="item-carrinho">
 
                        <%
                            if(dao.temImagem(p.getId())) {
                        %>
                            <img src="<%= request.getContextPath() %>/imagem-produto?id=<%= p.getId() %>" class="item-imagem" alt="<%= p.getNome() %>">
                        <%
                            } else {
                        %>
                            <div class="item-imagem-placeholder">Sem imagem</div>
                        <%
                            }
                        %>
                        
                        <!-- Info do produto -->
                        <div class="item-info">
                            <div class="item-nome"><%= p.getNome() %></div>
                            <div class="item-preco">R$ <%= String.format("%.2f", p.getPreco()) %> cada</div>
                        </div>
                        
                        <!-- Controles de quantidade -->
                        <div class="item-quantidade">
                            <form action="atualizar_carrinho.jsp" method="post" style="display: inline;">
                                <input type="hidden" name="id_produto" value="<%= p.getId() %>">
                                <input type="hidden" name="acao" value="diminuir">
                                <button type="submit" class="btn-qtd">-</button>
                            </form>
                            
                            <span class="qtd-valor"><%= item.getValue() %></span>
                            
                            <form action="atualizar_carrinho.jsp" method="post" style="display: inline;">
                                <input type="hidden" name="id_produto" value="<%= p.getId() %>">
                                <input type="hidden" name="acao" value="aumentar">
                                <button type="submit" class="btn-qtd">+</button>
                            </form>
                        </div>
                        
                        <!-- Subtotal -->
                        <div style="min-width: 100px; text-align: right;">
                            <strong style="color: #A67C52; font-size: 18px;">R$ <%= String.format("%.2f", subtotal) %></strong>
                        </div>
                        
                        <!-- Botão remover -->
                        <form action="remover_carrinho.jsp" method="post" style="display: inline;">
                            <input type="hidden" name="id_produto" value="<%= p.getId() %>">
                            <button type="submit" class="btn-remover" onclick="return confirm('Remover este item?')">Remover</button>
                        </form>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
                
                <!-- Total -->
                <div class="total-container">
                    <div class="total-label">Total:</div>
                    <div class="total-valor">R$ <%= String.format("%.2f", totalGeral) %></div>
                    
                    <form action="../pedido/finalizar_pedido.jsp" method="post">
                        <button type="submit" class="btn-finalizar">Finalizar Pedido</button>
                    </form>
                </div>
        <%
            }
        %>
    </div>
</body>
</html>