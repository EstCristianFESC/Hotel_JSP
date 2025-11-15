package controlador;

import dao.ProductosDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;
import modelo.Productos;

@WebServlet("/ProductosController")
public class ProductosController extends HttpServlet {

    private final ProductosDAO productoDAO = new ProductosDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String accion = req.getParameter("accion");
        if (accion == null) accion = "listar";

        String url = "/WEB-INF/vistas/layout.jsp?page=productos/productos.jsp";

        switch (accion) {

            case "listar":
                req.setAttribute("listaProductos", productoDAO.listar());
                req.setAttribute("mensaje", "Consulta realizada correctamente.");
                req.setAttribute("tipoMensaje", "alert-info");
                break;

            case "consultar": {
                String idStr = req.getParameter("id");
                String desc = req.getParameter("descripcion");

                List<Productos> lista = productoDAO.filtrar(idStr, desc);

                req.setAttribute("listaProductos", lista);
                req.setAttribute("mensaje", lista.isEmpty()
                        ? "No se encontraron productos con los filtros aplicados."
                        : "Búsqueda finalizada.");
                req.setAttribute("tipoMensaje", lista.isEmpty() ? "alert-warning" : "alert-success");

                break;
            }

            case "crear":
                req.setAttribute("page", "productos/productosCrear.jsp");
                url = "/WEB-INF/vistas/layout.jsp?page=productos/productosCrear.jsp";
                break;

            case "editar":
                int idEditar = Integer.parseInt(req.getParameter("id"));
                Productos prod = productoDAO.buscarPorId(idEditar);
                req.setAttribute("producto", prod);
                url = "/WEB-INF/vistas/layout.jsp?page=productos/productosEditar.jsp";
                break;
                
            case "eliminar":
                int idEliminar = Integer.parseInt(req.getParameter("id"));
                productoDAO.eliminar(idEliminar);

                req.setAttribute("mensaje", "Producto eliminado correctamente.");
                req.setAttribute("tipoMensaje", "alert-success");

                resp.sendRedirect("ProductosController?accion=listar");
                return;
        }

        req.getRequestDispatcher(url).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String accion = req.getParameter("accion");

        switch (accion) {

            case "agregarProducto": {

                String descripcion = req.getParameter("descripcion");
                long valor = Long.parseLong(req.getParameter("valor"));

                Productos p = new Productos();
                p.setDescripcion(descripcion);
                p.setValorUnitario(valor);

                productoDAO.agregar(p);

                resp.sendRedirect("ProductosController?accion=listar");
                return;
            }

            case "actualizarProducto": {

                int id = Integer.parseInt(req.getParameter("id"));
                String descripcion = req.getParameter("descripcion");
                long valor = Long.parseLong(req.getParameter("valor"));

                Productos p = new Productos(id, descripcion, valor, 1);

                productoDAO.actualizar(p);

                resp.sendRedirect("ProductosController?accion=listar");
                return;
            }
        }
    }
}