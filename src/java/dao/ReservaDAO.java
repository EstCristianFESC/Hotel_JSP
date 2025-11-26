package dao;

import dao.Conexion;
import modelo.Reserva;

import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
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
            ps.setDate(2, Date.valueOf(salida));
            ps.setDate(3, Date.valueOf(entrada));

            ResultSet rs = ps.executeQuery();
            return !rs.next();

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

    public List<Reserva> buscarReservasPorRango(LocalDate entrada, LocalDate salida) {
        List<Reserva> lista = new ArrayList<>();

        String sql = """
            SELECT * 
            FROM reserva
            WHERE estado IN ('RESERVADA','ACTIVA')
            AND fecha_entrada < ? 
            AND fecha_salida > ?
        """;

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

    public List<Reserva> listarPorCliente(int clienteId) {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT * FROM reserva WHERE cliente_id = ? ORDER BY fecha_entrada DESC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, clienteId);

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

    public List<Reserva> buscarReservasPorClienteYFechas(int clienteId, LocalDate entrada, LocalDate salida) {
        List<Reserva> lista = new ArrayList<>();
        String sql = """
            SELECT * 
            FROM reserva
            WHERE cliente_id = ?
              AND estado IN ('RESERVADA','ACTIVA')
              AND fecha_entrada < ?
              AND fecha_salida > ?
            ORDER BY fecha_entrada DESC
        """;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, clienteId);
            ps.setDate(2, Date.valueOf(salida));
            ps.setDate(3, Date.valueOf(entrada));

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

    public boolean actualizarEstado(int idReserva, String estado) {
        String sql = "UPDATE reserva SET estado = ? WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, estado);
            ps.setInt(2, idReserva);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int obtenerIdHabitacionPorReserva(int idReserva) {
        String sql = "SELECT habitacion_numero FROM reserva WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReserva);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("habitacion_numero");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1; // indica que no se encontró
    }
    
    public Reserva listarPorId(int idReserva) {
        String sql = "SELECT * FROM reserva WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idReserva);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Reserva r = new Reserva();
                    r.setId(rs.getInt("id"));
                    // cliente_id en DB es varchar, tu modelo usa int -> parsea con cuidado
                    try { r.setClienteId(Integer.parseInt(rs.getString("cliente_id"))); } catch (Exception ex) { r.setClienteId(0); }
                    r.setHabitacionNumero(rs.getInt("habitacion_numero"));
                    r.setFechaEntrada(rs.getDate("fecha_entrada").toLocalDate());
                    r.setFechaSalida(rs.getDate("fecha_salida").toLocalDate());
                    r.setEstado(rs.getString("estado"));
                    r.setTotal(rs.getDouble("total"));
                    return r;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public int obtenerIdCheckinPorReserva(int idReserva) {
        String sql = "SELECT id_checkin FROM checkin WHERE id_reserva = ? ORDER BY id_checkin DESC LIMIT 1";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReserva);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return rs.getInt("id_checkin");

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    public boolean actualizarTotal(int idReserva) {
        String sql = """
            UPDATE reserva r SET r.total = ( SELECT COALESCE(SUM(c.total), 0) FROM consumo c WHERE c.id_reserva = ? ) WHERE r.id = ? """;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReserva);
            ps.setInt(2, idReserva);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int calcularDiasEstadia(LocalDate fechaEntrada, LocalDate fechaSalida) {
        return (int) ChronoUnit.DAYS.between(fechaEntrada, fechaSalida);
    }
    
    public boolean actualizarEstadoReservaFinalizada(int idReserva) {
        return actualizarEstado(idReserva, "FINALIZADA");
    }
    
    public List<Reserva> listarPorFechaEntrada(LocalDate fecha) {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT * FROM reserva WHERE fecha_entrada = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(fecha));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reserva r = new Reserva();
                    r.setId(rs.getInt("id"));
                    r.setClienteId(rs.getInt("cliente_id"));
                    r.setHabitacionNumero(rs.getInt("habitacion_numero"));
                    r.setFechaEntrada(rs.getDate("fecha_entrada").toLocalDate());
                    r.setFechaSalida(rs.getDate("fecha_salida").toLocalDate());
                    r.setEstado(rs.getString("estado"));
                    lista.add(r);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }
    
    public List<Reserva> listarPorFechaEntradaYEstado(LocalDate fecha, List<String> estados) {
        List<Reserva> lista = new ArrayList<>();
        if (estados == null || estados.isEmpty()) {
            return lista;
        }

        StringBuilder sql = new StringBuilder(
            "SELECT * FROM reserva WHERE fecha_entrada = ? AND estado IN ("
        );

        // Generar placeholders ? para cada estado
        for (int i = 0; i < estados.size(); i++) {
            sql.append("?");
            if (i < estados.size() - 1) {
                sql.append(",");
            }
        }
        sql.append(")");

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            ps.setDate(1, Date.valueOf(fecha));

            // Agregar los estados como parámetros
            for (int i = 0; i < estados.size(); i++) {
                ps.setString(i + 2, estados.get(i));
            }

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

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
}