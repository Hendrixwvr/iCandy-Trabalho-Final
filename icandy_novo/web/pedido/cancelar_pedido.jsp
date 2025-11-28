<%-- 
    Author     : hendrix_kauane_murilo
--%>

<%@ page import="model.Cliente" %>
<%@ page import="model.Pedido" %>
<%@ page import="model.DAO.PedidoDAO" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    Cliente cliente = (Cliente) session.getAttribute("clienteLogado");
    
    if (cliente == null) {
        response.sendRedirect("../index.html");
        return;
    }
    
    String idParam = request.getParameter("id");
    
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("meus_pedidos.jsp");
        return;
    }
    
    int idPedido = Integer.parseInt(idParam);
    
    PedidoDAO dao = new PedidoDAO();
    Pedido pedido = dao.buscarPorId(idPedido);
    
    // Verifica se o pedido existe e pertence ao cliente
    if (pedido == null || pedido.getIdCliente() != cliente.getId()) {
        response.sendRedirect("meus_pedidos.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cancelar Pedido - iCandy</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        
        /* Container principal */
        .container {
            max-width: 600px;
            width: 100%;
            text-align: center;
        }
        
        /* Card de mensagem */
        .mensagem-card {
            background: white;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        

        .icone {
            font-size: 60px;
            margin-bottom: 20px;
        }
        
        .icone-sucesso {
            color: #5CB85C;
        }
        
        .icone-erro {
            color: #D9534F;
        }
        
        /* Título */
        h2 {
            font-size: 24px;
            font-weight: normal;
            margin-bottom: 20px;
        }
        
        h2.sucesso {
            color: #5CB85C;
        }
        
        h2.erro {
            color: #D9534F;
        }
        
        /* Texto */
        p {
            color: #666;
            font-size: 16px;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        /* Botões */
        .botoes {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            text-decoration: none;
            font-size: 16px;
            font-family: 'Georgia', serif;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-voltar {
            background-color: #A67C52;
            color: white;
        }
        
        .btn-voltar:hover {
            background-color: #8B6342;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
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
    <div class="container">
        <%
            try {
                // Verifica se o pedido já está cancelado
                if ("Cancelado".equals(pedido.getStatus())) {
        %>
                    <div class="mensagem-card">
                        <div class="icone icone-erro">⚠️</div>
                        <h2 class="erro">Pedido já cancelado</h2>
                        <p>Este pedido já foi cancelado anteriormente.</p>
                        <div class="botoes">
                            <a href="meus_pedidos.jsp" class="btn btn-voltar">Ver meus pedidos</a>
                        </div>
                    </div>
        <%
                } else {
                    // Cancela o pedido
                    if (dao.cancelar(idPedido)) {
        %>
                    <div class="mensagem-card">
                        <div class="icone icone-sucesso">✓</div>
                        <h2 class="sucesso">Pedido cancelado com sucesso!</h2>
                        <p>Seu pedido <%= idPedido %> foi cancelado.<br>
                        O valor de <strong>R$ <%= String.format("%.2f", pedido.getValorTotal()) %></strong> será estornado.</p>
                        <div class="botoes">
                            <a href="meus_pedidos.jsp" class="btn btn-voltar">Ver meus pedidos</a>
                            <a href="../home/home.jsp" class="btn btn-pedidos">Voltar para Home</a>
                        </div>
                    </div>
        <%
                    } else {
        %>
                    <div class="mensagem-card">
                        <h2 class="erro">Erro ao cancelar pedido</h2>
                        <p>Não foi possível cancelar o pedido.<br>
                        Por favor, tente novamente mais tarde.</p>
                        <div class="botoes">
                            <a href="detalhes_pedido.jsp?id=<%= idPedido %>" class="btn btn-voltar">Ver detalhes</a>
                            <a href="meus_pedidos.jsp" class="btn btn-pedidos">Ver meus pedidos</a>
                        </div>
                    </div>
        <%
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
                <div class="mensagem-card">
                    <h2 class="erro">Erro no sistema</h2>
                    <p><strong>Detalhes:</strong> <%= e.getMessage() %></p>
                    <div class="botoes">
                        <a href="meus_pedidos.jsp" class="btn btn-voltar">Voltar</a>
                    </div>
                </div>
        <%
            }
        %>
    </div>
</body>
</html>