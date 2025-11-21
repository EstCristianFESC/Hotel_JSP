package controlador;

import dao.ClienteDAO;
import dao.HabitacionDAO;
import dao.ReservaDAO;

import modelo.Cliente;
import modelo.Habitacion;
import modelo.Reserva;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/ReservaController")
public class ReservaController extends HttpServlet {

    // === INSTANCIAS DAO (FALTABA ESTA) ===
    private final ClienteDAO clienteDAO = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) accion = "form";

        switch (accion) {

            case "buscarPorCedula": {

                ClienteDAO clienteDAO = new ClienteDAO(); // <- LO QUE TE FALTABA

                String cedula = request.getParameter("cedula");
                Cliente cli = null;

                if (cedula != null && !cedula.isBlank()) {
                    cli = clienteDAO.buscarPorId(cedula.trim());    
                }

                request.setAttribute("clienteReserva", cli);

                if (cli == null) {
                    request.setAttribute("mensaje", "Cliente no encontrado.");
                    request.setAttribute("tipoMensaje", "alert-danger");
                }

                request.setAttribute("page", "reservas/reservaRegistrar.jsp");
                request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp")
                       .forward(request, response);

                return;
                
            } case "buscarHabitacion": {

                HabitacionDAO hdao = new HabitacionDAO();
                List<Habitacion> disponibles = hdao.listarDisponibles();

                request.setAttribute("habitacionesDisponibles", disponibles);

                request.getRequestDispatcher(
                        "/WEB-INF/vistas/layout.jsp?page=reservas/reservaRegistrar.jsp"
                ).forward(request, response);
                break;
            }

            default: {

                request.getRequestDispatcher(
                        "/WEB-INF/vistas/layout.jsp?page=reservas/reservaRegistrar.jsp"
                ).forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) accion = "registrar";

        switch (accion) {

            case "registrar": {

                try {
                    String cedula = request.getParameter("cedula");
                    int idHabitacion = Integer.parseInt(request.getParameter("idHabitacion"));
                    LocalDate fechaEntrada = LocalDate.parse(request.getParameter("fechaEntrada"));
                    LocalDate fechaSalida = LocalDate.parse(request.getParameter("fechaSalida"));

                    // Buscar cliente
                    ClienteDAO cdao = new ClienteDAO();
                    Cliente cliente = cdao.buscarPorId(cedula);

                    if (cliente == null) {
                        request.setAttribute("mensajeError", "Cliente no encontrado.");
                        break;
                    }

                    // Traer habitación
                    HabitacionDAO hdao = new HabitacionDAO();
                    Habitacion hab = hdao.obtenerPorId(idHabitacion);

                    if (hab == null) {
                        request.setAttribute("mensajeError", "Habitación no válida.");
                        break;
                    }

                    // Validar disponibilidad
                    ReservaDAO rdao = new ReservaDAO();

                    boolean disponible = rdao.habitacionDisponible(
                            hab.getNumero(),
                            fechaEntrada,
                            fechaSalida
                    );

                    if (!disponible) {
                        request.setAttribute("mensajeError", "La habitación no está disponible en esas fechas.");
                        break;
                    }

                    // Crear reserva
                    Reserva r = new Reserva();
                    r.setClienteId(Integer.parseInt(cliente.getId()));
                    r.setHabitacionNumero(hab.getNumero());
                    r.setFechaEntrada(fechaEntrada);
                    r.setFechaSalida(fechaSalida);
                    r.setEstado("RESERVADA");

                    // Calcular total
                    double total = rdao.calcularTotal(hab.getPrecioPorNoche(), fechaEntrada, fechaSalida);
                    r.setTotal(total);

                    boolean ok = rdao.insertar(r);

                    if (ok) {
                        request.setAttribute("mensajeSuccess", "Reserva registrada exitosamente.");
                    } else {
                        request.setAttribute("mensajeError", "No se pudo registrar la reserva.");
                    }

                } catch (Exception e) {
                    request.setAttribute("mensajeError", "Error en el registro: " + e.getMessage());
                }

                request.getRequestDispatcher(
                        "/WEB-INF/vistas/layout.jsp?page=reservas/reservaRegistrar.jsp"
                ).forward(request, response);

                break;
            }
        }
    }
}