<%-- 
    Author     : hendrix_kauane_murilo
--%>

<%@ page import="model.Cliente" %>
<%@ page import="model.Pedido" %>
<%@ page import="model.DAO.PedidoDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    <title>Meus Pedidos - iCandy</title>
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
        
        /* Tabela */
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
        <h2>Meus Pedidos</h2>
        
        <div class="navegacao">
            <a href="../home/home.jsp">Voltar para Home</a>
        </div>
        
        <!-- Tabela de pedidos -->
        <table>
            <tr>
                <th>Número</th>
                <th>Data</th>
                <th>Valor Total</th>
                <th>Status</th>
                <th>Ações</th>
            </tr>
            
            <%
                PedidoDAO dao = new PedidoDAO();
                List<Pedido> pedidos = dao.listarPorCliente(cliente.getId());
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                
                if (pedidos.isEmpty()) {
            %>
                    <tr>
                        <td colspan="5" style="text-align:center;">Nenhum pedido realizado</td>
                    </tr>
            <%
                } else {
                    for (Pedido p : pedidos) {
                        String statusClass = "Pendente".equals(p.getStatus()) ? "status-pendente" : "status-cancelado";
            %>
                    <tr>
                        <td>#<%= p.getId() %></td>
                        <td><%= sdf.format(p.getDataPedido()) %></td>
                        <td>R$ <%= String.format("%.2f", p.getValorTotal()) %></td>
                        <td><span class="status <%= statusClass %>"><%= p.getStatus() %></span></td>
                        <td class="acoes">
                            <a href="detalhes_pedido.jsp?id=<%= p.getId() %>">Ver Detalhes</a>
                            <% if ("Pendente".equals(p.getStatus())) { %>
                                <a href="cancelar_pedido.jsp?id=<%= p.getId() %>" onclick="return confirm('Cancelar pedido?')">Cancelar</a>
                            <% } %>
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