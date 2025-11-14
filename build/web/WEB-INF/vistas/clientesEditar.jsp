<%@ page contentType="text/html;charset=UTF-8" %>
<%
    modelo.Cliente cliente = (modelo.Cliente) request.getAttribute("cliente");
    boolean esJuridico = "JURIDICO".equalsIgnoreCase(cliente.getTipo());
%>

<div class="container mt-4">
    <h3>Editar Cliente</h3>
    <form action="ClienteController" method="post">
        <input type="hidden" name="accion" value="actualizar">
        <input type="hidden" name="id" value="<%= cliente.getId() %>">

        <!-- Tipo (solo lectura, no modificable) -->
        <div class="mb-3">
            <label>Tipo</label>
            <input type="text" class="form-control" value="<%= cliente.getTipo() %>" readonly>
            <input type="hidden" name="tipo" value="<%= cliente.getTipo() %>">
        </div>

        <!-- Nombre / Razón Social -->
        <div class="mb-3">
            <label><%= esJuridico ? "Razón Social" : "Nombre" %></label>
            <input type="text" name="nombre" value="<%= cliente.getNombre() %>" class="form-control" required>
        </div>

        <!-- Apellido / Representante -->
        <% if (!esJuridico) { %>
            <div class="mb-3">
                <label>Apellido</label>
                <input type="text" name="apellido" value="<%= cliente.getApellido() %>" class="form-control" required>
            </div>
        <% } else { %>
            <input type="hidden" name="apellido" value="">
        <% } %>

        <div class="mb-3">
            <label>Teléfono</label>
            <input type="text" name="telefono" value="<%= cliente.getTelefono() %>" class="form-control">
        </div>

        <div class="mb-3">
            <label>Dirección</label>
            <input type="text" name="direccion" value="<%= cliente.getDireccion() %>" class="form-control">
        </div>

        <div class="mb-3">
            <label>Email</label>
            <input type="email" name="email" value="<%= cliente.getEmail() %>" class="form-control">
        </div>

        <button type="submit" class="btn btn-primary">Guardar Cambios</button>
        <a href="ClienteController?accion=listar" class="btn btn-secondary">Cancelar</a>
    </form>
</div>