<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    // Verifica se o cliente está logado
    if (session.getAttribute("clienteLogado") == null) {
        response.sendRedirect("../index.html");
        return;
    }
    
    // Pega o ID do produto
    String idProdutoParam = request.getParameter("id_produto");
    
    if (idProdutoParam == null || idProdutoParam.isEmpty()) {
        response.sendRedirect("carrinho.jsp");
        return;
    }
    
    int idProduto = Integer.parseInt(idProdutoParam);
    
    // Pega o carrinho da sessão
    HashMap<Integer, Integer> carrinho = (HashMap<Integer, Integer>) session.getAttribute("carrinho");
    
    if (carrinho != null) {
 
        carrinho.remove(idProduto);
        

        session.setAttribute("carrinho", carrinho);
    }
    
    response.sendRedirect("carrinho.jsp");
%>