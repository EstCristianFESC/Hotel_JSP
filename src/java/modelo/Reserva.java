package modelo;

import java.time.LocalDate;

public class Reserva {
    private int id;
    private String clienteId;
    private int habitacionNumero;
    private LocalDate fechaEntrada;
    private LocalDate fechaSalida;
    private String estado; // RESERVADA, ACTIVA, FINALIZADA
    private double total;

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getClienteId() { return clienteId; }
    public void setClienteId(String clienteId) { this.clienteId = clienteId; }

    public int getHabitacionNumero() { return habitacionNumero; }
    public void setHabitacionNumero(int habitacionNumero) { this.habitacionNumero = habitacionNumero; }

    public LocalDate getFechaEntrada() { return fechaEntrada; }
    public void setFechaEntrada(LocalDate fechaEntrada) { this.fechaEntrada = fechaEntrada; }

    public LocalDate getFechaSalida() { return fechaSalida; }
    public void setFechaSalida(LocalDate fechaSalida) { this.fechaSalida = fechaSalida; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
}