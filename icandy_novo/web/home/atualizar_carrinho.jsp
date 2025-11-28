<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    // Verifica se o cliente está logado
    if (session.getAttribute("clienteLogado") == null) {
        response.sendRedirect("../index.html");
        return;
    }
    
    // Pega os parâmetros
    String idProdutoParam = request.getParameter("id_produto");
    String acao = request.getParameter("acao");
    
    if (idProdutoParam == null || acao == null) {
        response.sendRedirect("carrinho.jsp");
        return;
    }
    
    int idProduto = Integer.parseInt(idProdutoParam);
    
    // Pega o carrinho da sessão
    HashMap<Integer, Integer> carrinho = (HashMap<Integer, Integer>) session.getAttribute("carrinho");
    
    if (carrinho == null) {
        carrinho = new HashMap<>();
        session.setAttribute("carrinho", carrinho);
    }
    
    // Verifica qual ação fazer
    if ("aumentar".equals(acao)) {
     
        int quantidadeAtual = carrinho.getOrDefault(idProduto, 0);
        carrinho.put(idProduto, quantidadeAtual + 1);
        
    } else if ("diminuir".equals(acao)) {
     
        int quantidadeAtual = carrinho.getOrDefault(idProduto, 0);
        
        if (quantidadeAtual > 1) {
            
            carrinho.put(idProduto, quantidadeAtual - 1);
        } else {
          
            carrinho.remove(idProduto);
        }
    }
    
  
    session.setAttribute("carrinho", carrinho);
    
    // Redireciona de volta para o carrinho
    response.sendRedirect("carrinho.jsp");
%>