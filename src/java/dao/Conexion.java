package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL = "jdbc:mysql://turntable.proxy.rlwy.net:17439/railway"
                                    + "?allowPublicKeyRetrieval=true&useSSL=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "DsCuGpYGWVvRKqRNpBTDSeSCrxUZBhLU";

    public static Connection getConexion() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Error cargando el driver MySQL", e);
        }
    }
}