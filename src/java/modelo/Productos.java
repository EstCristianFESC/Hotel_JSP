package modelo;

public class Productos {
    private int id;
    private String descripcion;
    private long valorUnitario;
    private int estado;

    public Productos() {}

    public Productos(int id, String descripcion, long valorUnitario, int estado) {
        this.id = id;
        this.descripcion = descripcion;
        this.valorUnitario = valorUnitario;
        this.estado = estado;
    }

    // Getters y setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public long getValorUnitario() { return valorUnitario; }
    public void setValorUnitario(long valorUnitario) { this.valorUnitario = valorUnitario; }

    public int getEstado() { return estado; }
    public void setEstado(int estado) { this.estado = estado; }
}