package dao;

import dao.Conexion;
import modelo.Reserva;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReservaDAO {

    // Insertar reserva
    public boolean insertar(Reserva r) {
        String sql = "INSERT INTO reservas (cliente_id, habitacion_numero, fecha_entrada, fecha_salida, estado, total) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = Conexion.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, r.getClienteId());
            ps.setInt(2, r.getHabitacionNumero());
            ps.setDate(3, Date.valueOf(r.getFechaEntrada()));
            ps.setDate(4, Date.valueOf(r.getFechaSalida()));
            ps.setString(5, r.getEstado());
            ps.setDouble(6, r.getTotal());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Validar disponibilidad (rango de fechas)
    public boolean habitacionDisponible(int numeroHabitacion, LocalDate entrada, LocalDate salida) {
        String sql = "SELECT * FROM reservas "
                + "WHERE habitacion_numero = ? "
                + "AND ( ? < fecha_salida AND ? > fecha_entrada ) "
                + "AND estado IN ('RESERVADA','ACTIVA')";

        try (Connection con = Conexion.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, numeroHabitacion);
            ps.setDate(2, Date.valueOf(salida));
            ps.setDate(3, Date.valueOf(entrada));

            ResultSet rs = ps.executeQuery();
            return !rs.next(); // true si NO hay choque

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Buscar reservas que chocan con un rango de fechas
    public List<Reserva> buscarReservasPorRango(LocalDate entrada, LocalDate salida) {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT * FROM reservas "
                + "WHERE ( ? < fecha_salida AND ? > fecha_entrada ) "
                + "AND estado IN ('RESERVADA','ACTIVA')";

        try (Connection con = Conexion.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(salida));
            ps.setDate(2, Date.valueOf(entrada));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reserva r = new Reserva();
                    r.setId(rs.getInt("id"));
                    r.setClienteId(rs.getInt("cliente_id"));
                    r.setHabitacionNumero(rs.getInt("habitacion_numero"));
                    r.setFechaEntrada(rs.getDate("fecha_entrada").toLocalDate());
                    r.setFechaSalida(rs.getDate("fecha_salida").toLocalDate());
                    r.setEstado(rs.getString("estado"));
                    r.setTotal(rs.getDouble("total"));
                    lista.add(r);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Listar reservas
    public List<Reserva> listar() {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT * FROM reservas";

        try (Connection con = Conexion.getConexion();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Reserva r = new Reserva();
                r.setId(rs.getInt("id"));
                r.setClienteId(rs.getInt("cliente_id"));
                r.setHabitacionNumero(rs.getInt("habitacion_numero"));
                r.setFechaEntrada(rs.getDate("fecha_entrada").toLocalDate());
                r.setFechaSalida(rs.getDate("fecha_salida").toLocalDate());
                r.setEstado(rs.getString("estado"));
                r.setTotal(rs.getDouble("total"));
                lista.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Calcular total (precio x noches)
    public double calcularTotal(double precio, LocalDate entrada, LocalDate salida) {
        long noches = java.time.temporal.ChronoUnit.DAYS.between(entrada, salida);
        if (noches <= 0)
            noches = 1;
        return precio * noches;
    }

}