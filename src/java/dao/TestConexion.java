package dao;

import java.sql.Connection;

public class TestConexion {
    public static void main(String[] args) {
        System.out.println("🔍 Probando conexión a la base de datos...");

        try (Connection con = Conexion.getConexion()) {
            if (con != null && !con.isClosed()) {
                System.out.println("✅ Conexión exitosa a la base de datos.");
            } else {
                System.out.println("❌ No se pudo establecer la conexión.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}