package controlador;

import dao.HabitacionDAO;
import modelo.Habitacion;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/HabitacionController")
public class HabitacionController extends HttpServlet {

    private final HabitacionDAO dao = new HabitacionDAO();

    // --- GET: mostrar formularios, cargar datos, etc. ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        String url = "/WEB-INF/vistas/layout.jsp?page=habitacionesConsultar.jsp";

        try {
            if ("editar".equals(accion)) {
                String numeroStr = request.getParameter("numero");
                Habitacion h = dao.buscarPorNumero(numeroStr != null ? Integer.parseInt(numeroStr) : -1);
                if (h != null) {
                    request.setAttribute("habitacion", h);
                    url = "/WEB-INF/vistas/layout.jsp?page=habitacionesEditar.jsp";
                } else {
                    request.setAttribute("mensaje", "Habitación no encontrada para edición.");
                    request.setAttribute("tipoMensaje", "alert-danger");
                }
            } else if ("listar".equals(accion) || "consultar".equals(accion)) {
                List<Habitacion> lista = dao.listar();

                // Filtrar por criterios si existen
                String numeroFiltro = request.getParameter("numero");
                String estadoFiltro = request.getParameter("estado");

                if (numeroFiltro != null && !numeroFiltro.isBlank()) {
                    int num = Integer.parseInt(numeroFiltro);
                    lista = lista.stream().filter(h -> h.getNumero() == num).collect(Collectors.toList());
                }

                if (estadoFiltro != null && !estadoFiltro.isBlank()) {
                    boolean disp = estadoFiltro.equalsIgnoreCase("disponible");
                    boolean ocupado = estadoFiltro.equalsIgnoreCase("ocupada");
                    boolean mant = estadoFiltro.equalsIgnoreCase("mantenimiento");

                    lista = lista.stream().filter(h -> {
                        if (disp) return h.isDisponible();
                        if (ocupado) return !h.isDisponible();
                        if (mant) return false; // si agregas estado de mantenimiento en BD, ajusta aquí
                        return true;
                    }).collect(Collectors.toList());
                }

                request.setAttribute("habitaciones", lista);
                request.setAttribute("mensaje", lista.isEmpty() ? "No se encontraron habitaciones." 
                                                                : "Habitaciones encontradas: " + lista.size());
                request.setAttribute("tipoMensaje", "alert-info");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al procesar la solicitud: " + e.getMessage());
            request.setAttribute("tipoMensaje", "alert-danger");
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    // --- POST: registrar, actualizar, buscar ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        String url = "/WEB-INF/vistas/layout.jsp?page=habitacionesRegistrar.jsp";

        try {
            switch (accion) {
                case "registrar":
                    Habitacion h = construirHabitacion(request);
                    boolean ok = dao.guardar(h);
                    request.setAttribute("mensaje", ok ? "Habitación registrada correctamente." 
                                                      : "❌ Error al registrar habitación.");
                    request.setAttribute("tipoMensaje", ok ? "alert-success" : "alert-danger");
                    break;

                case "actualizar":
                    Habitacion h2 = construirHabitacion(request);
                    boolean exito = dao.editar(h2); // deberías agregar método editar en DAO
                    request.setAttribute("mensaje", exito ? "Habitación actualizada correctamente."
                                                          : "❌ No se pudo actualizar.");
                    request.setAttribute("tipoMensaje", exito ? "alert-warning" : "alert-danger");
                    url = "/WEB-INF/vistas/layout.jsp?page=habitacionesConsultar.jsp";
                    break;

                case "buscar":
                    url = "/WEB-INF/vistas/layout.jsp?page=habitacionesConsultar.jsp";
                    doGet(request, response); // reutiliza lógica de GET para búsqueda
                    return;

                default:
                    request.setAttribute("mensaje", "Acción no reconocida.");
                    request.setAttribute("tipoMensaje", "alert-secondary");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Ocurrió un error: " + e.getMessage());
            request.setAttribute("tipoMensaje", "alert-danger");
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    private Habitacion construirHabitacion(HttpServletRequest request) {
        Habitacion h = new Habitacion();

        String numeroStr = request.getParameter("numero");
        String tipo = request.getParameter("tipo");
        String descripcion = request.getParameter("descripcion");
        String precioStr = request.getParameter("precioPorNoche");
        boolean disponible = request.getParameter("disponible") != null;

        if (numeroStr == null || numeroStr.isBlank()) throw new RuntimeException("Número de habitación obligatorio");
        if (tipo == null || tipo.isBlank()) throw new RuntimeException("Tipo de habitación obligatorio");
        if (precioStr == null || precioStr.isBlank()) throw new RuntimeException("Precio por noche obligatorio");

        h.setNumero(Integer.parseInt(numeroStr));
        h.setTipo(tipo);
        h.setDescripcion(descripcion != null ? descripcion.trim() : "");
        h.setPrecioPorNoche(Long.parseLong(precioStr.replace(".", "").trim()));
        h.setDisponible(disponible);

        return h;
    }
}