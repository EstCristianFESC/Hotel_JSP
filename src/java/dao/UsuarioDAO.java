package dao;

import java.sql.*;
import modelo.Usuario;

public class UsuarioDAO {

	public Usuario validar(Usuario u) {
		Usuario usuarioValido = null;
		String sql = "SELECT * FROM usuario WHERE username=? AND password=?";

		try (Connection con = Conexion.getConexion();
			 PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setString(1, u.getUsername());
			ps.setString(2, u.getPassword());

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					usuarioValido = new Usuario();
					usuarioValido.setUsername(rs.getString("username"));
					usuarioValido.setPassword(rs.getString("password"));
					usuarioValido.setNombre(rs.getString("nombre"));
					usuarioValido.setRol(rs.getString("rol"));
				}
			}
		} catch (SQLException e) {
			System.err.println("Error validando usuario: " + e.getMessage());
		}
		return usuarioValido;
	}
}