package controlador;

import dao.ClienteDAO;
import dao.HabitacionDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import modelo.Cliente;

@WebServlet(name = "ClienteController", urlPatterns = { "/ClienteController" })
public class ClienteController extends HttpServlet {

    private final ClienteDAO clienteDAO = new ClienteDAO();

    // --- GET: mostrar formularios, cargar datos, etc. ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        String url = "/WEB-INF/vistas/layout.jsp?page=clientes/clientesConsultar.jsp";

        try {
            if ("editar".equals(accion)) {
                String id = request.getParameter("id");
                Cliente cli = clienteDAO.buscarPorId(id);
                if (cli != null) {
                    request.setAttribute("cliente", cli);
                    url = "/WEB-INF/vistas/layout.jsp?page=clientes/clientesEditar.jsp";
                } else {
                    request.setAttribute("mensaje", "Cliente no encontrado para edición.");
                    request.setAttribute("tipoMensaje", "alert-danger");
                }
            } else if ("listar".equals(accion)) {
                List<Cliente> lista = clienteDAO.buscarPorCriterio("");
                request.setAttribute("listaClientes", lista);

            } else if ("buscarPorCedula".equals(accion)) {
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

                // ENVIAR DIRECTO A LA VISTA DE RESERVAS (NO LOGIN!)
                String urlDestino = "/WEB-INF/vistas/layout.jsp?page=reservas/reservaRegistrar.jsp";
                request.getRequestDispatcher(urlDestino).forward(request, response);
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al procesar la solicitud: " + e.getMessage());
            request.setAttribute("tipoMensaje", "alert-danger");
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    // --- POST: guardar, actualizar, buscar ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        String url = "/WEB-INF/vistas/layout.jsp?page=clientes/clientesRegistrar.jsp";

        try {
            switch (accion) {
                case "guardar":
                    guardarCliente(request);
                    request.setAttribute("mensaje", "Cliente guardado correctamente.");
                    request.setAttribute("tipoMensaje", "alert-success");
                    break;

                case "actualizar":
                    actualizarCliente(request);
                    request.setAttribute("mensaje", "Datos del cliente actualizados con éxito.");
                    request.setAttribute("tipoMensaje", "alert-warning");
                    url = "/WEB-INF/vistas/layout.jsp?page=clientes/clientesConsultar.jsp";
                    break;

                case "buscar":
                    String idBuscar = request.getParameter("id");
                    String nombreBuscar = request.getParameter("nombre");

                    // Si el usuario no pone nada, pasamos cadena vacía
                    String criterio = (idBuscar != null && !idBuscar.isBlank()) ? idBuscar.trim()
                            : (nombreBuscar != null && !nombreBuscar.isBlank()) ? nombreBuscar.trim() : "";

                    List<Cliente> lista = clienteDAO.buscarPorCriterio(criterio);

                    if (!lista.isEmpty()) {
                        request.setAttribute("listaClientes", lista);
                        request.setAttribute("mensaje", "Clientes encontrados: " + lista.size());
                        request.setAttribute("tipoMensaje", "alert-info");
                    } else {
                        request.setAttribute("mensaje", "No se encontraron clientes con ese criterio.");
                        request.setAttribute("tipoMensaje", "alert-danger");
                    }
                    url = "/WEB-INF/vistas/layout.jsp?page=clientes/clientesConsultar.jsp";
                    break;

                default:
                    request.setAttribute("mensaje", "Acción no reconocida.");
                    request.setAttribute("tipoMensaje", "alert-secondary");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Ocurrió un error: " + e.getMessage());
            request.setAttribute("tipoMensaje", "alert-danger");
            url = "buscar".equals(accion)
                    ? "/WEB-INF/vistas/layout.jsp?page=clientes/clientesConsultar.jsp"
                    : "/WEB-INF/vistas/layout.jsp?page=clientes/clientesRegistrar.jsp";
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    // --- MÉTODOS PRIVADOS --- //

    private void guardarCliente(HttpServletRequest request) {
        Cliente c = construirCliente(request);
        if (!clienteDAO.guardar(c)) {
            throw new RuntimeException(
                    "No se pudo guardar el cliente. Posiblemente ya existe o los datos son inválidos.");
        }
    }

    private void actualizarCliente(HttpServletRequest request) {
        Cliente c = construirCliente(request);
        if (!clienteDAO.editar(c)) {
            throw new RuntimeException("No se pudo actualizar el cliente. Verifique el identificador.");
        }
    }

    private Cliente construirCliente(HttpServletRequest request) {
        Cliente c = new Cliente();
        String tipo = request.getParameter("tipo");
        if (tipo == null || tipo.isBlank())
            throw new RuntimeException("Debe seleccionar un tipo de cliente.");
        c.setTipo(tipo.toUpperCase());

        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty())
            throw new RuntimeException("Debe especificar un ID/NIT válido.");
        c.setId(id.trim());

        c.setNombre(validarCampo(request.getParameter("nombre")));
        c.setApellido(validarCampo(request.getParameter("apellido")));
        c.setTelefono(validarCampo(request.getParameter("telefono")));
        c.setDireccion(validarCampo(request.getParameter("direccion")));
        c.setEmail(validarCampo(request.getParameter("email")));

        return c;
    }

    private String validarCampo(String valor) {
        return (valor != null && !valor.trim().isEmpty()) ? valor.trim() : null;
    }
}