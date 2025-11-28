package model.DAO;

import model.Cliente;
import config.ConectaDB;
import config.MD5Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ClienteDAO {
    
   
    public boolean cadastrar(Cliente c) {
        String sql = "INSERT INTO cliente (nome, email, senha, cep, rua, numero, bairro, complemento, cidade, tipo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'cliente')";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, c.getNome());
            stmt.setString(2, c.getEmail());
            stmt.setString(3, MD5Util.hash(c.getSenha()));
            stmt.setString(4, c.getCep());
            stmt.setString(5, c.getRua());
            stmt.setString(6, c.getNumero());
            stmt.setString(7, c.getBairro());
            stmt.setString(8, c.getComplemento());
            stmt.setString(9, c.getCidade());
            
            stmt.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
   
    public Cliente validarLogin(String email, String senha) {
        String senhaHash = MD5Util.hash(senha);
        String sql = "SELECT * FROM cliente WHERE email = ? AND senha = ?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setString(2, senhaHash);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setId(rs.getInt("id_cliente"));
                cliente.setNome(rs.getString("nome"));
                cliente.setEmail(rs.getString("email"));
                cliente.setCep(rs.getString("cep"));
                cliente.setRua(rs.getString("rua"));
                cliente.setNumero(rs.getString("numero"));
                cliente.setBairro(rs.getString("bairro"));
                cliente.setComplemento(rs.getString("complemento"));
                cliente.setCidade(rs.getString("cidade"));
                cliente.setTipo(rs.getString("tipo"));
                
                return cliente;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
  
    public Cliente buscarPorId(int id) {
        String sql = "SELECT * FROM cliente WHERE id_cliente = ?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Cliente c = new Cliente();
                c.setId(rs.getInt("id_cliente"));
                c.setNome(rs.getString("nome"));
                c.setEmail(rs.getString("email"));
                c.setCep(rs.getString("cep"));
                c.setRua(rs.getString("rua"));
                c.setNumero(rs.getString("numero"));
                c.setBairro(rs.getString("bairro"));
                c.setComplemento(rs.getString("complemento"));
                c.setCidade(rs.getString("cidade"));
                c.setTipo(rs.getString("tipo"));
                
                return c;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    

    public boolean atualizar(Cliente c) {
        String sql = "UPDATE cliente SET nome=?, email=?, cep=?, rua=?, numero=?, bairro=?, complemento=?, cidade=? WHERE id_cliente=?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, c.getNome());
            stmt.setString(2, c.getEmail());
            stmt.setString(3, c.getCep());
            stmt.setString(4, c.getRua());
            stmt.setString(5, c.getNumero());
            stmt.setString(6, c.getBairro());
            stmt.setString(7, c.getComplemento());
            stmt.setString(8, c.getCidade());
            stmt.setInt(9, c.getId());
            
            stmt.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
   
    public boolean atualizarSenha(int id, String senhaAtual, String novaSenha) {
        String sqlValidar = "SELECT id_cliente FROM cliente WHERE id_cliente=? AND senha=?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmtValidar = conn.prepareStatement(sqlValidar)) {
            
            String senhaAtualHash = MD5Util.hash(senhaAtual);
            stmtValidar.setInt(1, id);
            stmtValidar.setString(2, senhaAtualHash);
            
            ResultSet rs = stmtValidar.executeQuery();
            
            if (!rs.next()) {
                return false;
            }
            
            String sqlAtualizar = "UPDATE cliente SET senha=? WHERE id_cliente=?";
            PreparedStatement stmtAtualizar = conn.prepareStatement(sqlAtualizar);
            
            String novaSenhaHash = MD5Util.hash(novaSenha);
            stmtAtualizar.setString(1, novaSenhaHash);
            stmtAtualizar.setInt(2, id);
            stmtAtualizar.executeUpdate();
            
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
   
    public boolean deletar(int id) {
        
        String sqlVerifica = "SELECT COUNT(*) as total FROM pedido WHERE id_cliente = ?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmtVerifica = conn.prepareStatement(sqlVerifica)) {
            
            stmtVerifica.setInt(1, id);
            ResultSet rs = stmtVerifica.executeQuery();
            
            
            if (rs.next() && rs.getInt("total") > 0) {
                return false;
            }
            
            
            String sqlDelete = "DELETE FROM cliente WHERE id_cliente = ?";
            
            try (PreparedStatement stmtDelete = conn.prepareStatement(sqlDelete)) {
                stmtDelete.setInt(1, id);
                stmtDelete.executeUpdate();
                return true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
    public boolean temPedidos(int idCliente) {
        String sql = "SELECT COUNT(*) as total FROM pedido WHERE id_cliente = ?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idCliente);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
}