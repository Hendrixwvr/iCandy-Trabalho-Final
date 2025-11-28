<%-- 
    Author     : hendrix_kauane_murilo
--%>
<%@ page import="model.Cliente" %>
<%@ page import="model.Produto" %>
<%@ page import="model.Pedido" %>
<%@ page import="model.ItemPedido" %>
<%@ page import="model.DAO.ProdutoDAO" %>
<%@ page import="model.DAO.PedidoDAO" %>
<%@ page import="model.DAO.ItemPedidoDAO" %>
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
    
    if (carrinho == null || carrinho.isEmpty()) {
        response.sendRedirect("../home/home.jsp");
        return;
    }
    
    try {
        ProdutoDAO produtoDAO = new ProdutoDAO();
        double totalFinal = 0;
        
        for (Map.Entry<Integer, Integer> item : carrinho.entrySet()) {
            Produto p = produtoDAO.buscarPorId(item.getKey());
            if (p != null) {
                totalFinal += p.getPreco() * item.getValue();
            }
        }
        
        Pedido pedido = new Pedido();
        pedido.setIdCliente(cliente.getId());
        pedido.setValorTotal(totalFinal);
        pedido.setStatus("Pendente");
        
        PedidoDAO pedidoDAO = new PedidoDAO();
        int idPedido = pedidoDAO.criar(pedido);
        
        if (idPedido > 0) {
            ItemPedidoDAO itemDAO = new ItemPedidoDAO();
            boolean todosItensAdicionados = true;
            
            for (Map.Entry<Integer, Integer> item : carrinho.entrySet()) {
                Produto p = produtoDAO.buscarPorId(item.getKey());
                
                if (p != null) {
                    ItemPedido itemPedido = new ItemPedido();
                    itemPedido.setIdPedido(idPedido);
                    itemPedido.setIdProduto(item.getKey());
                    itemPedido.setQuantidade(item.getValue());
                    itemPedido.setPrecoUnitario(p.getPreco());
                    
                    if (!itemDAO.adicionar(itemPedido)) {
                        todosItensAdicionados = false;
                    }
                }
            }
            
            if (todosItensAdicionados) {
                session.removeAttribute("carrinho");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pedido Finalizado - iCandy</title>
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
            text-align: center;
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
        
        /* Card de sucesso */
        .sucesso-card {
            background: white;
            padding: 40px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .icone-sucesso {
            font-size: 60px;
            color: #5CB85C;
            margin-bottom: 20px;
        }
        
        h2 {
            color: #A67C52;
            font-size: 28px;
            font-weight: normal;
            margin-bottom: 30px;
        }
        
        .info-pedido {
            text-align: left;
            margin: 30px 0;
        }
        
        .info-linha {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #F5F5F5;
        }
        
        .info-label {
            color: #A67C52;
            font-weight: bold;
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
        }
        
        .btn-home {
            background-color: #A67C52;
            color: white;
        }
        
        .btn-home:hover {
            background-color: #8B6342;
        }
        
        .btn-pedidos {
            background-color: #CCC;
            color: #333;
        }
        
        .btn-pedidos:hover {
            background-color: #AAA;
        }
    </style>
</head>
<body>

    <div class="header">
        <img src="../imagem/logo.png" alt="iCandy Logo" class="logo-img">
    </div>
    
    <div class="container">
        <div class="sucesso-card">
            <div class="icone-sucesso">✓</div>
            <h2>Pedido realizado com sucesso!</h2>
            
            <div class="info-pedido">
                <div class="info-linha">
                    <span class="info-label">Número do pedido:</span>
                    <span class="info-valor">#<%= idPedido %></span>
                </div>
                
                <div class="info-linha">
                    <span class="info-label">Valor total:</span>
                    <span class="info-valor">R$ <%= String.format("%.2f", totalFinal) %></span>
                </div>
                
                <div class="info-linha">
                    <span class="info-label">Status:</span>
                    <span class="info-valor">Pendente</span>
                </div>
            </div>
            
            <div class="acoes">
                <a href="../home/home.jsp" class="btn btn-home">Voltar para Home</a>
                <a href="meus_pedidos.jsp" class="btn btn-pedidos">Ver Meus Pedidos</a>
            </div>
        </div>
    </div>
</body>
</html>

<%
            } else {
%>
    <h2>Erro ao adicionar itens ao pedido</h2>
    <a href="../home/carrinho.jsp">Voltar para o carrinho</a>
<%
            }
        } else {
%>
    <h2>Erro ao criar o pedido</h2>
    <a href="../home/carrinho.jsp">Voltar para o carrinho</a>
<%
        }
        
    } catch (Exception e) {
        e.printStackTrace();
%>
    <h2>Erro ao finalizar pedido</h2>
    <p><%= e.getMessage() %></p>
    <a href="../home/carrinho.jsp">Voltar para o carrinho</a>
<%
    }
%>