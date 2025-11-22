<%@page import="modelo.Usuario" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String pagina = (String) request.getAttribute("page");
    if (pagina == null || pagina.trim().isEmpty()) {
        pagina = request.getParameter("page");
    }

    if (pagina == null || pagina.trim().isEmpty()) {
        pagina = "inicio/inicio.jsp";
    } else {
        pagina = pagina.trim();
    }

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HotelSys</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --sidebar-bg: #0f172a;
            --sidebar-hover: #1e293b;
            --sidebar-active: #2563eb;
            --text-light: #f8fafc;
            --text-muted: #94a3b8;
            --content-bg: #f1f5f9;
            --text-dark: #1f2937;
            --primary-color: #2563eb;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--content-bg);
            color: var(--text-dark);
            transition: background-color 0.3s, color 0.3s;
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            height: 100vh;
            background-color: var(--sidebar-bg);
            color: var(--text-light);
            transition: transform 0.3s ease;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.3);
            z-index: 1030;
        }

        .sidebar .nav-link {
            color: var(--text-light);
            border-radius: 8px;
            margin: 4px 8px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 16px;
            transition: background 0.2s, color 0.2s;
        }

        .sidebar .nav-link:hover {
            background-color: var(--sidebar-hover);
            color: var(--text-light);
        }

        .sidebar .nav-link.active {
            background-color: var(--sidebar-active);
            color: white;
            box-shadow: 0 0 10px rgba(37, 99, 235, 0.4);
        }

        main {
            margin-left: 250px;
            padding: 40px;
            transition: margin-left 0.3s ease;
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.show {
                transform: translateX(0);
            }

            main {
                margin-left: 0;
                padding: 20px;
            }
        }

        .fade-in {
            animation: fadeIn 0.3s ease-in-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(5px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>

<body>
    <!-- NAVBAR MÓVIL -->
    <nav class="navbar navbar-dark d-md-none px-3 shadow-sm" style="background-color: #1e293b;">
        <button class="btn btn-outline-light" id="toggleSidebar"><i class="bi bi-list"></i></button>
        <span class="navbar-brand text-white ms-2"><i class="bi bi-building me-2"></i>HotelSys</span>
    </nav>

    <!-- BACKDROP -->
    <div id="sidebarBackdrop" style="
        display:none;
        position:fixed;
        inset:0;
        background: rgba(0,0,0,0.3);
        z-index:1025;"></div>

    <!-- SIDEBAR -->
    <div class="sidebar p-3">
        <div class="mb-4 text-center">
            <h4 class="text-white m-0"><i class="bi bi-building me-2"></i>HotelSys</h4>
        </div>

        <% Usuario usuarioLog = (Usuario) session.getAttribute("usuarioLogueado"); %>

        <div class="d-flex align-items-center gap-2 mb-4 p-2 rounded"
            style="background:#1e293b; border:1px solid rgba(255,255,255,0.1);">

            <i class="bi bi-person-circle text-white" style="font-size:22px;"></i>

            <div class="text-white" style="line-height:1;">
                <span style="font-size:14px; font-weight:600;">
                    <%= usuarioLog.getNombre() %>
                </span><br>
                <small class="text-secondary">Usuario activo</small>
            </div>
        </div>

        <!-- INICIO -->
        <a href="${pageContext.request.contextPath}/LoginController?page=inicio/inicio.jsp"
            class="nav-link <%= pagina.contains("inicio") ? "active" : "" %>">
            <i class="bi bi-house-door"></i> Inicio
        </a>

        <!-- CLIENTES -->
        <a class="nav-link d-flex justify-content-between align-items-center"
            data-bs-toggle="collapse" href="#submenuClientes" role="button"
            aria-expanded="<%= pagina.contains("clientes") ? "true" : "false" %>">
            <span><i class="bi bi-person-lines-fill"></i> Clientes</span>
            <i class="bi bi-chevron-down small"></i>
        </a>

        <div class="collapse <%= pagina.contains("clientes") ? "show" : "" %>" id="submenuClientes">

            <a href="${pageContext.request.contextPath}/LoginController?page=clientes/clientesRegistrar.jsp"
                class="nav-link ms-4 <%= pagina.contains("clientesRegistrar") ? "active" : "" %>">
                <i class="bi bi-person-plus"></i> Registrar
            </a>

            <a href="${pageContext.request.contextPath}/LoginController?page=clientes/clientesConsultar.jsp"
                class="nav-link ms-4 <%= pagina.contains("clientesConsultar") ? "active" : "" %>">
                <i class="bi bi-search"></i> Consultar
            </a>
        </div>

        <!-- HABITACIONES -->
        <a class="nav-link d-flex justify-content-between align-items-center"
            data-bs-toggle="collapse" href="#submenuHabitaciones" role="button"
            aria-expanded="<%= pagina.contains("habitaciones") ? "true" : "false" %>">
            <span><i class="bi bi-door-closed"></i> Habitaciones</span>
            <i class="bi bi-chevron-down small"></i>
        </a>

        <div class="collapse <%= pagina.contains("habitaciones") ? "show" : "" %>" id="submenuHabitaciones">

            <a href="${pageContext.request.contextPath}/LoginController?page=habitaciones/habitacionesRegistrar.jsp"
                class="nav-link ms-4 <%= pagina.contains("habitacionesRegistrar") ? "active" : "" %>">
                <i class="bi bi-plus-square"></i> Registrar
            </a>

            <a href="${pageContext.request.contextPath}/LoginController?page=habitaciones/habitacionesConsultar.jsp"
                class="nav-link ms-4 <%= pagina.contains("habitacionesConsultar") ? "active" : "" %>">
                <i class="bi bi-search"></i> Consultar
            </a>
        </div>

        <!-- RESERVAS -->
        <a class="nav-link d-flex justify-content-between align-items-center"
            data-bs-toggle="collapse" href="#submenuReservas" role="button"
            aria-expanded="<%= pagina.contains("reservas") ? "true" : "false" %>">
            <span><i class="bi bi-calendar-check"></i> Reservas</span>
            <i class="bi bi-chevron-down small"></i>
        </a>

        <div class="collapse <%= pagina.contains("reservas") ? "show" : "" %>" id="submenuReservas">

            <a href="${pageContext.request.contextPath}/LoginController?page=reservas/reservaRegistrar.jsp"
                class="nav-link ms-4 <%= pagina.contains("reservaRegistrar") ? "active" : "" %>">
                <i class="bi bi-calendar-plus"></i> Registrar
            </a>

            <a href="${pageContext.request.contextPath}/LoginController?page=reservas/reservaConsultar.jsp"
                class="nav-link ms-4 <%= pagina.contains("reservaConsultar") ? "active" : "" %>">
                <i class="bi bi-search"></i> Consultar
            </a>

        </div>

        <!-- PRODUCTOS -->
        <a class="nav-link d-flex justify-content-between align-items-center"
            data-bs-toggle="collapse" href="#submenuProductos" role="button"
            aria-expanded="<%= pagina.contains("productos") ? "true" : "false" %>">
            <span><i class="bi bi-basket"></i> Productos</span>
            <i class="bi bi-chevron-down small"></i>
        </a>

        <div class="collapse <%= pagina.contains("productos") ? "show" : "" %>" id="submenuProductos">

            <a href="${pageContext.request.contextPath}/LoginController?page=productos/productosCrear.jsp"
                class="nav-link ms-4 <%= pagina.contains("productosCrear") ? "active" : "" %>">
                <i class="bi bi-plus-square"></i> Crear
            </a>

            <a href="${pageContext.request.contextPath}/LoginController?page=productos/productos.jsp"
                class="nav-link ms-4 <%= pagina.contains("productos.jsp") ? "active" : "" %>">
                <i class="bi bi-search"></i> Consultar
            </a>
        </div>

        <hr>

        <!-- CONFIGURACIÓN -->
        <a href="${pageContext.request.contextPath}/LoginController?page=usuario/configuracion.jsp"
            class="nav-link <%= pagina.contains("configuracion") ? "active" : "" %>">
            <i class="bi bi-gear"></i> Configuración
        </a>

        <hr>

        <!-- CERRAR SESIÓN -->
        <a href="${pageContext.request.contextPath}/LogoutController"
            class="nav-link mt-auto mb-3 text-white d-flex align-items-center justify-content-center"
            style="background-color: #dc3545; border-radius: 8px; padding: 10px;">
            <i class="bi bi-box-arrow-right me-2"></i> Cerrar Sesión
        </a>

    </div>

    <main class="fade-in">

        <% 
            String titulo = "HotelSys - ";

            if (pagina.equals("inicio.jsp"))                      titulo += "Inicio";
            else if (pagina.equals("clientes/clientesRegistrar.jsp"))  titulo += "Registrar Cliente";
            else if (pagina.equals("clientes/clientesConsultar.jsp"))  titulo += "Consultar Clientes";
            else if (pagina.equals("habitaciones/habitacionesRegistrar.jsp")) titulo += "Registrar Habitación";
            else if (pagina.equals("habitaciones/habitacionesConsultar.jsp")) titulo += "Consultar Habitaciones";
            else if (pagina.startsWith("habitaciones/"))          titulo += "Habitaciones";

            else if (pagina.equals("reservas/reservaRegistrar.jsp"))   titulo += "Registrar Reserva";
            else if (pagina.equals("reservas/reservaConsultar.jsp"))   titulo += "Consultar Reservas";
            else if (pagina.startsWith("reservas/"))              titulo += "Reservas";

            else if (pagina.contains("productosCrear"))           titulo += "Crear Productos";
            else if (pagina.contains("productosEditar"))          titulo += "Editar Productos";
            else if (pagina.contains("productos"))                titulo += "Productos";

            else if (pagina.contains("configuracion"))            titulo += "Configuración";
            else titulo += "Panel Principal"; 
        %>

        <script>document.title = "<%= titulo %>";</script>

        <jsp:include page="<%= pagina %>" flush="true" />

    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const sidebar = document.querySelector('.sidebar');
        const toggleBtn = document.getElementById('toggleSidebar');
        const backdrop = document.getElementById('sidebarBackdrop');

        toggleBtn?.addEventListener('click', () => {
            sidebar.classList.toggle('show');
            backdrop.style.display = sidebar.classList.contains('show') ? 'block' : 'none';
        });

        backdrop?.addEventListener('click', () => {
            sidebar.classList.remove('show');
            backdrop.style.display = 'none';
        });
    </script>

</body>
</html>