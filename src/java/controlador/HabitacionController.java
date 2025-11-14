package controlador;

import dao.HabitacionDAO;
import modelo.Habitacion;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/HabitacionController")
public class HabitacionController extends HttpServlet {

    private final HabitacionDAO dao = new HabitacionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("listar".equals(accion)) {
            List<Habitacion> lista = dao.listar();
            request.setAttribute("listaHabitaciones", lista);
        }

        request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp?page=habitacionesRegistrar.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        System.out.println("Acción recibida: " + accion);

        if ("registrar".equals(accion)) {
            try {
                Habitacion h = new Habitacion();

                String numeroStr = request.getParameter("numero");
                String tipo = request.getParameter("tipo");
                String descripcion = request.getParameter("descripcion");
                String precioStr = request.getParameter("precioPorNoche");
                boolean disponible = request.getParameter("disponible") != null;

                System.out.println("Datos recibidos -> número: " + numeroStr + ", tipo: " + tipo + ", precio: " + precioStr);

                // Validaciones básicas
                if (numeroStr == null || numeroStr.isEmpty() || tipo == null || tipo.isEmpty() || precioStr == null || precioStr.isEmpty()) {
                    request.setAttribute("mensaje", "Todos los campos obligatorios deben estar completos.");
                } else {
                    // Limpiar y parsear precio
                    precioStr = precioStr.replace(".", "").trim();

                    h.setNumero(Integer.parseInt(numeroStr));
                    h.setTipo(tipo);
                    h.setDescripcion(descripcion != null ? descripcion.trim() : "");
                    h.setPrecioPorNoche(Long.parseLong(precioStr));
                    h.setDisponible(disponible);

                    boolean ok = dao.guardar(h);
                    request.setAttribute("mensaje", ok ? "Habitación registrada correctamente." : "❌ Error al registrar habitación.");
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("mensaje", "Error interno: " + e.getMessage());
            }
        } else {
            request.setAttribute("mensaje", "Acción no reconocida: " + accion);
        }

        request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp?page=habitacionesRegistrar.jsp")
               .forward(request, response);
    }
}