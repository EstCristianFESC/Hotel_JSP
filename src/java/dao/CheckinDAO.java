package dao;

import modelo.Checkin;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import modelo.Consumo;

public class CheckinDAO {

    public boolean registrarCheckin(Checkin c) {
        String sql = "INSERT INTO checkin (id_reserva, fecha_checkin, observaciones, total_habitacion, estado) "
                   + "VALUES (?, NOW(), ?, ?, 'ACTIVO')";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, c.getIdReserva());
            ps.setString(2, c.getObservaciones());
            ps.setLong(3, c.getTotalHabitacion());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) c.setIdCheckin(keys.getInt(1));
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int obtenerIdHabitacionPorReserva(int idReserva) {
        String sql = "SELECT habitacion_numero FROM reserva WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idReserva);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("habitacion_numero");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean actualizarEstadoHabitacion(int numeroHabitacion, boolean ocupada) {
        String sql = "UPDATE habitacion SET disponible = ? WHERE numero = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, !ocupada);
            ps.setInt(2, numeroHabitacion);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarEstadoReserva(int idReserva) {
        String sql = "UPDATE reserva SET estado = 'CHECKIN' WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idReserva);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /*** CONSUMOS ***/
    public boolean agregarConsumo(int idCheckin, int idProducto, int cantidad, long valorUnitario) {
        String sql = "INSERT INTO checkin_consumo (id_checkin, id_producto, cantidad, valor_unitario) "
                   + "VALUES (?, ?, ?, ?)";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCheckin);
            ps.setInt(2, idProducto);
            ps.setInt(3, cantidad);
            ps.setLong(4, valorUnitario);

            int ok = ps.executeUpdate();
            if (ok > 0) {
                // recalcular total de consumos en el checkin
                actualizarTotalConsumos(idCheckin, con);
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private void actualizarTotalConsumos(int idCheckin, Connection con) throws SQLException {
        String sumSql = "SELECT COALESCE(SUM(subtotal),0) AS suma FROM checkin_consumo WHERE id_checkin = ?";
        try (PreparedStatement ps = con.prepareStatement(sumSql)) {
            ps.setInt(1, idCheckin);
            ResultSet rs = ps.executeQuery();
            long suma = 0;
            if (rs.next()) suma = rs.getLong("suma");

            String upd = "UPDATE checkin SET total_consumos = ? WHERE id_checkin = ?";
            try (PreparedStatement ps2 = con.prepareStatement(upd)) {
                ps2.setLong(1, suma);
                ps2.setInt(2, idCheckin);
                ps2.executeUpdate();
            }
        }
    }

    public List<Consumo> listarConsumos(int idCheckin) {
        List<Consumo> lista = new ArrayList<>();
        String sql = "SELECT c.id, c.id_producto, p.descripcion, c.cantidad, c.valor_unitario, c.subtotal, c.fecha " +
                     "FROM checkin_consumo c JOIN restaurante_producto p ON c.id_producto = p.id " +
                     "WHERE c.id_checkin = ? ORDER BY c.fecha DESC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCheckin);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Consumo c = new Consumo();
                c.setId(rs.getInt("id"));
                c.setIdProducto(rs.getInt("id_producto"));
                c.setNombreProducto(rs.getString("descripcion"));
                c.setCantidad(rs.getInt("cantidad"));
                c.setValorUnitario(rs.getLong("valor_unitario"));
                c.setSubtotal(rs.getLong("subtotal"));
                c.setFecha(rs.getString("fecha"));
                lista.add(c);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public void recalcularTotalConsumos(int idCheckin) {
        String sql = "UPDATE checkin c " +
                     "JOIN (SELECT id_checkin, SUM(subtotal) AS total FROM checkin_consumo WHERE id_checkin = ?) x " +
                     "ON c.id_checkin = x.id_checkin " +
                     "SET c.total_consumos = x.total";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCheckin);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void actualizarTotalReserva(int idReserva) {
        String sql = 
            "UPDATE reserva r " +
            "JOIN checkin c ON c.id_reserva = r.id " +
            "SET r.total = c.total_final " +
            "WHERE r.id = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReserva);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int obtenerIdReservaPorCheckin(int idCheckin) {
        String sql = "SELECT id_reserva FROM checkin WHERE id_checkin = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCheckin);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Checkin obtenerCheckin(int idCheckin) {
        String sql = "SELECT * FROM checkin WHERE id_checkin = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCheckin);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Checkin c = new Checkin();
                c.setIdCheckin(rs.getInt("id_checkin"));
                c.setIdReserva(rs.getInt("id_reserva"));
                c.setObservaciones(rs.getString("observaciones"));
                c.setTotalHabitacion(rs.getLong("total_habitacion"));
                c.setTotalConsumos(rs.getLong("total_consumos"));
                c.setTotalFinal(rs.getLong("total_final"));
                c.setEstado(rs.getString("estado"));
                c.setFechaCheckin(rs.getString("fecha_checkin"));
                return c;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void actualizarTotalFinal(int idCheckin) {
        String sql = "UPDATE checkin SET total_final = total_habitacion + total_consumos WHERE id_checkin = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCheckin);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Listar checkouts por fecha de salida
    public List<Checkin> listarCheckoutsPorFecha(LocalDate fecha) {
        List<Checkin> lista = new ArrayList<>();
        String sql = "SELECT * FROM checkin WHERE fechaCheckin = ? AND estado = 'ACTIVO'"; // ajustar según tu BD

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, fecha.toString()); // como fechaCheckin es String en tu modelo
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Checkin c = new Checkin();
                    c.setIdCheckin(rs.getInt("idCheckin"));
                    c.setIdReserva(rs.getInt("idReserva"));
                    c.setFechaCheckin(rs.getString("fechaCheckin"));
                    c.setObservaciones(rs.getString("observaciones"));
                    c.setTotalHabitacion(rs.getLong("totalHabitacion"));
                    c.setTotalConsumos(rs.getLong("totalConsumos"));
                    c.setTotalFinal(rs.getLong("totalFinal"));
                    c.setEstado(rs.getString("estado"));
                    c.setCantidadPersonas(rs.getInt("cantidadPersonas"));
                    lista.add(c);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    // Listar todos los checkins activos
    public List<Checkin> listarCheckinsActivos() {
        List<Checkin> lista = new ArrayList<>();
        String sql = "SELECT * FROM checkin WHERE estado = 'ACTIVO'";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Checkin c = new Checkin();
                c.setIdCheckin(rs.getInt("idCheckin"));
                c.setIdReserva(rs.getInt("idReserva"));
                c.setFechaCheckin(rs.getString("fechaCheckin"));
                c.setObservaciones(rs.getString("observaciones"));
                c.setTotalHabitacion(rs.getLong("totalHabitacion"));
                c.setTotalConsumos(rs.getLong("totalConsumos"));
                c.setTotalFinal(rs.getLong("totalFinal"));
                c.setEstado(rs.getString("estado"));
                c.setCantidadPersonas(rs.getInt("cantidadPersonas"));
                lista.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }
}