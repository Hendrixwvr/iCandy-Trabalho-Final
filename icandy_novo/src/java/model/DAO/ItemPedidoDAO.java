/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.DAO;
import model.ItemPedido;
import config.ConectaDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ItemPedidoDAO {
    
    public boolean adicionar(ItemPedido item) {
        String sql = "INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, item.getIdPedido());
            stmt.setInt(2, item.getIdProduto());
            stmt.setInt(3, item.getQuantidade());
            stmt.setDouble(4, item.getPrecoUnitario());
            
            stmt.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<ItemPedido> listarPorPedido(int idPedido) {
        List<ItemPedido> lista = new ArrayList<>();
        String sql = "SELECT ip.*, p.nome as nome_produto FROM item_pedido ip " +
                     "JOIN produto p ON ip.id_produto = p.id_produto " +
                     "WHERE ip.id_pedido = ?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idPedido);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ItemPedido item = new ItemPedido();
                item.setId(rs.getInt("id_item"));
                item.setIdPedido(rs.getInt("id_pedido"));
                item.setIdProduto(rs.getInt("id_produto"));
                item.setQuantidade(rs.getInt("quantidade"));
                item.setPrecoUnitario(rs.getDouble("preco_unitario"));
                item.setNomeProduto(rs.getString("nome_produto"));
                lista.add(item);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return lista;
    }
}