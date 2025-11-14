package modelo;
    public class Habitacion {
    private int numero;
    private String tipo;
    private String descripcion;
    private double precioPorNoche; // o BigDecimal
    private boolean disponible;

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public void setPrecioPorNoche(double precioPorNoche) {
        this.precioPorNoche = precioPorNoche;
    }

    public void setDisponible(boolean disponible) {
        this.disponible = disponible;
    }

    public int getNumero() {
        return numero;
    }

    public String getTipo() {
        return tipo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public double getPrecioPorNoche() {
        return precioPorNoche;
    }

    public boolean isDisponible() {
        return disponible;
    }

    public static System.Logger getLOG() {
        return LOG;
    }

    public Habitacion(int numero, String tipo, String descripcion, double precioPorNoche, boolean disponible) {
        this.numero = numero;
        this.tipo = tipo;
        this.descripcion = descripcion;
        this.precioPorNoche = precioPorNoche;
        this.disponible = disponible;
    }
    
    private static final System.Logger LOG = System.getLogger(Habitacion.class.getName());

	public Habitacion() {}

	
}