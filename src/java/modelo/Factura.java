package modelo;

import java.util.Date;
import java.util.List;

public class Factura {
    private int numeroFactura;
    private Date fecha;
    private Huesped huesped;
    private Reserva reserva;
    private List<DetalleFactura> detalles;
    private long total;

    public Factura() {}

    public Factura(int numeroFactura, Date fecha, Huesped huesped, Reserva reserva,
                   List<DetalleFactura> detalles, long total) {
        this.numeroFactura = numeroFactura;
        this.fecha = fecha;
        this.huesped = huesped;
        this.reserva = reserva;
        this.detalles = detalles;
        this.total = total;
    }

    public int getNumeroFactura() {
        return numeroFactura;
    }

    public void setNumeroFactura(int numeroFactura) {
        this.numeroFactura = numeroFactura;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public Huesped getHuesped() {
        return huesped;
    }

    public void setHuesped(Huesped huesped) {
        this.huesped = huesped;
    }

    public Reserva getReserva() {
        return reserva;
    }

    public void setReserva(Reserva reserva) {
        this.reserva = reserva;
    }

    public List<DetalleFactura> getDetalles() {
        return detalles;
    }

    public void setDetalles(List<DetalleFactura> detalles) {
        this.detalles = detalles;
    }

    public long getTotal() {
        return total;
    }

    public void setTotal(long total) {
        this.total = total;
    }
}