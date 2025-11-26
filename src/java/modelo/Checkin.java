package modelo;

public class Checkin {

    private int idCheckin;
    private int idReserva;
    private String fechaCheckin;
    private String observaciones;
    private long totalHabitacion;
    private long totalConsumos;
    private long totalFinal;   // generado por BD, pero lo mapeamos igual
    private String estado;
    private int cantidadPersonas;

    public int getIdCheckin() {
        return idCheckin;
    }

    public void setIdCheckin(int idCheckin) {
        this.idCheckin = idCheckin;
    }

    public int getIdReserva() {
        return idReserva;
    }

    public void setIdReserva(int idReserva) {
        this.idReserva = idReserva;
    }

    public String getFechaCheckin() {
        return fechaCheckin;
    }

    public void setFechaCheckin(String fechaCheckin) {
        this.fechaCheckin = fechaCheckin;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public long getTotalHabitacion() {
        return totalHabitacion;
    }

    public void setTotalHabitacion(long totalHabitacion) {
        this.totalHabitacion = totalHabitacion;
    }

    public long getTotalConsumos() {
        return totalConsumos;
    }

    public void setTotalConsumos(long totalConsumos) {
        this.totalConsumos = totalConsumos;
    }

    public long getTotalFinal() {
        return totalFinal;
    }

    public void setTotalFinal(long totalFinal) {
        this.totalFinal = totalFinal;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    public int getCantidadPersonas() {
        return cantidadPersonas;
    }

    public void setCantidadPersonas(int cantidadPersonas) {
        this.cantidadPersonas = cantidadPersonas;
    }
}