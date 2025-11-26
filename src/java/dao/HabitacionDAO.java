package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import modelo.Habitacion;
import modelo.Reserva;

public class HabitacionDAO {

    public boolean guardar(Habitacion h) {
        String sql = "INSERT INTO habitacion (numero, tipo, descripcion, precioPorNoche, disponible) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, h.getNumero());
            ps.setString(2, h.getTipo());
            ps.setString(3, h.getDescripcion());
            ps.setBigDecimal(4, java.math.BigDecimal.valueOf(h.getPrecioPorNoche()));
            ps.setBoolean(5, h.isDisponible());

            return ps.executeUpdate() > 0;

        } catch (SQLIntegrityConstraintViolationException e) {
            System.err.println("Ya existe una habitación con ese número: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Error SQL al guardar habitación: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Error inesperado al guardar habitación: " + e.getMessage());
        }
        return false;
    }

    public boolean editar(Habitacion h) {
        String sql = "UPDATE habitacion SET tipo=?, descripcion=?, precioPorNoche=?, disponible=? WHERE numero=?";
        try (Connection con = Conexion.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, h.getTipo());
            ps.setString(2, h.getDescripcion());
            ps.setLong(3, (long) h.getPrecioPorNoche());
            ps.setBoolean(4, h.isDisponible());
            ps.setInt(5, h.getNumero());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Habitacion> listar() {
        List<Habitacion> lista = new ArrayList<>();
        String sql = "SELECT * FROM habitacion";

        try (Connection con = Conexion.getConexion();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Habitacion h = new Habitacion();
                h.setNumero(rs.getInt("numero"));
                h.setTipo(rs.getString("tipo"));
                h.setDescripcion(rs.getString("descripcion"));
                h.setPrecioPorNoche(rs.getDouble("precioPorNoche"));
                h.setDisponible(rs.getBoolean("disponible"));
                lista.add(h);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    public Habitacion buscarPorNumero(int numero) {
        Habitacion h = null;
        String sql = "SELECT * FROM habitacion WHERE numero = ?";
        try (Connection con = Conexion.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, numero);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    h = new Habitacion();
                    h.setNumero(rs.getInt("numero"));
                    h.setTipo(rs.getString("tipo"));
                    h.setDescripcion(rs.getString("descripcion"));
                    h.setPrecioPorNoche(rs.getLong("precioPorNoche"));
                    h.setDisponible(rs.getBoolean("disponible"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return h;
    }

    public List<Habitacion> buscarPorCriterio(String criterio) {
        List<Habitacion> lista = new ArrayList<>();
        String sql = "SELECT * FROM habitacion WHERE CAST(numero AS CHAR) LIKE ? OR disponible LIKE ?";

        try (Connection con = Conexion.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            String like = "%" + criterio + "%";
            ps.setString(1, like);

            // Si el criterio contiene "disponible" o "ocupada"
            boolean disp = "disponible".equalsIgnoreCase(criterio);
            ps.setString(2, disp ? "1" : "0");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Habitacion h = new Habitacion();
                    h.setNumero(rs.getInt("numero"));
                    h.setTipo(rs.getString("tipo"));
                    h.setDescripcion(rs.getString("descripcion"));
                    h.setPrecioPorNoche(rs.getDouble("precioPorNoche"));
                    h.setDisponible(rs.getBoolean("disponible"));
                    lista.add(h);
                }
            }

        } catch (Exception e) {
            System.err.println("Error al buscar habitaciones: " + e.getMessage());
        }

        return lista;
    }

    public List<Habitacion> listarDisponibles() {
        List<Habitacion> lista = new ArrayList<>();
        String sql = "SELECT * FROM habitacion WHERE disponible = 1";

        try (Connection con = Conexion.getConexion();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Habitacion h = new Habitacion();
                h.setNumero(rs.getInt("numero"));
                h.setTipo(rs.getString("tipo"));
                h.setDescripcion(rs.getString("descripcion"));
                h.setPrecioPorNoche(rs.getDouble("precioPorNoche"));
                h.setDisponible(rs.getBoolean("disponible"));
                lista.add(h);
            }

        } catch (Exception e) {
            System.err.println("Error al listar habitaciones disponibles: " + e.getMessage());
        }

        return lista;
    }

    public List<Habitacion> listarDisponibles(LocalDate entrada, LocalDate salida) {
        List<Habitacion> disponibles = new ArrayList<>();

        // Consulta SQL para obtener habitaciones disponibles en el rango de fechas
        String sql = """
            SELECT h.numero, h.tipo, h.descripcion, h.precioPorNoche, h.disponible
            FROM habitacion h
            WHERE h.disponible = 1
            AND h.numero NOT IN (
                SELECT r.habitacion_numero
                FROM reserva r
                WHERE r.estado IN ('RESERVADA', 'ACTIVA')
                AND r.fecha_entrada < ?
                AND r.fecha_salida > ?
            )
        """;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // Establecer los parámetros de fecha en la consulta SQL
            ps.setDate(1, Date.valueOf(salida));  // Fecha de salida
            ps.setDate(2, Date.valueOf(entrada)); // Fecha de entrada

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Habitacion h = new Habitacion();
                h.setNumero(rs.getInt("numero"));
                h.setTipo(rs.getString("tipo"));
                h.setDescripcion(rs.getString("descripcion"));
                h.setPrecioPorNoche(rs.getDouble("precioPorNoche"));
                h.setDisponible(rs.getBoolean("disponible"));
                disponibles.add(h);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return disponibles;
    }
    
    public Habitacion obtenerPorId(int id) {
        Habitacion h = null;
        String sql = "SELECT * FROM habitacion WHERE numero = ?"; // tu PK es 'numero'

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    h = new Habitacion();
                    h.setNumero(rs.getInt("numero"));
                    h.setTipo(rs.getString("tipo"));
                    h.setDescripcion(rs.getString("descripcion"));
                    h.setPrecioPorNoche(rs.getDouble("precioPorNoche"));
                    h.setDisponible(rs.getBoolean("disponible"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return h;
    }
}