package controlador;

import dao.HabitacionDAO;
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

            // Éxito: cargar de una vez métricas de inicio
            cargarMetricasInicio(request);

            request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp?page=inicio/inicio.jsp")
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

        // Si NO está logueado → pa' fuera
        if (sesion == null || sesion.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Obtener página solicitada
        String pagina = request.getParameter("page");

        // Si no mandan nada → cargar inicio
        if (pagina == null || pagina.trim().isEmpty()) {
            pagina = "inicio/inicio.jsp";
        }

        // Validación mínima de seguridad (evita ../../ etc.)
        if (!pagina.matches("[a-zA-Z0-9_/]+\\.jsp")) {
            pagina = "inicio/inicio.jsp";
        }

        // Si está entrando al dashboard → cargar métricas
        if (pagina.equals("inicio/inicio.jsp")) {
            cargarMetricasInicio(request);
        }

        // Render general
        request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp?page=" + pagina)
               .forward(request, response);
    }

    private void cargarMetricasInicio(HttpServletRequest request) {

        HabitacionDAO hdao = new HabitacionDAO();

        var habitaciones = hdao.listar();

        int total = habitaciones.size();
        int disponibles = (int) habitaciones.stream()
                                            .filter(h -> h.isDisponible())
                                            .count();
        int ocupadas = total - disponibles;

        int ocupacion = total > 0 ? (ocupadas * 100 / total) : 0;

        request.setAttribute("totalHabitaciones", total);
        request.setAttribute("habitacionesDisponibles", disponibles);
        request.setAttribute("ocupacionActual", ocupacion);
    }
}