<%@ page import="model.Produto" %>
<%@ page import="model.DAO.ProdutoDAO" %>
<%@ page import="model.Cliente" %>
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
    
    String idParam = request.getParameter("id");
    
    if(idParam == null || idParam.isEmpty()) {
        response.sendRedirect("listar_produtos.jsp");
        return;
    }
    
    int id = Integer.parseInt(idParam);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Excluir Produto - iCandy</title>
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
            text-align: center;
        }
        
        /* Card de mensagem */
        .mensagem-card {
            background: white;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        /* Ícone */
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
        
        /* Botão */
        .btn {
            display: inline-block;
            padding: 12px 40px;
            background-color: #A67C52;
            color: white;
            text-decoration: none;
            font-size: 16px;
            font-family: 'Georgia', serif;
            transition: all 0.3s ease;
        }
        
        .btn:hover {
            background-color: #8B6342;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>  
    <div class="container">
        <%
            ProdutoDAO dao = new ProdutoDAO();
            
            try {
                if(dao.deletar(id)) {
        %>
                    <div class="mensagem-card">
                        <div class="icone icone-sucesso">✓</div>
                        <h2 class="sucesso">Produto excluído com sucesso!</h2>
                        <p>O produto foi removido do sistema.</p>
                        <a href="listar_produtos.jsp" class="btn">Voltar para lista</a>
                    </div>
        <%
                } else {
        %>
                    <div class="mensagem-card">
                        <div class="icone icone-erro">⚠️</div>
                        <h2 class="erro">Erro ao excluir produto</h2>
                        <p>Não foi possível excluir o produto.<br>
                        Ele pode estar vinculado a pedidos existentes.</p>
                        <a href="listar_produtos.jsp" class="btn">Voltar para lista</a>
                    </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
                <div class="mensagem-card">
                    <div class="icone icone-erro">❌</div>
                    <h2 class="erro">Erro no sistema</h2>
                    <p><strong>Detalhes:</strong> <%= e.getMessage() %><br><br>
                    Este produto pode estar vinculado a pedidos existentes e não pode ser excluído.</p>
                    <a href="listar_produtos.jsp" class="btn">Voltar para lista</a>
                </div>
        <%
            }
        %>
    </div>
</body>
</html>