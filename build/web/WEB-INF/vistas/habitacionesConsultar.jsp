<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, modelo.Habitacion"%>

<div class="container">
    <h2 class="mb-4"><i class="bi bi-door-closed me-2"></i>Consultar Habitaciones</h2>

    <table class="table table-striped table-hover shadow-sm rounded bg-white">
        <thead class="table-dark">
            <tr>
                <th>Número</th>
                <th>Tipo</th>
                <th>Descripción</th>
                <th>Precio por Noche</th>
                <th>Disponible</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Habitacion> habitaciones = (List<Habitacion>) request.getAttribute("habitaciones");
                if(habitaciones != null && !habitaciones.isEmpty()) {
                    for(Habitacion h : habitaciones) {
            %>
            <tr>
                <td><%= h.getNumero() %></td>
                <td><%= h.getTipo() %></td>
                <td><%= h.getDescripcion() %></td>
                <td>$<%= h.getPrecioPorNoche() %></td>
                <td>
                    <span class="badge <%= h.isDisponible() ? "bg-success" : "bg-danger" %>">
                        <%= h.isDisponible() ? "Sí" : "No" %>
                    </span>
                </td>
                <td>
                    <form action="${pageContext.request.contextPath}/HabitacionController" method="post" class="d-inline">
                        <input type="hidden" name="accion" value="editar">
                        <input type="hidden" name="numero" value="<%= h.getNumero() %>">
                        <button class="btn btn-sm btn-warning"><i class="bi bi-pencil"></i> Editar</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/HabitacionController" method="post" class="d-inline">
                        <input type="hidden" name="accion" value="toggleDisponibilidad">
                        <input type="hidden" name="numero" value="<%= h.getNumero() %>">
                        <button class="btn btn-sm btn-secondary">
                            <i class="bi <%= h.isDisponible() ? "bi-x-circle" : "bi-check-circle" %>"></i> 
                            <%= h.isDisponible() ? "Ocupar" : "Liberar" %>
                        </button>
                    </form>
                </td>
            </tr>
            <%      }
                } else { %>
            <tr>
                <td colspan="6" class="text-center">No hay habitaciones registradas.</td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>