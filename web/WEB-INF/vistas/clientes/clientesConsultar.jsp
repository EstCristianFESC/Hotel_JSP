<%@page import="dao.ClienteDAO"%>
<%@page import="modelo.Cliente"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="container-fluid py-4">
    <h2 class="fw-semibold text-dark mb-4">
        <i class="bi bi-person-lines-fill me-2"></i>Consultar Clientes
    </h2>

    <!-- Mensaje -->
    <div id="mensajeCliente"
         class="toast align-items-center text-bg-<%= (request.getAttribute("tipoMensaje") != null) ? request.getAttribute("tipoMensaje").toString().replace("alert-", "") : "info" %> border-0"
         role="alert" aria-live="assertive" aria-atomic="true"
         style="position: fixed; top: 1rem; right: 1rem; min-width: 260px; z-index: 9999;">
        <div class="d-flex">
            <div class="toast-body" style="font-size: 0.85rem;">
                <%= (request.getAttribute("mensaje") != null) ? request.getAttribute("mensaje") : "Ingrese criterios de búsqueda." %>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto"
                    data-bs-dismiss="toast" aria-label="Cerrar"></button>
        </div>
    </div>

    <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body px-4 py-4">

            <form id="formBuscarCliente" action="${pageContext.request.contextPath}/ClienteController" method="post" class="row g-3 mb-4">
                <div class="col-md-4">
                    <label for="buscarId" class="form-label fw-semibold">Cédula o NIT:</label>
                    <input type="text" class="form-control" id="buscarId" name="id" placeholder="ID o NIT">
                </div>
                <div class="col-md-4">
                    <label for="buscarNombre" class="form-label fw-semibold">Nombre:</label>
                    <input type="text" class="form-control" id="buscarNombre" name="nombre" placeholder="Nombre del cliente">
                </div>
                <div class="col-12 d-flex align-items-end gap-2">
                    <button type="submit" name="accion" value="buscar" class="btn btn-sm btn-info text-white px-3 py-2">
                        <i class="bi bi-search me-1"></i>Buscar
                    </button>
                    <button type="button" onclick="limpiarBusqueda()" class="btn btn-sm btn-secondary px-3 py-2">
                        <i class="bi bi-eraser-fill me-1"></i>Limpiar
                    </button>
                </div>
            </form>

            <hr>

            <!-- Tabla de resultados -->
            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID / NIT</th>
                            <th>Tipo</th>
                            <th>Nombre / Razón Social</th>
                            <th>Apellido</th>
                            <th>Teléfono</th>
                            <th>Dirección</th>
                            <th>Correo</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Cliente> lista = (List<Cliente>) request.getAttribute("listaClientes");
                            if (lista == null) lista = new ArrayList<>();

                            if (lista.isEmpty()) {
                        %>
                            <tr><td colspan="8" class="text-center">No hay clientes para mostrar.</td></tr>
                        <%
                            } else {
                                for (Cliente cli : lista) {
                        %>
                            <tr>
                                <td><%= cli.getId() %></td>
                                <td><%= cli.getTipo() %></td>
                                <td><%= cli.getNombre() %></td>
                                <td><%= cli.getTipo().equalsIgnoreCase("NATURAL") ? cli.getApellido() : "-" %></td>
                                <td><%= cli.getTelefono() %></td>
                                <td><%= cli.getDireccion() %></td>
                                <td><%= cli.getEmail() %></td>
                                <td class="text-center">
                                    <a href="ClienteController?accion=editar&id=<%= cli.getId() %>" 
                                       class="btn btn-sm btn-warning">
                                        <i class="bi bi-pencil-square"></i></a>
                                </td>
                            </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>

<script>
    function limpiarBusqueda(){
        document.getElementById("buscarId").value = "";

        const toastEl = document.getElementById("mensajeCliente");
        if (toastEl) {
            const bsToast = bootstrap.Toast.getInstance(toastEl);
            if (bsToast) bsToast.hide();
        }

        const tbody = document.querySelector('table tbody');
        tbody.innerHTML = '<tr><td colspan="7" class="text-center">No hay clientes para mostrar.</td></tr>';
    }

    document.addEventListener("DOMContentLoaded", function () {
        var toastEl = document.getElementById('mensajeCliente');

        <% if(request.getAttribute("mensaje") != null) { %>
            var bsToast = new bootstrap.Toast(toastEl, { delay: 3000, autohide: true });
            bsToast.show();
        <% } %>
    });
</script>