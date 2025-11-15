<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="modelo.Productos"%>

<%
    Productos producto = (Productos) request.getAttribute("producto");
    if (producto == null) {
        out.println("<div class='alert alert-danger'>Producto no encontrado.</div>");
        return;
    }
%>

<div class="container py-4">
    <h2 class="fw-semibold text-dark mb-4"><i class="bi bi-pencil-square me-2"></i>Editar Producto</h2>

    <div class="card shadow-sm p-4">
        <form action="${pageContext.request.contextPath}/ProductosController" method="post">

            <input type="hidden" name="id" value="<%= producto.getId() %>">

            <div class="mb-3">
                <label class="form-label fw-semibold">Descripción:</label>
                <input type="text" name="descripcion" class="form-control" 
                       value="<%= producto.getDescripcion() %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">Valor Unitario:</label>
                <input type="number" name="valor" min="0" class="form-control"
                       value="<%= producto.getValorUnitario() %>" required>
            </div>

            <div class="d-flex gap-2">
                <button type="submit" name="accion" value="actualizarProducto"
                        class="btn btn-success px-4">
                    <i class="bi bi-save me-1"></i> Guardar Cambios
                </button>
                <a href="${pageContext.request.contextPath}/ProductosController?accion=listar"
                   class="btn btn-secondary px-4">Cancelar</a>
            </div>
        </form>
    </div>
</div>