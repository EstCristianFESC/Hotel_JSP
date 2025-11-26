package modelo;

public class Consumo {
    private int id;
    private int idProducto;
    private String nombreProducto;
    private int cantidad;
    private long valorUnitario;
    private long subtotal;
    private String fecha;

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getIdProducto() { return idProducto; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }
    public String getNombreProducto() { return nombreProducto; }
    public void setNombreProducto(String nombreProducto) { this.nombreProducto = nombreProducto; }
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    public long getValorUnitario() { return valorUnitario; }
    public void setValorUnitario(long valorUnitario) { this.valorUnitario = valorUnitario; }
    public long getSubtotal() { return subtotal; }
    public void setSubtotal(long subtotal) { this.subtotal = subtotal; }
    public String getFecha() { return fecha; }
    public void setFecha(String fecha) { this.fecha = fecha; }
}