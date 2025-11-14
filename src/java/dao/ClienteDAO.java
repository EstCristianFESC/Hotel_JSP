package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Cliente;

/**
 * DAO encargado de las operaciones CRUD sobre la tabla cliente.
 * Gestiona conexión, consultas y actualizaciones.
 */
public class ClienteDAO {

    public boolean guardar(Cliente c) {
        String sql = "INSERT INTO cliente (id, tipo, nombre, apellido, telefono, direccion, email) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getId());
            ps.setString(2, c.getTipo());
            ps.setString(3, c.getNombre());
            ps.setString(4, c.getApellido());
            ps.setString(5, c.getTelefono());
            ps.setString(6, c.getDireccion());
            ps.setString(7, c.getEmail());

            return ps.executeUpdate() > 0;

        } catch (SQLIntegrityConstraintViolationException e) {
            System.err.println("Ya existe un cliente con ese ID: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Error SQL al guardar cliente: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Error inesperado al guardar cliente: " + e.getMessage());
        }
        return false;
    }

    public boolean editar(Cliente c) {
        String sql = "UPDATE cliente SET tipo=?, nombre=?, apellido=?, telefono=?, direccion=?, email=? WHERE id=?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getTipo());
            ps.setString(2, c.getNombre());
            ps.setString(3, c.getApellido());
            ps.setString(4, c.getTelefono());
            ps.setString(5, c.getDireccion());
            ps.setString(6, c.getEmail());
            ps.setString(7, c.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error SQL al editar cliente: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Error inesperado al editar cliente: " + e.getMessage());
        }
        return false;
    }

    public List<Cliente> buscarPorCriterio(String criterio) {
        List<Cliente> lista = new ArrayList<>();
        String sql = "SELECT * FROM cliente WHERE id LIKE ? OR nombre LIKE ? OR apellido LIKE ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String like = "%" + criterio + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cliente c = new Cliente();
                    c.setId(rs.getString("id"));
                    c.setTipo(rs.getString("tipo"));
                    c.setNombre(rs.getString("nombre"));
                    c.setApellido(rs.getString("apellido"));
                    c.setTelefono(rs.getString("telefono"));
                    c.setDireccion(rs.getString("direccion"));
                    c.setEmail(rs.getString("email"));
                    lista.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public Cliente buscarPorId(String id) {
        Cliente c = null;
        String sql = "SELECT * FROM cliente WHERE id = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    c = new Cliente();
                    c.setId(rs.getString("id"));
                    c.setTipo(rs.getString("tipo"));
                    c.setNombre(rs.getString("nombre"));
                    c.setApellido(rs.getString("apellido"));
                    c.setTelefono(rs.getString("telefono"));
                    c.setDireccion(rs.getString("direccion"));
                    c.setEmail(rs.getString("email"));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error SQL al buscar cliente por ID: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Error inesperado al buscar cliente por ID: " + e.getMessage());
        }

        return c;
    }
}