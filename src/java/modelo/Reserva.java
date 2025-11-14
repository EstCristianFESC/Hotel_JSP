package modelo;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class Reserva {
	private String codigo;
	private Cliente cliente;
	private Habitacion habitacion;
	private LocalDate fechaIngreso;
	private LocalDate fechaSalida;
	private boolean checkIn;
	private boolean checkOut;
	private List<Restaurante> consumos;  // cargos de comida/bebida
	private long subtotal;
	private long iva;
	private long total;

	public Reserva() {
		consumos = new ArrayList<>();
	}

	public Reserva(String codigo, Cliente cliente, Habitacion habitacion, LocalDate fechaIngreso, LocalDate fechaSalida) {
		this.codigo = codigo;
		this.cliente = cliente;
		this.habitacion = habitacion;
		this.fechaIngreso = fechaIngreso;
		this.fechaSalida = fechaSalida;
		this.checkIn = false;
		this.checkOut = false;
		this.consumos = new ArrayList<>();
		calcularTotales();
	}

	public void agregarConsumo(Restaurante consumo) {
		consumos.add(consumo);
		calcularTotales();
	}

	public void calcularTotales() {
		int dias = (int) ChronoUnit.DAYS.between(fechaIngreso, fechaSalida);
		if (dias <= 0) dias = 1;

		long totalHabitacion = (long) (habitacion.getPrecioPorNoche() * dias);
		long totalConsumos = consumos.stream().mapToLong(Restaurante::getTotal).sum();

		subtotal = totalHabitacion + totalConsumos;
		iva = Math.round(subtotal * 0.19);
		total = subtotal + iva;
	}

	public void realizarCheckIn() { this.checkIn = true; }
	public void realizarCheckOut() { this.checkOut = true; }

	// Getters y Setters
	public String getCodigo() { return codigo; }
	public void setCodigo(String codigo) { this.codigo = codigo; }

	public Cliente getCliente() { return cliente; }
	public void setCliente(Cliente cliente) { this.cliente = cliente; }

	public Habitacion getHabitacion() { return habitacion; }
	public void setHabitacion(Habitacion habitacion) { this.habitacion = habitacion; }

	public LocalDate getFechaIngreso() { return fechaIngreso; }
	public void setFechaIngreso(LocalDate fechaIngreso) { this.fechaIngreso = fechaIngreso; }

	public LocalDate getFechaSalida() { return fechaSalida; }
	public void setFechaSalida(LocalDate fechaSalida) { this.fechaSalida = fechaSalida; }

	public boolean isCheckIn() { return checkIn; }
	public void setCheckIn(boolean checkIn) { this.checkIn = checkIn; }

	public boolean isCheckOut() { return checkOut; }
	public void setCheckOut(boolean checkOut) { this.checkOut = checkOut; }

	public List<Restaurante> getConsumos() { return consumos; }
	public long getSubtotal() { return subtotal; }
	public long getIva() { return iva; }
	public long getTotal() { return total; }
}