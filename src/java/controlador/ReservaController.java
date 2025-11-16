package controlador;

import dao.HabitacionDAO;
import dao.ReservaDAO;
import modelo.Reserva;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/ReservaController")
public class ReservaController extends HttpServlet {

    private final ReservaDAO dao = new ReservaDAO();
    private final HabitacionDAO habitacionDAO = new HabitacionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        dao.actualizarEstados(); // actualiza todos los estados antes de mostrar

        String accion = request.getParameter("accion");
        String url = "/WEB-INF/vistas/layout.jsp?page=reserva/reservaConsultar.jsp";

        if ("listar".equals(accion)) {
            List<Reserva> lista = dao.listar();
            request.setAttribute("reservas", lista);
        } else if ("registrar".equals(accion)) {
            request.setAttribute("habitaciones", habitacionDAO.listar());
            url = "/WEB-INF/vistas/layout.jsp?page=reserva/reservaRegistrar.jsp";
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if ("guardar".equals(accion)) {

            int habNum = Integer.parseInt(request.getParameter("habitacionNumero"));
            LocalDate entrada = LocalDate.parse(request.getParameter("fechaEntrada"));
            LocalDate salida = LocalDate.parse(request.getParameter("fechaSalida"));

            if (!dao.estaDisponible(habNum, entrada, salida)) {
                request.setAttribute("mensaje", "La habitación no está disponible en ese rango de fechas.");
                request.setAttribute("tipoMensaje", "alert-danger");
            } else {
                Reserva r = new Reserva();
                r.setClienteId(request.getParameter("clienteId"));
                r.setHabitacionNumero(habNum);
                r.setFechaEntrada(entrada);
                r.setFechaSalida(salida);
                r.setEstado("RESERVADA");

                // Calcular total
                double precio = habitacionDAO.buscarPorNumero(habNum).getPrecioPorNoche();
                long dias = salida.toEpochDay() - entrada.toEpochDay();
                r.setTotal(precio * dias);

                if (dao.guardar(r)) {
                    request.setAttribute("mensaje", "Reserva creada correctamente.");
                    request.setAttribute("tipoMensaje", "alert-success");
                } else {
                    request.setAttribute("mensaje", "Error al crear la reserva.");
                    request.setAttribute("tipoMensaje", "alert-danger");
                }
            }

            request.setAttribute("habitaciones", habitacionDAO.listar());
            request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp?page=reserva/reservaRegistrar.jsp")
                   .forward(request, response);
        }
    }
}