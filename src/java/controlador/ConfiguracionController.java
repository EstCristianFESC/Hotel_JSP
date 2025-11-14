package controlador;

import dao.UsuarioDAO;
import modelo.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ConfiguracionController")
public class ConfiguracionController extends HttpServlet {

    private final UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        switch (accion) {
            case "verificar":
                String passwordActual = request.getParameter("passwordActual");
                Usuario validado = dao.validar(new Usuario() {{
                    setUsername(usuario.getUsername());
                    setPassword(passwordActual);
                }});

                if (validado != null) {
                    request.setAttribute("okVerificacion", true);
                } else {
                    request.setAttribute("error", "Contraseña incorrecta");
                }
                request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp?page=usuario/configuracion.jsp")
                       .forward(request, response);
                break;

            case "actualizar":
                String nuevoNombre = request.getParameter("nombre");
                String nuevaPassword = request.getParameter("nuevaPassword");

                if (nuevoNombre != null && !nuevoNombre.isBlank()) {
                    usuario.setNombre(nuevoNombre);
                }
                if (nuevaPassword != null && !nuevaPassword.isBlank()) {
                    usuario.setPassword(nuevaPassword);
                }

                if (dao.actualizar(usuario)) { // Método actualizar en DAO
                    sesion.setAttribute("usuarioLogueado", usuario);
                    request.setAttribute("mensaje", "Datos actualizados correctamente");
                    request.setAttribute("tipoMensaje", "alert-success");
                } else {
                    request.setAttribute("mensaje", "Error al actualizar datos");
                    request.setAttribute("tipoMensaje", "alert-danger");
                }
                request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp?page=usuario/configuracion.jsp")
                       .forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}