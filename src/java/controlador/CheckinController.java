package controlador;

import dao.CheckinDAO;
import dao.HabitacionDAO;
import dao.ReservaDAO;
import dao.ProductosDAO;
import modelo.Checkin;
import modelo.Reserva;
import modelo.Consumo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/CheckinController")
public class CheckinController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        ReservaDAO rdao = new ReservaDAO();
        CheckinDAO cdao = new CheckinDAO();

        if ("formCheckin".equals(accion)) {
            int idReserva = Integer.parseInt(request.getParameter("idReserva"));
            Reserva r = rdao.listarPorId(idReserva);

            request.setAttribute("reserva", r);
            request.setAttribute("page", "reservas/reservaCheckin.jsp");
            request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp").forward(request, response);
            return;
        }

        if ("consumos".equals(accion) || "verConsumos".equals(accion)) {
            int idReserva = Integer.parseInt(request.getParameter("idReserva"));
            int idCheckin = rdao.obtenerIdCheckinPorReserva(idReserva);

            request.setAttribute("productos", new ProductosDAO().listarActivos());
            request.setAttribute("consumos", cdao.listarConsumos(idCheckin));
            request.setAttribute("idCheckin", idCheckin);
            request.setAttribute("idReserva", idReserva);
            request.setAttribute("page", "reservas/checkinConsumos.jsp");
            request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp").forward(request, response);
            return;
        }

        if ("checkoutFactura".equals(accion)) {
            int idReserva = Integer.parseInt(request.getParameter("idReserva"));
            Reserva reserva = rdao.listarPorId(idReserva);
            int idCheckin = rdao.obtenerIdCheckinPorReserva(idReserva);
            Checkin chk = cdao.obtenerCheckin(idCheckin);
            List<Consumo> consumos = cdao.listarConsumos(idCheckin);
            int dias = rdao.calcularDiasEstadia(reserva.getFechaEntrada(), reserva.getFechaSalida());

            request.setAttribute("dias", dias);
            request.setAttribute("reserva", reserva);
            request.setAttribute("checkin", chk);
            request.setAttribute("consumos", consumos);
            request.setAttribute("page", "reservas/checkoutFactura.jsp");
            request.getRequestDispatcher("/WEB-INF/vistas/layout.jsp").forward(request, response);
            return;
        }

        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        CheckinDAO cdao = new CheckinDAO();
        ReservaDAO rdao = new ReservaDAO();

        if ("registrarCheckin".equals(accion)) {
            int idReserva = Integer.parseInt(request.getParameter("idReserva"));
            Reserva reserva = rdao.listarPorId(idReserva);

            Checkin c = new Checkin();
            c.setIdReserva(idReserva);
            c.setObservaciones(request.getParameter("observaciones"));
            c.setTotalHabitacion(Math.round(reserva != null ? reserva.getTotal() : 0));

            if (cdao.registrarCheckin(c)) {
                int numeroHabitacion = rdao.obtenerIdHabitacionPorReserva(idReserva);
                cdao.actualizarEstadoHabitacion(numeroHabitacion, true);
                cdao.actualizarEstadoReserva(idReserva);
                request.getSession().setAttribute("mensaje", "Check-in realizado.");
            } else {
                request.getSession().setAttribute("mensaje", "Error en check-in.");
            }

            response.sendRedirect(request.getContextPath() + "/ReservaController?accion=misReservas");
            return;
        }

        if ("agregarConsumo".equals(accion)) {
            try {
                int idCheckin = Integer.parseInt(request.getParameter("idCheckin"));
                int idProducto = Integer.parseInt(request.getParameter("idProducto"));
                int cantidad = Integer.parseInt(request.getParameter("cantidad"));
                long valorUnitario = Long.parseLong(request.getParameter("valorUnitario"));
                int idReserva = Integer.parseInt(request.getParameter("idReserva"));

                if (cdao.agregarConsumo(idCheckin, idProducto, cantidad, valorUnitario)) {
                    cdao.recalcularTotalConsumos(idCheckin);
                    cdao.actualizarTotalFinal(idCheckin);
                    cdao.actualizarTotalReserva(idReserva);

                    request.getSession().setAttribute("mensaje", "Consumo agregado correctamente.");
                } else {
                    request.getSession().setAttribute("mensaje", "Error agregando consumo.");
                }

                response.sendRedirect(request.getContextPath() +
                        "/CheckinController?accion=consumos&idReserva=" + idReserva);

            } catch (NumberFormatException e) {
                request.getSession().setAttribute("mensaje", "Datos inválidos.");
                response.sendRedirect(request.getContextPath() +
                        "/CheckinController?accion=consumos&idReserva=" + request.getParameter("idReserva"));
            }
            return;
        }

        if ("checkout".equals(accion)) {
            int idReserva = Integer.parseInt(request.getParameter("idReserva"));
            response.sendRedirect(request.getContextPath() +
                    "/CheckinController?accion=checkoutFactura&idReserva=" + idReserva);
            return;
        }

        if ("finalizarReserva".equals(accion)) {
            int idReserva = Integer.parseInt(request.getParameter("idReserva"));

            // Cambiar estado de la reserva
            rdao.actualizarEstado(idReserva, "FINALIZADA");

            // Liberar la habitación
            int numeroHabitacion = rdao.obtenerIdHabitacionPorReserva(idReserva);
            HabitacionDAO hdao = new HabitacionDAO();
            hdao.actualizarDisponibilidad(numeroHabitacion, true); // true = disponible

            request.getSession().setAttribute("mensaje", "Reserva finalizada y habitación liberada.");
            response.sendRedirect(request.getContextPath() + "/ReservaController?accion=misReservas");
            return;
        }

        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }
}