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
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ReservaController")
public class ReservaController extends HttpServlet {

    private final ClienteDAO clienteDAO = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) accion = "form";

        try {

            switch (accion) {

                // ===========================================================
                // 🔍 BUSCAR CLIENTE POR CÉDULA (AJAX)
                // ===========================================================
                case "buscarPorCedula": {

                    String cedula = request.getParameter("cedula");
                    Cliente cli = null;

                    if (cedula != null && !cedula.isBlank()) {
                        cli = clienteDAO.buscarPorId(cedula.trim());
                    }

                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    try (PrintWriter out = response.getWriter()) {
                        if (cli != null) {
                            String json = String.format(
                                "{\"id\":\"%s\",\"nombre\":\"%s\",\"apellido\":\"%s\",\"tipo\":\"%s\"}",
                                cli.getId(), cli.getNombre(), cli.getApellido(), cli.getTipo()
                            );
                            out.print(json);
                        } else {
                            out.print("{}");
                        }
                    }
                    return;
                }

                // ===========================================================
                // 🔍 BUSCAR HABITACIONES DISPONIBLES
                // ===========================================================
                case "buscarDisponibles": {

                    String fechaE = request.getParameter("fechaEntrada");
                    String fechaS = request.getParameter("fechaSalida");

                    if (fechaE == null || fechaS == null || fechaE.isBlank() || fechaS.isBlank()) {
                        request.setAttribute("mensaje", "Debe seleccionar ambas fechas.");
                        request.setAttribute("tipoMensaje", "alert-warning");
                        request.setAttribute("page", "reservas/reservaRegistrar.jsp");
                        request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp").forward(request, response);
                        return;
                    }

                    LocalDate entrada = LocalDate.parse(fechaE);
                    LocalDate salida = LocalDate.parse(fechaS);

                    HabitacionDAO hdao = new HabitacionDAO();
                    List<Habitacion> disponibles = hdao.listarDisponibles(entrada, salida);

                    request.setAttribute("habitaciones", disponibles);
                    request.setAttribute("fechaEntrada", fechaE);
                    request.setAttribute("fechaSalida", fechaS);

                    request.setAttribute("page", "reservas/reservaRegistrar.jsp");
                    request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp").forward(request, response);
                    return;
                }

                // ===========================================================
                // 📥 CARGAR FORMULARIO DE DATOS DEL CLIENTE
                // ===========================================================
                case "datosCliente": {
                    request.setAttribute("idHabitacion", request.getParameter("idHabitacion"));
                    request.setAttribute("fechaEntrada", request.getParameter("fechaEntrada"));
                    request.setAttribute("fechaSalida", request.getParameter("fechaSalida"));
                    request.getRequestDispatcher("/WEB-INF/vistas/reservas/reservaDatosCliente.jsp")
                           .forward(request, response);
                    return;
                }

                // ===========================================================
                // 📄 CONSULTAR RESERVAS POR CLIENTE
                // ===========================================================
                case "misReservas": {

                    String cedula = request.getParameter("cedula");
                    String fechaE = request.getParameter("fechaEntrada");
                    String fechaS = request.getParameter("fechaSalida");

                    List<Reserva> reservas = new ArrayList<>();

                    if (cedula != null && !cedula.isBlank()) {

                        Cliente cliente = clienteDAO.buscarPorId(cedula.trim());

                        if (cliente != null) {
                            ReservaDAO rdao = new ReservaDAO();

                            if (fechaE != null && !fechaE.isBlank() && fechaS != null && !fechaS.isBlank()) {
                                reservas = rdao.buscarReservasPorClienteYFechas(
                                        Integer.parseInt(cliente.getId()),
                                        LocalDate.parse(fechaE),
                                        LocalDate.parse(fechaS)
                                );
                            } else {
                                reservas = rdao.listarPorCliente(Integer.parseInt(cliente.getId()));
                            }

                        } else {
                            request.setAttribute("mensaje", "Cliente no encontrado.");
                        }
                    }

                    request.setAttribute("reservas", reservas);
                    request.setAttribute("page", "reservas/reservaConsultar.jsp");
                    request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp").forward(request, response);
                    return;
                }

                // CANCELAR
                case "cancelar": {
                    int id = Integer.parseInt(request.getParameter("idReserva"));
                    new ReservaDAO().actualizarEstado(id, "CANCELADA");
                    response.sendRedirect("ReservaController?accion=misReservas&mensajeSuccess=Reserva cancelada exitosamente");
                    return;
                }

                // CHECK-IN
                case "checkin": {
                    int id = Integer.parseInt(request.getParameter("idReserva"));
                    new ReservaDAO().actualizarEstado(id, "CHECKIN");
                    response.sendRedirect("ReservaController?accion=misReservas&mensajeSuccess=Check-In realizado");
                    return;
                }

                // CHECK-OUT
                case "checkout": {
                    int id = Integer.parseInt(request.getParameter("idReserva"));
                    new ReservaDAO().actualizarEstado(id, "OUT");
                    response.sendRedirect("ReservaController?accion=misReservas&mensajeSuccess=Check-Out realizado");
                    return;
                }

                // FINALIZAR
                case "finalizar": {
                    int id = Integer.parseInt(request.getParameter("idReserva"));
                    new ReservaDAO().actualizarEstado(id, "FINALIZADA");
                    response.sendRedirect("ReservaController?accion=misReservas&mensajeSuccess=Reserva finalizada");
                    return;
                }

                default: {
                    request.setAttribute("page", "reservas/reservaRegistrar.jsp");
                    request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp").forward(request, response);
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensajeError", "Error: " + e.getMessage());
            request.setAttribute("page", "reservas/reservaRegistrar.jsp");
            request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp").forward(request, response);
        }
    }


    // ===========================================================
    // 📌 POST — REGISTRAR RESERVA
    // ===========================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) accion = "registrar";

        switch (accion) {
            // ============================
            // 🔴 CANCELAR RESERVA
            // ============================
            case "cancelar": {
                int id = Integer.parseInt(request.getParameter("idReserva"));
                new ReservaDAO().actualizarEstado(id, "CANCELADA");
                response.sendRedirect("ReservaController?accion=misReservas");
                return;
            }

            // ============================
            // 🟢 CHECK-IN
            // ============================
            case "checkin": {
                int id = Integer.parseInt(request.getParameter("idReserva"));
                new ReservaDAO().actualizarEstado(id, "CHECKIN");
                response.sendRedirect("ReservaController?accion=misReservas");
                return;
            }

            // ============================
            // 🟡 CHECK-OUT
            // ============================
            case "checkout": {
                int id = Integer.parseInt(request.getParameter("idReserva"));
                new ReservaDAO().actualizarEstado(id, "OUT");
                response.sendRedirect("ReservaController?accion=misReservas");
                return;
            }

            // ============================
            // ⚫ FINALIZAR
            // ============================
            case "finalizar": {
                int id = Integer.parseInt(request.getParameter("idReserva"));
                new ReservaDAO().actualizarEstado(id, "FINALIZADA");
                response.sendRedirect("ReservaController?accion=misReservas");
                return;
            }

            case "registrar": {

                try {
                    String cedula = request.getParameter("cedula");
                    int idHabitacion = Integer.parseInt(request.getParameter("idHabitacion"));
                    LocalDate fechaEntrada = LocalDate.parse(request.getParameter("fechaEntrada"));
                    LocalDate fechaSalida = LocalDate.parse(request.getParameter("fechaSalida"));

                    Cliente cliente = new ClienteDAO().buscarPorId(cedula);

                    if (cliente == null) {
                        request.setAttribute("mensajeError", "Cliente no encontrado.");
                        break;
                    }

                    Habitacion hab = new HabitacionDAO().obtenerPorId(idHabitacion);

                    if (hab == null) {
                        request.setAttribute("mensajeError", "Habitación no válida.");
                        break;
                    }

                    ReservaDAO rdao = new ReservaDAO();
                    boolean disponible = rdao.habitacionDisponible(hab.getNumero(), fechaEntrada, fechaSalida);

                    if (!disponible) {
                        request.setAttribute("mensajeError", "La habitación no está disponible en esas fechas.");
                        break;
                    }

                    Reserva r = new Reserva();
                    r.setClienteId(Integer.parseInt(cliente.getId()));
                    r.setHabitacionNumero(hab.getNumero());
                    r.setFechaEntrada(fechaEntrada);
                    r.setFechaSalida(fechaSalida);
                    r.setEstado("RESERVADA");
                    r.setTotal(rdao.calcularTotal(hab.getPrecioPorNoche(), fechaEntrada, fechaSalida));

                    boolean ok = rdao.insertar(r);

                    if (ok) {
                        request.setAttribute("mensajeSuccess", "Reserva registrada exitosamente.");
                    } else {
                        request.setAttribute("mensajeError", "No se pudo registrar la reserva.");
                    }

                } catch (Exception e) {
                    request.setAttribute("mensajeError", "Error: " + e.getMessage());
                }

                request.setAttribute("page", "reservas/reservaRegistrar.jsp");
                request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp").forward(request, response);

                break;
            }
        }
    }
}