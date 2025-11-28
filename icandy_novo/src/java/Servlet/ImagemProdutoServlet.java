/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import model.DAO.ProdutoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;


@WebServlet("/imagem-produto")
public class ImagemProdutoServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Pega o ID do produto da URL
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int idProduto = Integer.parseInt(idParam);
                
                // Busca a imagem no banco
                ProdutoDAO dao = new ProdutoDAO();
                byte[] imagem = dao.buscarImagem(idProduto);
                
                if (imagem != null && imagem.length > 0) {
                   
                    response.setContentType("image/jpeg");
                    response.setContentLength(imagem.length);
                    
                    // Envia a imagem
                    try (OutputStream out = response.getOutputStream()) {
                        out.write(imagem);
                        out.flush();
                    }
                } else {
                    // Produto sem imagem
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
                
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}