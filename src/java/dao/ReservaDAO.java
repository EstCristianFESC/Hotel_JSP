package dao;

import modelo.Reserva;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReservaDAO {

    // Guardar reserva
    public boolean guardar(Reserva r) {
        String sql = "INSERT INTO reserva (cliente_id, habitacion_numero, fecha_entrada, fecha_salida, estado, total) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, r.getClienteId());
            ps.setInt(2, r.getHabitacionNumero());
            ps.setDate(3, Date.valueOf(r.getFechaEntrada()));
            ps.setDate(4, Date.valueOf(r.getFechaSalida()));
            ps.setString(5, "RESERVADA"); // Siempre al crear
            ps.setDouble(6, r.getTotal());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Listar todas las reservas
    public List<Reserva> listar() {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT * FROM reserva";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Reserva r = new Reserva();
                r.setId(rs.getInt("id"));
                r.setClienteId(rs.getString("cliente_id"));
                r.setHabitacionNumero(rs.getInt("habitacion_numero"));
                r.setFechaEntrada(rs.getDate("fecha_entrada").toLocalDate());
                r.setFechaSalida(rs.getDate("fecha_salida").toLocalDate());
                r.setEstado(rs.getString("estado"));
                r.setTotal(rs.getDouble("total"));
                lista.add(r);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Actualizar estado según fecha
    public void actualizarEstados() {
        String sql = "UPDATE reserva SET estado = CASE " +
                     "WHEN fecha_entrada <= CURDATE() AND fecha_salida >= CURDATE() THEN 'ACTIVA' " +
                     "WHEN fecha_salida < CURDATE() THEN 'FINALIZADA' " +
                     "ELSE 'RESERVADA' END";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Consultar reservas por habitación y rango de fechas (para disponibilidad)
    public boolean estaDisponible(int habitacionNumero, LocalDate entrada, LocalDate salida) {
        String sql = "SELECT COUNT(*) FROM reserva WHERE habitacion_numero=? AND estado IN ('RESERVADA','ACTIVA') AND " +
                     "((fecha_entrada <= ? AND fecha_salida > ?) OR (fecha_entrada < ? AND fecha_salida >= ?) OR (fecha_entrada >= ? AND fecha_salida <= ?))";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, habitacionNumero);
            ps.setDate(2, Date.valueOf(salida));
            ps.setDate(3, Date.valueOf(salida));
            ps.setDate(4, Date.valueOf(entrada));
            ps.setDate(5, Date.valueOf(entrada));
            ps.setDate(6, Date.valueOf(entrada));
            ps.setDate(7, Date.valueOf(salida));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0; // si hay 0 reservas en ese rango → disponible
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}