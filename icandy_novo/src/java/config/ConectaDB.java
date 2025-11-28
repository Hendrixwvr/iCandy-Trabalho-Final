/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package config;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConectaDB {
    public static Connection conectar() {
        Connection conn = null;
        try {
          
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver carregado com sucesso!");
            
      
            String url = "jdbc:mysql://localhost:3307/icandy";
            String usuario = "root";
            String senha = "";
            
            System.out.println("Tentando conectar em: " + url);
            
     
            conn = DriverManager.getConnection(url, usuario, senha);
            
            System.out.println("✓ Conexão estabelecida com sucesso!");
            
        } catch (ClassNotFoundException e) {
            System.out.println("✗ Driver JDBC não encontrado: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("✗ Erro ao conectar no banco: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
}