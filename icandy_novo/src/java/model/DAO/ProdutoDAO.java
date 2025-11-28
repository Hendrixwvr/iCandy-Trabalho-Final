/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.DAO;
import model.Produto;
import config.ConectaDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class ProdutoDAO {
    
    
    public boolean cadastrar(Produto p) {
        String sql = "INSERT INTO produto (nome, descricao, preco, estoque, imagem_blob) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, p.getNome());
            stmt.setString(2, p.getDescricao());
            stmt.setDouble(3, p.getPreco());
            stmt.setInt(4, p.getEstoque());
            
            
            if (p.getImagemBlob() != null) {
                stmt.setBytes(5, p.getImagemBlob());
            } else {
                stmt.setNull(5, java.sql.Types.BLOB);
            }
            
            stmt.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Produto> listar() {
        List<Produto> lista = new ArrayList<>();
        String sql = "SELECT id_produto, nome, descricao, preco, estoque FROM produto ORDER BY id_produto DESC";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Produto p = new Produto();
                p.setId(rs.getInt("id_produto"));
                p.setNome(rs.getString("nome"));
                p.setDescricao(rs.getString("descricao"));
                p.setPreco(rs.getDouble("preco"));
                p.setEstoque(rs.getInt("estoque"));
                // Não carrega a imagem aqui para não sobrecarregar
                lista.add(p);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return lista;
    }
    
    public Produto buscarPorId(int id) {
        String sql = "SELECT id_produto, nome, descricao, preco, estoque FROM produto WHERE id_produto = ?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Produto p = new Produto();
                p.setId(rs.getInt("id_produto"));
                p.setNome(rs.getString("nome"));
                p.setDescricao(rs.getString("descricao"));
                p.setPreco(rs.getDouble("preco"));
                p.setEstoque(rs.getInt("estoque"));
                return p;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    
    public byte[] buscarImagem(int id) {
        String sql = "SELECT imagem_blob FROM produto WHERE id_produto = ?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getBytes("imagem_blob");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
   
    public boolean atualizar(Produto p) {
        String sql = "UPDATE produto SET nome=?, descricao=?, preco=?, estoque=?, imagem_blob=? WHERE id_produto=?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, p.getNome());
            stmt.setString(2, p.getDescricao());
            stmt.setDouble(3, p.getPreco());
            stmt.setInt(4, p.getEstoque());
            
            if (p.getImagemBlob() != null) {
                stmt.setBytes(5, p.getImagemBlob());
            } else {
                stmt.setNull(5, java.sql.Types.BLOB);
            }
            
            stmt.setInt(6, p.getId());
            
            stmt.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
    public boolean deletar(int id) {
        try (Connection conn = ConectaDB.conectar()) {
                      
            String sqlRemoveItens = "DELETE FROM item_pedido WHERE id_produto = ? AND id_pedido IN (SELECT id_pedido FROM pedido WHERE status = 'Cancelado')";
            
            try (PreparedStatement stmtRemove = conn.prepareStatement(sqlRemoveItens)) {
                stmtRemove.setInt(1, id);
                stmtRemove.executeUpdate();
            }

            String sqlVerifica = "SELECT COUNT(*) as total FROM item_pedido WHERE id_produto = ? AND id_pedido IN (SELECT id_pedido FROM pedido WHERE status = 'Pendente')";
            
            try (PreparedStatement stmtVerifica = conn.prepareStatement(sqlVerifica)) {
                stmtVerifica.setInt(1, id);
                ResultSet rs = stmtVerifica.executeQuery();
                
                if (rs.next() && rs.getInt("total") > 0) {
                    return false;
                }
            }

            String sqlDelete = "DELETE FROM produto WHERE id_produto = ?";
            
            try (PreparedStatement stmtDelete = conn.prepareStatement(sqlDelete)) {
                stmtDelete.setInt(1, id);
                int linhasAfetadas = stmtDelete.executeUpdate();
                return linhasAfetadas > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean temImagem(int id) {
        byte[] imagem = buscarImagem(id);
        return imagem != null && imagem.length > 0;
    }
}