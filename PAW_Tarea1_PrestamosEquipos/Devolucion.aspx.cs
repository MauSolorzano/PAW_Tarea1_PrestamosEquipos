using PAW_Tarea1_PrestamosEquipos.Models;
using PAW_Tarea1_PrestamosEquipos.Services;
using System;
using System.Linq;
using System.Web.Services;
using System.Web.UI;

namespace PAW_Tarea1_PrestamosEquipos
{
    public partial class Devolucion : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SesionPrestamos.Inicializar();
        }

        // Método web para obtener los préstamos pendientes
        [WebMethod(EnableSession = true)]
        public static PrestamoPendiente[] ObtenerPendientes()
        {
            SesionPrestamos.Inicializar();
            // Filtrar los préstamos pendientes y ordenarlos por fecha de préstamo descendente
            return SesionPrestamos.ObtenerPrestamos()
                .Where(p => p.Estado == "Pendiente")
                .OrderByDescending(p => p.FechaPrestamo)
                .Select(p => new PrestamoPendiente // Se recibe un objeto Prestamo y se transforma en un objeto PrestamoPendienteDto
                {
                    Id = p.Id,
                    NombreEquipo = p.NombreEquipo,
                    NombreSolicitante = p.NombreSolicitante,
                    Area = p.Area,
                    FechaPrestamo = p.FechaPrestamo.ToString("dd/MM/yyyy"),
                    FechaPrevistaDevolucion = p.FechaPrevistaDevolucion.ToString("dd/MM/yyyy")
                })
                .ToArray();
        }

        // Método web para procesar la devolución de un préstamo
        [WebMethod(EnableSession = true)]
        public static ResultadoOperacion ProcesarDevolucion(int id) // Se recibe el id del préstamo a devolver
        {
            SesionPrestamos.Inicializar();
            // Buscar el préstamo por su id
            var prestamo = SesionPrestamos.ObtenerPrestamos()
                .FirstOrDefault(p => p.Id == id);
            // Validar si se encontró el préstamo
            if (prestamo == null)
            {
                // Retornar un resultado de operación indicando que no se encontró el préstamo
                return new ResultadoOperacion
                {
                    Exito = false,
                    Mensaje = "No se encontró el préstamo seleccionado."
                };
            }
            // Validar si el préstamo ya fue devuelto
            if (prestamo.Estado != "Pendiente")
            {
                return new ResultadoOperacion
                {
                    Exito = false,
                    Mensaje = "Este préstamo ya fue devuelto."
                };
            }
            // Actualizar el estado del préstamo a "Devuelto"
            prestamo.Estado = "Devuelto";
            prestamo.FechaPrevistaDevolucion = DateTime.Now; // Actualizar la fecha de devolución a la fecha actual

            // Retornar un resultado de operación indicando que la devolución se procesó correctamente
            return new ResultadoOperacion
            {
                Exito = true,
                Mensaje = "La devolución se procesó correctamente."
            };
        }
    }

    // Clase DTO para representar un préstamo pendiente
    public class PrestamoPendiente
    {
        public int Id { get; set; }
        public string NombreEquipo { get; set; }
        public string NombreSolicitante { get; set; }
        public string Area { get; set; }
        public string FechaPrestamo { get; set; }
        public string FechaPrevistaDevolucion { get; set; }
    }
}