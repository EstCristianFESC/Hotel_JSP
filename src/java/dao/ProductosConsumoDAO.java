package dao;

import java.sql.*;
import modelo.ProductosConsumo;

public class ProductosConsumoDAO {

    Connection con;
    PreparedStatement ps;

    public boolean registrarConsumo(ProductosConsumo c) {
        String sql = "INSERT INTO restaurante_consumo (descripcion, cantidad, valor_unitario, total) VALUES (?, ?, ?, ?)";

        try {
            con = Conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getDescripcion());
            ps.setInt(2, c.getCantidad());
            ps.setLong(3, c.getValorUnitario());
            ps.setLong(4, c.getTotal());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error registrar consumo: " + e);
        }
        return false;
    }
}