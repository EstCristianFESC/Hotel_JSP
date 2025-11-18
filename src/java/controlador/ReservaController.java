package controlador;

import dao.ClienteDAO;
import dao.HabitacionDAO;
import modelo.Habitacion;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ReservaController")
public class ReservaController extends HttpServlet {

    private final HabitacionDAO habitacionDAO = new HabitacionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        
        if ("cargarFormulario".equals(accion)) {

            List<Habitacion> disponibles = habitacionDAO.listarDisponibles();
            request.setAttribute("habitacionesDisponibles", disponibles);

            request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp?page=reservas/reservaRegistrar.jsp")
                    .forward(request, response);
            return;
        }

        // fallback
        request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp?page=reservas/reservaRegistrar.jsp")
                .forward(request, response);
    }
}