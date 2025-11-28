/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.DAO;
import model.Pedido;
import config.ConectaDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class PedidoDAO {
    
    public int criar(Pedido p) {
    String sql = "INSERT INTO pedido (id_cliente, valor_total, status) VALUES (?, ?, ?)";
    
    try (Connection conn = ConectaDB.conectar();
         PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        
        System.out.println("DEBUG: Criando pedido...");
        System.out.println("DEBUG: ID Cliente = " + p.getIdCliente());
        System.out.println("DEBUG: Valor Total = " + p.getValorTotal());
        System.out.println("DEBUG: Status = " + p.getStatus());
        
        stmt.setInt(1, p.getIdCliente());
        stmt.setDouble(2, p.getValorTotal());
        stmt.setString(3, p.getStatus());
        
        int linhasAfetadas = stmt.executeUpdate();
        System.out.println("DEBUG: Linhas afetadas = " + linhasAfetadas);
        
        ResultSet rs = stmt.getGeneratedKeys();
        if (rs.next()) {
            int idGerado = rs.getInt(1);
            System.out.println("DEBUG: ID do pedido gerado = " + idGerado);
            return idGerado;
        } else {
            System.out.println("DEBUG: Nenhum ID foi gerado!");
        }
        
    } catch (SQLException e) {
        System.out.println("DEBUG: ERRO SQL!");
        e.printStackTrace();
    }
    
    return 0;

    }
    
    public List<Pedido> listarPorCliente(int idCliente) {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT * FROM pedido WHERE id_cliente = ? ORDER BY data_pedido DESC";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idCliente);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Pedido p = new Pedido();
                p.setId(rs.getInt("id_pedido"));
                p.setIdCliente(rs.getInt("id_cliente"));
                p.setDataPedido(rs.getTimestamp("data_pedido"));
                p.setValorTotal(rs.getDouble("valor_total"));
                p.setStatus(rs.getString("status"));
                lista.add(p);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return lista;
    }
    
    public Pedido buscarPorId(int id) {
        String sql = "SELECT * FROM pedido WHERE id_pedido = ?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Pedido p = new Pedido();
                p.setId(rs.getInt("id_pedido"));
                p.setIdCliente(rs.getInt("id_cliente"));
                p.setDataPedido(rs.getTimestamp("data_pedido"));
                p.setValorTotal(rs.getDouble("valor_total"));
                p.setStatus(rs.getString("status"));
                return p;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean cancelar(int id) {
        String sql = "UPDATE pedido SET status = 'Cancelado' WHERE id_pedido = ?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            stmt.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}