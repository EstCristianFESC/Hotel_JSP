package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Habitacion;

public class HabitacionDAO {

    public boolean guardar(Habitacion h) {
        String sql = "INSERT INTO habitacion (numero, tipo, descripcion, precioPorNoche, disponible) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, h.getNumero());
            ps.setString(2, h.getTipo());
            ps.setString(3, h.getDescripcion());
            ps.setBigDecimal(4, BigDecimal.valueOf(h.getPrecioPorNoche()));
            ps.setBoolean(5, h.isDisponible());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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
                h.setPrecioPorNoche(rs.getLong("precioPorNoche"));
                h.setDisponible(rs.getBoolean("disponible"));
                lista.add(h);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
}