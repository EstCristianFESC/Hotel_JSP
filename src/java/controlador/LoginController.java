package controlador;

import dao.UsuarioDAO;
import modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginController")
public class LoginController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String user = request.getParameter("usuario");
		String pass = request.getParameter("password");

		Usuario u = new Usuario();
		u.setUsername(user);
		u.setPassword(pass);

		UsuarioDAO dao = new UsuarioDAO();
		Usuario usuarioValido = dao.validar(u);

		if (usuarioValido != null) {
			HttpSession sesion = request.getSession();
			sesion.setAttribute("usuarioLogueado", usuarioValido);

			request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp?page=inicio.jsp")
				   .forward(request, response);
		} else {
			request.setAttribute("error", "Usuario o contraseña incorrectos");
			request.getRequestDispatcher("/index.jsp").forward(request, response);
		}
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession sesion = request.getSession(false);
		if (sesion == null || sesion.getAttribute("usuarioLogueado") == null) {
			response.sendRedirect(request.getContextPath() + "/index.jsp");
			return;
		}

		String pagina = request.getParameter("page");
		if (pagina == null || pagina.trim().isEmpty()) pagina = "inicio.jsp";

		request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp?page=" + pagina)
			   .forward(request, response);
	}
}