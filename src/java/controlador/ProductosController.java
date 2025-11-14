package controlador;

import dao.ProductosDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import modelo.Productos;

@WebServlet("/ProductosController")
public class ProductosController extends HttpServlet {

    private final ProductosDAO productoDAO = new ProductosDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String accion = req.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {

            case "listar":
                req.setAttribute("listaProductos", productoDAO.listar());
                req.getRequestDispatcher("WEB-INF/vistas/productos/productos.jsp")
                   .forward(req, resp);
                break;

            case "crear":
                req.getRequestDispatcher("WEB-INF/vistas/productos/productosCrear.jsp")
                   .forward(req, resp);
                break;

            case "editar":
                int idEditar = Integer.parseInt(req.getParameter("id"));
                Productos prod = productoDAO.buscarPorId(idEditar);
                req.setAttribute("producto", prod);
                req.getRequestDispatcher("WEB-INF/vistas/productos/productosEditar.jsp")
                   .forward(req, resp);
                break;

            case "eliminar":
                int idEliminar = Integer.parseInt(req.getParameter("id"));
                productoDAO.eliminar(idEliminar);
                resp.sendRedirect("ProductosController?accion=listar");
                break;

            default:
                resp.sendRedirect("ProductosController?accion=listar");
                break;
        }
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
                break;
            }

            case "actualizarProducto": {

                int id = Integer.parseInt(req.getParameter("id"));
                String descripcion = req.getParameter("descripcion");
                long valor = Long.parseLong(req.getParameter("valor"));

                Productos p = new Productos(id, descripcion, valor, 1);

                productoDAO.actualizar(p);

                resp.sendRedirect("ProductosController?accion=listar");
                break;
            }
        }
    }
}