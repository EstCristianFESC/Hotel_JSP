package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Productos;

public class ProductosDAO {

    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public List<Productos> listar() {
        List<Productos> lista = new ArrayList<>();
        String sql = "SELECT * FROM restaurante_producto WHERE estado = 1";

        try {
            con = Conexion.getConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Productos p = new Productos(
                    rs.getInt("id"),
                    rs.getString("descripcion"),
                    rs.getLong("valor_unitario"),
                    rs.getInt("estado")
                );
                lista.add(p);
            }
        } catch (Exception e) {
            System.out.println("Error listar productos: " + e);
        }
        return lista;
    }

    public Productos buscarPorId(int id) {
        Productos p = null;
        String sql = "SELECT * FROM restaurante_producto WHERE id = ? AND estado = 1";

        try {
            con = Conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                p = new Productos(
                    rs.getInt("id"),
                    rs.getString("descripcion"),
                    rs.getLong("valor_unitario"),
                    rs.getInt("estado")
                );
            }
        } catch (Exception e) {
            System.out.println("Error buscar producto: " + e);
        }
        return p;
    }

    public boolean agregar(Productos p) {
        String sql = "INSERT INTO restaurante_producto (descripcion, valor_unitario) VALUES (?, ?)";

        try {
            con = Conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, p.getDescripcion());
            ps.setLong(2, p.getValorUnitario());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error agregar producto: " + e);
        }
        return false;
    }

    public boolean actualizar(Productos p) {
        String sql = "UPDATE restaurante_producto SET descripcion=?, valor_unitario=? WHERE id=?";

        try {
            con = Conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, p.getDescripcion());
            ps.setLong(2, p.getValorUnitario());
            ps.setInt(3, p.getId());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error actualizar: " + e);
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "UPDATE restaurante_producto SET estado=0 WHERE id=?";

        try {
            con = Conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error eliminar: " + e);
        }
        return false;
    }
    
    public List<Productos> filtrar(String idStr, String descripcion) {
        List<Productos> lista = new ArrayList<>();

        String sql = "SELECT * FROM restaurante_producto WHERE estado = 1";

        if (idStr != null && !idStr.isEmpty()) {
            sql += " AND id = " + idStr;
        }
        if (descripcion != null && !descripcion.trim().isEmpty()) {
            sql += " AND descripcion LIKE '%" + descripcion.trim() + "%'";
        }

        try {
            con = Conexion.getConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(new Productos(
                        rs.getInt("id"),
                        rs.getString("descripcion"),
                        rs.getLong("valor_unitario"),
                        rs.getInt("estado")
                ));
            }

        } catch (Exception e) {
            System.out.println("Error filtrar productos: " + e);
        }

        return lista;
    }
}