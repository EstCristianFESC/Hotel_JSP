<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Consumos Restaurante</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>

<body class="bg-dark text-white">

    <div class="container mt-4">
        <h3 class="mb-4"><i class="bi bi-receipt me-2"></i>Registrar Consumo</h3>

        <div class="card bg-secondary text-white">
            <div class="card-body">
                <form action="../RestauranteControl" method="POST" class="row">
                    <input type="hidden" name="accion" value="registrarConsumo"/>

                    <div class="col-md-4">
                        <label>Descripción</label>
                        <input type="text" name="descripcion" class="form-control" required/>
                    </div>

                    <div class="col-md-2">
                        <label>Cantidad</label>
                        <input type="number" name="cantidad" class="form-control" required/>
                    </div>

                    <div class="col-md-3">
                        <label>Valor Unitario</label>
                        <input type="number" name="valorUnitario" class="form-control" required/>
                    </div>

                    <div class="col-md-3 d-flex align-items-end">
                        <button class="btn btn-primary w-100">Registrar Consumo</button>
                    </div>
                </form>
            </div>
        </div>

    </div>
</body>
</html>