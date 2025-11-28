/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;


public class Cliente {
    // Atributos do cliente
    private int id;              
    private String nome;        
    private String email;       
    private String senha;       
    private String cep;          
    private String rua;          
    private String numero;       
    private String bairro;      
    private String complemento;  
    private String cidade;       
    private String tipo;         
    
    /**
     * Retorna o ID do cliente
     */
    public int getId() {
        return id;
    }
    
    /**
     * Define o ID do cliente
     */
    public void setId(int id) {
        this.id = id;
    }
    
    /**
     * Retorna o nome do cliente
     */
    public String getNome() {
        return nome;
    }
    
    /**
     * Define o nome do cliente
     */
    public void setNome(String nome) {
        this.nome = nome;
    }
    
    /**
     * Retorna o email do cliente
     */
    public String getEmail() {
        return email;
    }
    
    /**
     * Define o email do cliente
     */
    public void setEmail(String email) {
        this.email = email;
    }
    
    /**
     * Retorna a senha do cliente
     */
    public String getSenha() {
        return senha;
    }
    
    /**
     * Define a senha do cliente
     */
    public void setSenha(String senha) {
        this.senha = senha;
    }
    
    /**
     * Retorna o CEP do cliente
     */
    public String getCep() {
        return cep;
    }
    
    /**
     * Define o CEP do cliente
     */
    public void setCep(String cep) {
        this.cep = cep;
    }
    
    /**
     * Retorna a rua do endereço
     */
    public String getRua() {
        return rua;
    }
    
    /**
     * Define a rua do endereço
     */
    public void setRua(String rua) {
        this.rua = rua;
    }
    
    /**
     * Retorna o número do endereço
     */
    public String getNumero() {
        return numero;
    }
    
    /**
     * Define o número do endereço
     */
    public void setNumero(String numero) {
        this.numero = numero;
    }
    
    /**
     * Retorna o bairro do endereço
     */
    public String getBairro() {
        return bairro;
    }
    
    /**
     * Define o bairro do endereço
     */
    public void setBairro(String bairro) {
        this.bairro = bairro;
    }
    
    /**
     * Retorna o complemento do endereço
     */
    public String getComplemento() {
        return complemento;
    }
    
    /**
     * Define o complemento do endereço
     */
    public void setComplemento(String complemento) {
        this.complemento = complemento;
    }
    
    /**
     * Retorna a cidade do endereço
     */
    public String getCidade() {
        return cidade;
    }
    
    /**
     * Define a cidade do endereço
     */
    public void setCidade(String cidade) {
        this.cidade = cidade;
    }
    
    /**
     * Retorna o tipo do cliente (admin ou cliente)
     */
    public String getTipo() {
        return tipo;
    }
    
    /**
     * Define o tipo do cliente
     */
    public void setTipo(String tipo) {
        this.tipo = tipo;
    }
    
    /**
     * Verifica se o cliente é administrador
     * retorma true se for admin e false se for cliente comum
     */
    public boolean isAdmin() {
        return "admin".equals(tipo);
    }
}