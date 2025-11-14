package modelo;

public class ProductosConsumo {
    private int id;
    private String descripcion;
    private int cantidad;
    private long valorUnitario;
    private long total;

    public ProductosConsumo() {}

    public ProductosConsumo(int id, String descripcion, int cantidad, long valorUnitario) {
        this.id = id;
        this.descripcion = descripcion;
        this.cantidad = cantidad;
        this.valorUnitario = valorUnitario;
        this.total = cantidad * valorUnitario;
    }

    // Getters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }

    public long getValorUnitario() { return valorUnitario; }
    public void setValorUnitario(long valorUnitario) { this.valorUnitario = valorUnitario; }

    public long getTotal() { return total; }
    public void setTotal(long total) { this.total = total; }
}