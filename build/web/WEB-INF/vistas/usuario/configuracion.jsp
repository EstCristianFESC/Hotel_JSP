<%@page import="modelo.Usuario"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">

            <div class="card shadow-lg border-0 rounded-4">
                <div class="card-header text-white text-center fs-5 fw-semibold" style="background-color: #0f172a;">
                    <i class="bi bi-gear-fill me-2"></i>Configuración de Usuario
                </div>
                <div class="card-body">

                    <!-- Paso 1: Validar contraseña -->
                    <div id="validarContrasena">
                        <p class="text-muted mb-3">Ingresa tu contraseña para continuar:</p>
                        <form action="ConfiguracionController" method="post">
                            <input type="hidden" name="accion" value="verificar">

                            <div class="mb-3 input-group">
                                <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                                <input type="password" name="passwordActual" id="passwordActual" class="form-control" placeholder="Contraseña actual" required>
                                <span class="input-group-text" style="cursor:pointer;" onclick="togglePassword('passwordActual')">
                                    <i class="bi bi-eye" id="icon-passwordActual"></i>
                                </span>
                            </div>

                            <button type="submit" class="btn btn-primary w-100" style="background-color: #0f172a; border-color: #0f172a;">
                                <i class="bi bi-check2-circle me-1"></i> Validar
                            </button>

                            <% if (request.getAttribute("error") != null) { %>
                                <div class="alert alert-danger mt-3 mb-0 text-center">
                                    <%= request.getAttribute("error") %>
                                </div>
                            <% } %>
                        </form>
                    </div>

                    <!-- Paso 2: Editar datos (oculto inicialmente) -->
                    <div id="editarUsuario" style="display:none;">
                        <p class="text-muted mb-3">Actualiza tus datos:</p>
                        <form action="ConfiguracionController" method="post">
                            <input type="hidden" name="accion" value="actualizar">

                            <div class="mb-3 input-group">
                                <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                                <input type="text" name="nombre" class="form-control" value="<%= usuario.getNombre() %>" placeholder="Nombre" required>
                            </div>

                            <div class="mb-3 input-group">
                                <span class="input-group-text"><i class="bi bi-person-badge-fill"></i></span>
                                <input type="text" class="form-control" value="<%= usuario.getUsername() %>" readonly>
                            </div>

                            <div class="mb-3 input-group">
                                <span class="input-group-text"><i class="bi bi-key-fill"></i></span>
                                <input type="password" name="nuevaPassword" id="nuevaPassword" class="form-control" placeholder="Nueva contraseña (opcional)">
                                <span class="input-group-text" style="cursor:pointer;" onclick="togglePassword('nuevaPassword')">
                                    <i class="bi bi-eye" id="icon-nuevaPassword"></i>
                                </span>
                            </div>

                            <button type="submit" class="btn btn-success w-100">
                                <i class="bi bi-save2 me-1"></i> Guardar cambios
                            </button>
                        </form>
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>

<script>
    // Mostrar formulario de edición si la verificación fue correcta
    <% if (request.getAttribute("okVerificacion") != null) { %>
        document.getElementById("validarContrasena").style.display = "none";
        document.getElementById("editarUsuario").style.display = "block";
    <% } %>

    function togglePassword(inputId) {
        const input = document.getElementById(inputId);
        const icon = document.getElementById("icon-" + inputId);

        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('bi-eye');
            icon.classList.add('bi-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('bi-eye-slash');
            icon.classList.add('bi-eye');
        }
    }
</script>