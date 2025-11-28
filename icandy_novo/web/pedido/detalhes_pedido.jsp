<%-- 
    Author     : hendrix_kauane_murilo
--%>
<%@ page import="model.Cliente" %>
<%@ page import="model.Pedido" %>
<%@ page import="model.ItemPedido" %>
<%@ page import="model.DAO.PedidoDAO" %>
<%@ page import="model.DAO.ItemPedidoDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    Cliente cliente = (Cliente) session.getAttribute("clienteLogado");
    
    if (cliente == null) {
        response.sendRedirect("../index.html");
        return;
    }
    
    int idPedido = Integer.parseInt(request.getParameter("id"));
    
    PedidoDAO pedidoDAO = new PedidoDAO();
    Pedido pedido = pedidoDAO.buscarPorId(idPedido);
    
    if (pedido == null) {
        response.sendRedirect("meus_pedidos.jsp");
        return;
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detalhes do Pedido - iCandy</title>
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
            margin: 0 15px;
            font-size: 16px;
        }
        
        .navegacao a:hover {
            text-decoration: underline;
        }
        
        /* Card de informações do pedido */
        .info-card {
            background: white;
            padding: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
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
        
        /* Badge de status */
        .status {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .status-pendente {
            background-color: #FFF3CD;
            color: #856404;
        }
        
        .status-cancelado {
            background-color: #F8D7DA;
            color: #721C24;
        }
        
        /* Tabela de itens */
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
        
        tr:last-child td {
            border-bottom: none;
        }
        
        .total-row {
            background-color: #FAF7F2;
            font-weight: bold;
        }
        
        .total-row td {
            color: #A67C52;
            font-size: 18px;
        }
    </style>
</head>
<body>

    <div class="header">
        <img src="../imagem/logo.png" alt="iCandy Logo" class="logo-img">
    </div>
    
    <div class="container">
        <h2>Detalhes do Pedido #<%= pedido.getId() %></h2>
        
        <!-- Navegação -->
        <div class="navegacao">
            <a href="meus_pedidos.jsp">Voltar para Meus Pedidos</a> |
            <a href="../home/home.jsp">Voltar para Home</a>
        </div>
        
        <!-- Informações do Pedido -->
        <div class="info-card">
            <h3>Informações do Pedido</h3>
            
            <div class="info-linha">
                <span class="info-label">Número:</span>
                <span class="info-valor">#<%= pedido.getId() %></span>
            </div>
            
            <div class="info-linha">
                <span class="info-label">Data:</span>
                <span class="info-valor"><%= sdf.format(pedido.getDataPedido()) %></span>
            </div>
            
            <div class="info-linha">
                <span class="info-label">Status:</span>
                <span class="info-valor">
                    <span class="status <%= "Pendente".equals(pedido.getStatus()) ? "status-pendente" : "status-cancelado" %>">
                        <%= pedido.getStatus() %>
                    </span>
                </span>
            </div>
            
            <div class="info-linha">
                <span class="info-label">Valor Total:</span>
                <span class="info-valor">R$ <%= String.format("%.2f", pedido.getValorTotal()) %></span>
            </div>
        </div>
        
        <!-- Itens do Pedido -->
        <h3 style="color: #A67C52; font-size: 20px; font-weight: normal; margin-bottom: 20px;">Itens do Pedido</h3>
        
        <table>
            <tr>
                <th>Produto</th>
                <th>Preço Unitário</th>
                <th>Quantidade</th>
                <th>Subtotal</th>
            </tr>
            
            <%
                ItemPedidoDAO itemDAO = new ItemPedidoDAO();
                List<ItemPedido> itens = itemDAO.listarPorPedido(idPedido);
                
                for (ItemPedido item : itens) {
            %>
            <tr>
                <td><%= item.getNomeProduto() %></td>
                <td>R$ <%= String.format("%.2f", item.getPrecoUnitario()) %></td>
                <td><%= item.getQuantidade() %></td>
                <td>R$ <%= String.format("%.2f", item.getSubtotal()) %></td>
            </tr>
            <%
                }
            %>
            
            <tr class="total-row">
                <td colspan="3">Total</td>
                <td>R$ <%= String.format("%.2f", pedido.getValorTotal()) %></td>
            </tr>
        </table>
    </div>
</body>
</html>