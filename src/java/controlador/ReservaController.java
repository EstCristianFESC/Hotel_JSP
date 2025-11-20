package controlador;

import dao.ClienteDAO;
import dao.HabitacionDAO;
import dao.ReservaDAO;
import modelo.Reserva;
import modelo.Habitacion;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/ReservaController")
public class ReservaController extends HttpServlet {

    private ClienteDAO clienteDAO = new ClienteDAO();
    private HabitacionDAO habitacionDAO = new HabitacionDAO();
    private ReservaDAO reservaDAO = new ReservaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String accion = req.getParameter("accion");

        if (accion == null)
            accion = "crear";

        switch (accion) {
            case "crear":
                req.setAttribute("clientes", clienteDAO.listar());
                req.setAttribute("habitaciones", habitacionDAO.listarDisponibles());
                req.getRequestDispatcher("reservas/crear.jsp").forward(req, resp);
                break;

            case "listar":
                req.setAttribute("reservas", reservaDAO.listar());
                req.getRequestDispatcher("reservas/listar.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect("ReservaController?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String accion = req.getParameter("accion");

        if ("guardar".equals(accion)) {

            int clienteId = Integer.parseInt(req.getParameter("clienteId"));
            int habitacion = Integer.parseInt(req.getParameter("habitacion"));
            LocalDate entrada = LocalDate.parse(req.getParameter("entrada"));
            LocalDate salida = LocalDate.parse(req.getParameter("salida"));

            // Validar disponibilidad
            if (!reservaDAO.habitacionDisponible(habitacion, entrada, salida)) {
                req.setAttribute("error", "La habitación NO está disponible en esas fechas.");
                req.setAttribute("clientes", clienteDAO.listar());
                req.setAttribute("habitaciones", habitacionDAO.listarDisponibles());
                req.getRequestDispatcher("reservas/crear.jsp").forward(req, resp);
                return;
            }

            // Obtener precio de la habitación
            Habitacion h = habitacionDAO.buscarPorNumero(habitacion);
            double total = reservaDAO.calcularTotal(h.getPrecioPorNoche(), entrada, salida);

            // Crear reserva
            Reserva r = new Reserva();
            r.setClienteId(clienteId);
            r.setHabitacionNumero(habitacion);
            r.setFechaEntrada(entrada);
            r.setFechaSalida(salida);
            r.setEstado("RESERVADA");
            r.setTotal(total);

            reservaDAO.insertar(r);

            resp.sendRedirect("ReservaController?accion=listar");
        }
    }
}