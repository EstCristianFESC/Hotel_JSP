package modelo;

import java.util.Date;

public class CheckInOut {
	private int id;
	private Reserva reserva;          // relación con la reserva
	private Date fechaCheckIn;
	private Date fechaCheckOut;
	private boolean realizadoCheckIn;
	private boolean realizadoCheckOut;

	public CheckInOut() {}

	public CheckInOut(int id, Reserva reserva, Date fechaCheckIn, Date fechaCheckOut,
			boolean realizadoCheckIn, boolean realizadoCheckOut) {
		this.id = id;
		this.reserva = reserva;
		this.fechaCheckIn = fechaCheckIn;
		this.fechaCheckOut = fechaCheckOut;
		this.realizadoCheckIn = realizadoCheckIn;
		this.realizadoCheckOut = realizadoCheckOut;
	}

	// Getters y Setters
	public int getId() { return id; }
	public void setId(int id) { this.id = id; }

	public Reserva getReserva() { return reserva; }
	public void setReserva(Reserva reserva) { this.reserva = reserva; }

	public Date getFechaCheckIn() { return fechaCheckIn; }
	public void setFechaCheckIn(Date fechaCheckIn) { this.fechaCheckIn = fechaCheckIn; }

	public Date getFechaCheckOut() { return fechaCheckOut; }
	public void setFechaCheckOut(Date fechaCheckOut) { this.fechaCheckOut = fechaCheckOut; }

	public boolean isRealizadoCheckIn() { return realizadoCheckIn; }
	public void setRealizadoCheckIn(boolean realizadoCheckIn) { this.realizadoCheckIn = realizadoCheckIn; }

	public boolean isRealizadoCheckOut() { return realizadoCheckOut; }
	public void setRealizadoCheckOut(boolean realizadoCheckOut) { this.realizadoCheckOut = realizadoCheckOut; }
}