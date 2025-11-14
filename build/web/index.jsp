<%@page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HotelSys - Iniciar Sesión</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #ffffff;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0;
                padding: 1rem;
            }

            .login-card {
                background: rgba(255, 255, 255, 0.95);
                border: 1px solid rgba(33, 37, 41, 0.06);
                border-radius: 20px;
                padding: 2.5rem 2rem;
                width: 100%;
                max-width: 400px;
                color: #212529;
                box-shadow: 0 10px 30px rgba(33, 37, 41, 0.08);
                animation: fadeIn 0.6s ease-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(12px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .login-card h3 {
                font-weight: 600;
                margin-bottom: 0.5rem;
                color: #0d3b66;
            }

            .bi-building {
                font-size: 2.5rem;
                color: #0d6efd;
                margin-bottom: 0.35rem;
            }

            .form-control {
                background-color: rgba(0, 0, 0, 0.03);
                border: 1px solid rgba(33, 37, 41, 0.08);
                color: #212529;
                border-radius: 10px;
                padding: 10px 15px;
            }

            .form-control:focus {
                background-color: #fff;
                box-shadow: 0 0 0 0.15rem rgba(13, 110, 253, 0.12);
                color: #212529;
                border-color: rgba(13, 110, 253, 0.3);
            }

            ::placeholder {
                color: rgba(33, 37, 41, 0.45);
            }

            .btn-login {
                background-color: #0d6efd;
                color: #fff;
                font-weight: 600;
                border-radius: 12px;
                transition: all 0.2s ease;
                border: none;
            }

            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 18px rgba(13, 110, 253, 0.18);

                border: 2px solid #084ec1;
            }

            .login-footer {
                margin-top: 1.5rem;
                font-size: 0.9rem;
                color: rgba(33, 37, 41, 0.6);
                text-align: center;
            }

            .position-relative {
                position: relative;
            }

            .password-wrapper {
                position: relative;
            }

            .password-wrapper input {
                padding-right: 2.4rem !important;
            }

            #togglePassword {
                position: absolute;
                top: 50%;
                right: 12px;
                transform: translateY(-50%);
                cursor: pointer;
                color: rgba(33, 37, 41, 0.55);
                font-size: 1.1rem;
                transition: color 0.2s ease;
            }

            #togglePassword:hover {
                color: #0d6efd;
            }

            @media (max-width: 576px) {
                .login-card {
                    padding: 2rem 1.5rem;
                }

                .bi-building {
                    font-size: 2rem;
                }

                .login-card h3 {
                    font-size: 1.5rem;
                }
            }
        </style>
    </head>

    <body>
        <div class="login-card text-center">
            <i class="bi bi-building"></i>
            <h3>HotelSys</h3>
            <p class="mb-4 text-muted">Accede a tu panel de administración</p>

            <% String error=(String) request.getAttribute("error"); %>
                <% if (error !=null) { %>
                    <div class="alert alert-danger text-center py-2">
                        <%= error %>
                    </div>
                    <% } %>

                        <form action="LoginController" method="post">
                            <div class="mb-3 text-start">
                                <label for="usuario" class="form-label">Usuario</label>
                                <input type="text" id="usuario" name="usuario" class="form-control"
                                    placeholder="Ingresa tu usuario" required>
                            </div>

                            <div class="mb-4 text-start password-wrapper">
                                <label for="password" class="form-label">Contraseña</label>
                                <input type="password" id="password" name="password" class="form-control"
                                    placeholder="Ingresa tu Contraseña" required>
                                <i class="bi bi-eye" id="togglePassword"></i>
                            </div>


                            <button type="submit" class="btn btn-login w-100 py-2">Iniciar
                                sesión</button>
                        </form>

                        <div class="login-footer mt-4">
                            <small>© <%= java.time.Year.now() %> HotelSys · Todos los
                                    derechos reservados</small>
                        </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            const togglePassword = document.getElementById('togglePassword');
            const password = document.getElementById('password');

            togglePassword.addEventListener('click', () => {
                const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                password.setAttribute('type', type);
                togglePassword.classList.toggle('bi-eye');
                togglePassword.classList.toggle('bi-eye-slash');
            });
        </script>

    </body>

</html>