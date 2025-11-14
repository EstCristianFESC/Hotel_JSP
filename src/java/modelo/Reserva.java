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
	private long subtotal;
	private long iva;
	private long total;
}