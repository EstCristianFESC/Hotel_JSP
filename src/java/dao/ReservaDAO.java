package dao;

import dao.Conexion;
import modelo.Reserva;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReservaDAO {

    public boolean insertar(Reserva r) {
        String sql = "INSERT INTO reserva (cliente_id, habitacion_numero, fecha_entrada, fecha_salida, estado, total) "
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

    public boolean habitacionDisponible(int numeroHabitacion, LocalDate entrada, LocalDate salida) {

        String sql = """
            SELECT 1
            FROM reserva
            WHERE habitacion_numero = ?
            AND estado IN ('RESERVADA','ACTIVA')
            AND fecha_entrada < ?
            AND fecha_salida > ?
            LIMIT 1
        """;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, numeroHabitacion);
            ps.setDate(2, Date.valueOf(salida));   // límite superior
            ps.setDate(3, Date.valueOf(entrada));  // límite inferior

            ResultSet rs = ps.executeQuery();

            // Si devuelve AL MENOS una fila → hay choque → no está disponible
            return !rs.next();

        } catch (Exception e) {
            e.printStackTrace();
            return false; // por seguridad, si falla → mejor no listarlo
        }
    }

    public double calcularTotal(double precio, LocalDate entrada, LocalDate salida) {
        long noches = java.time.temporal.ChronoUnit.DAYS.between(entrada, salida);
        if (noches <= 0) noches = 1;
        return precio * noches;
    }
    
    public List<Reserva> buscarReservasPorRango(LocalDate entrada, LocalDate salida) {
        List<Reserva> lista = new ArrayList<>();

        String sql = """
            SELECT * 
            FROM reserva
            WHERE estado IN ('RESERVADA','ACTIVA')
            AND (
                fecha_entrada < ? 
                AND fecha_salida > ?
            )
        """;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, java.sql.Date.valueOf(salida));
            ps.setDate(2, java.sql.Date.valueOf(entrada));

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
}