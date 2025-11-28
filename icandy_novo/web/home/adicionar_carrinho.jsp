<%-- 
    Document   : adicionar_carrinho
    Created on : 20 de nov. de 2025, 05:46:17
    Author     : hendrix_kauane_murilo
--%>

<%@ page import="model.Cliente" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    Cliente cliente = (Cliente) session.getAttribute("clienteLogado");
    
    if(cliente == null) {
        response.sendRedirect("../index.html");
        return;
    }
    
    int idProduto = Integer.parseInt(request.getParameter("id_produto"));
    int quantidade = Integer.parseInt(request.getParameter("quantidade"));
    
    // Pega o carrinho da sessão
    HashMap<Integer, Integer> carrinho = (HashMap<Integer, Integer>) session.getAttribute("carrinho");
    
    // Se o produto já está no carrinho, soma a quantidade
    if(carrinho.containsKey(idProduto)) {
        carrinho.put(idProduto, carrinho.get(idProduto) + quantidade);
    } else {
        carrinho.put(idProduto, quantidade);
    }
    
    session.setAttribute("carrinho", carrinho);
    
    response.sendRedirect("home.jsp");
%>