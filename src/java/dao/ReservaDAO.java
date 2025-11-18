package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import modelo.Reserva;

public class ReservaDAO {
    // Guardar nueva reserva
    public boolean guardar(Reserva r) {
        String sql = "INSERT INTO reserva (clienteId, habitacionNumero, fechaEntrada, fechaSalida, estado, total) "
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

        } catch (SQLException e) {
            System.err.println("Error al guardar reserva: " + e.getMessage());
        }

        return false;
    }

    // Actualizar reserva existente
    public boolean actualizar(Reserva r) {
        String sql = "UPDATE reserva SET clienteId=?, habitacionNumero=?, fechaEntrada=?, "
                   + "fechaSalida=?, estado=?, total=? WHERE id=?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, r.getClienteId());
            ps.setInt(2, r.getHabitacionNumero());
            ps.setDate(3, Date.valueOf(r.getFechaEntrada()));
            ps.setDate(4, Date.valueOf(r.getFechaSalida()));
            ps.setString(5, r.getEstado());
            ps.setDouble(6, r.getTotal());
            ps.setInt(7, r.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar reserva: " + e.getMessage());
        }

        return false;
    }

    // Buscar reserva por ID
    public Reserva buscarPorId(int id) {
        String sql = "SELECT * FROM reserva WHERE id = ?";
        Reserva r = null;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    r = mapearReserva(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar reserva por ID: " + e.getMessage());
        }

        return r;
    }

    // Listar todas las reservas
    public List<Reserva> listar() {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT * FROM reserva ORDER BY fechaEntrada DESC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearReserva(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error al listar reservas: " + e.getMessage());
        }

        return lista;
    }

    // Mapear ResultSet a objeto Reserva
    private Reserva mapearReserva(ResultSet rs) throws SQLException {
        Reserva r = new Reserva();
        r.setId(rs.getInt("id"));
        r.setClienteId(rs.getInt("clienteId"));
        r.setHabitacionNumero(rs.getInt("habitacionNumero"));
        r.setFechaEntrada(rs.getDate("fechaEntrada").toLocalDate());
        r.setFechaSalida(rs.getDate("fechaSalida").toLocalDate());
        r.setEstado(rs.getString("estado"));
        r.setTotal(rs.getDouble("total"));
        return r;
    }

    // Buscar reservas que se cruzan con un rango de fechas
    public List<Reserva> buscarReservasPorRango(LocalDate entrada, LocalDate salida) {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT * FROM reserva WHERE (fechaEntrada <= ? AND fechaSalida >= ?)";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(salida));
            ps.setDate(2, Date.valueOf(entrada));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearReserva(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar reservas por rango: " + e.getMessage());
        }

        return lista;
    }
}