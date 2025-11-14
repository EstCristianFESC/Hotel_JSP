package modelo;

public class Restaurante {
	private String descripcion;  // Ej: "Desayuno", "Agua", "Almuerzo", etc.
	private int cantidad;
	private long valorUnitario;

	public Restaurante() {}

	public Restaurante(String descripcion, int cantidad, long valorUnitario) {
		this.descripcion = descripcion;
		this.cantidad = cantidad;
		this.valorUnitario = valorUnitario;
	}

	public long getTotal() {
		return cantidad * valorUnitario;
	}

	// Getters y Setters
	public String getDescripcion() { return descripcion; }
	public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

	public int getCantidad() { return cantidad; }
	public void setCantidad(int cantidad) { this.cantidad = cantidad; }

	public long getValorUnitario() { return valorUnitario; }
	public void setValorUnitario(long valorUnitario) { this.valorUnitario = valorUnitario; }
}