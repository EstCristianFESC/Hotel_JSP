<%@page contentType="text/html" pageEncoding="UTF-8" %>

<%@ page import="modelo.Usuario" %>
<% Usuario usuario=(Usuario) session.getAttribute("usuarioLogueado"); if (usuario==null) {
response.sendRedirect("../index.jsp"); return; } %>

<% if (request.getAttribute("mensaje") !=null) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
<%= request.getAttribute("mensaje") %>

<button type="button" class="btn-close"
        data-bs-dismiss="alert"></button>
</div>

<% } else if (request.getAttribute("error") !=null) { %>
<div class="alert alert-danger alert-dismissible fade show" role="alert">
<%= request.getAttribute("error") %>
        <button type="button" class="btn-close"
                data-bs-dismiss="alert"></button>
</div>
<% } %>

<style>
    #togglePassConfig {
        position: absolute;
        top: 66%;
        right: 15px;
        transform: translateY(-50%);
        cursor: pointer;
        color: rgba(33, 37, 41, 0.55);
        font-size: 1.1rem;
        transition: color 0.2s ease;
    }

    #togglePassConfig:hover {
        color: #0d6efd;
    }
</style>

<div class="container-fluid py-3">
    <h2 class="fw-semibold text-dark mb-4">
            <i class="bi bi-gear me-2"></i>Configuración de Usuario
    </h2>

    <div class="card shadow-sm rounded-4 border-0">
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/ActualizarUsuario"
                method="post">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="usuario"
                            class="form-label fw-semibold">Usuario</label>
                        <input type="text"
                            class="form-control"
                            id="usuario"
                            name="usuario"
                            value="<%= usuario.getUsuario() %>">
                        </div>

                    <div class="col-md-6 position-relative">
                        <label for="contrasena"
                            class="form-label fw-semibold">Contraseña</label>
                        <input type="password"
                            class="form-control pe-5"
                            id="contrasena"
                            name="contrasena"
                            value="<%= usuario.getContrasena() %>">
                        <i class="bi bi-eye-slash position-absolute top-50 end-0 translate-middle-y me-3"
                            id="togglePassConfig"></i>
                    </div>
                </div>

                <div class="text-end mt-4">
                    <button type="submit"
                        class="btn btn-success">
                        <i class="bi bi-save me-1"></i>Guardar
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    const togglePass = document.getElementById('togglePassConfig');
    const inputPass = document.getElementById('contrasena');

    togglePass.addEventListener('click', () => {
        const type = inputPass.type === 'password' ? 'text' : 'password';
        inputPass.type = type;
        togglePass.classList.toggle('bi-eye');
        togglePass.classList.toggle('bi-eye-slash');
    });
</script>