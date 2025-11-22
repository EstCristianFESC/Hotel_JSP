package dao;

import dao.Conexion;
import modelo.Reserva;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReservaDAO {

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

    public boolean habitacionDisponible(int numeroHabitacion, LocalDate entrada, LocalDate salida) {
        String sql = """
            SELECT COUNT(*) 
            FROM reservas
            WHERE habitacion_numero = ?
            AND estado IN ('RESERVADA','ACTIVA')
            AND NOT (
                fecha_salida <= ?  -- sale antes de que yo entre
                OR fecha_entrada >= ?  -- entra después de que yo salga
            )
            """;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, numeroHabitacion);
            ps.setDate(2, Date.valueOf(entrada)); // aquí va entrada
            ps.setDate(3, Date.valueOf(salida));  // aquí va salida

            ResultSet rs = ps.executeQuery();
            rs.next();

            // Si COUNT = 0 → está disponible
            return rs.getInt(1) == 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public double calcularTotal(double precio, LocalDate entrada, LocalDate salida) {
        long noches = java.time.temporal.ChronoUnit.DAYS.between(entrada, salida);
        if (noches <= 0) noches = 1;
        return precio * noches;
    }

    List<Reserva> buscarReservasPorRango(LocalDate entrada, LocalDate salida) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}