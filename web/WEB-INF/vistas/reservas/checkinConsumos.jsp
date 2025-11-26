<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="modelo.Consumo"%>
<%@page import="modelo.Productos"%>

<%
    int idCheckin = (int) request.getAttribute("idCheckin");
    int idReserva = (int) request.getAttribute("idReserva");
    List<Consumo> consumos = (List<Consumo>) request.getAttribute("consumos");
    List<Productos> productos = (List<Productos>) request.getAttribute("productos");
%>

<div class="container py-4">
    <h3 class="mb-4">
        <i class="bi bi-basket-fill me-2"></i> Consumos del Check-In #<%= idCheckin %>
    </h3>

    <form action="<%=request.getContextPath()%>/CheckinController" method="post" class="card p-4 shadow-sm mb-4">
        <input type="hidden" name="accion" value="agregarConsumo">
        <input type="hidden" name="idCheckin" value="<%= idCheckin %>">
        <input type="hidden" name="idReserva" value="<%= idReserva %>">

        <div class="mb-3">
            <label class="form-label fw-bold">Producto</label>
            <select class="form-select" name="idProducto" id="idProducto" required>
                <% for (int i = 0; i < productos.size(); i++) { 
                       Productos p = productos.get(i); %>
                    <option value="<%= p.getId() %>" data-price="<%= p.getValorUnitario() %>" 
                            <%= i == 0 ? "selected" : "" %>>
                        <%= p.getDescripcion() %> — $<%= p.getValorUnitario() %>
                    </option>
                <% } %>
            </select>
        </div>

        <input type="hidden" name="valorUnitario" id="valorUnitario" 
               value="<%= productos.isEmpty() ? 0 : productos.get(0).getValorUnitario() %>">

        <div class="mb-3">
            <label class="form-label fw-bold">Cantidad</label>
            <input type="number" name="cantidad" class="form-control" min="1" value="1" required>
        </div>

        <button class="btn btn-success">
            <i class="bi bi-plus-circle"></i> Agregar
        </button>
    </form>

    <h5 class="fw-bold">Historial de consumos</h5>

    <table class="table table-hover table-bordered">
        <thead class="table-dark">
        <tr>
            <th>Producto</th>
            <th>Cantidad</th>
            <th>Valor</th>
            <th>Subtotal</th>
            <th>Fecha</th>
        </tr>
        </thead>

        <tbody>
        <% if (consumos == null || consumos.isEmpty()) { %>
            <tr>
                <td colspan="5" class="text-center text-muted">Sin consumos.</td>
            </tr>
        <% } else { 
           for (Consumo c : consumos) { %>
            <tr>
                <td><%= c.getNombreProducto() %></td>
                <td><%= c.getCantidad() %></td>
                <td>$ <%= c.getValorUnitario() %></td>
                <td>$ <%= c.getSubtotal() %></td>
                <td><%= c.getFecha() != null ? c.getFecha() : "" %></td>
            </tr>
        <% }} %>
        </tbody>
    </table>
</div>

<script>
const selectProducto = document.querySelector("#idProducto");
const valorUnitarioInput = document.querySelector("#valorUnitario");

selectProducto.addEventListener("change", e => {
    let price = e.target.selectedOptions[0].dataset.price;
    valorUnitarioInput.value = price;
});
</script>