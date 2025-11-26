package modelo;

public class DetalleFactura {
    private String descripcion;
    private int cantidad;
    private long subtotal;

    public DetalleFactura() {}

    public DetalleFactura(String descripcion, int cantidad, long subtotal) {
        this.descripcion = descripcion;
        this.cantidad = cantidad;
        this.subtotal = subtotal;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public long getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(long subtotal) {
        this.subtotal = subtotal;
    }
}