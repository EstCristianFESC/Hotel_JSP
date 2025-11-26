package modelo;

import java.time.LocalDate;

public class Reserva {
    public static final String RESERVADA  = "RESERVADA";
    public static final String CANCELADA  = "CANCELADA";
    public static final String CHECKIN    = "CHECKIN";
    public static final String OUT        = "OUT";          // Check-out
    public static final String FINALIZADA = "FINALIZADA";

    private int id;
    private int clienteId;
    private int habitacionNumero;
    private LocalDate fechaEntrada;
    private LocalDate fechaSalida;
    private String estado;
    private double total;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getClienteId() {
        return clienteId;
    }

    public void setClienteId(int clienteId) {
        this.clienteId = clienteId;
    }

    public int getHabitacionNumero() {
        return habitacionNumero;
    }

    public void setHabitacionNumero(int habitacionNumero) {
        this.habitacionNumero = habitacionNumero;
    }

    public LocalDate getFechaEntrada() {
        return fechaEntrada;
    }

    public void setFechaEntrada(LocalDate fechaEntrada) {
        this.fechaEntrada = fechaEntrada;
    }

    public LocalDate getFechaSalida() {
        return fechaSalida;
    }

    public void setFechaSalida(LocalDate fechaSalida) {
        this.fechaSalida = fechaSalida;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }
}