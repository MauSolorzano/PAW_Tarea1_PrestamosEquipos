using PAW_Tarea1_PrestamosEquipos.Models;
using PAW_Tarea1_PrestamosEquipos.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Services;
using System.Web.UI;

namespace PAW_Tarea1_PrestamosEquipos
{
    public partial class ConsultarPrestamos : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SesionPrestamos.Inicializar();
        }
        // Metodo qie pordrá ser llamado mendiante una peticion WEB
        // Se habilita la sesión para poder acceder a los datos de la sesión
        [WebMethod(EnableSession = true)]
        public static ResumenConsulta ObtenerResumen()
        {
            SesionPrestamos.Inicializar();

            // Obtener los equipos y préstamos desde la sesión
            List<Equipo> equipos = SesionPrestamos.ObtenerEquipos();
            List<Prestamo> prestamos = SesionPrestamos.ObtenerPrestamos();


            return new ResumenConsulta
            {

                // Primero se construye la lista de inventario, calculando la cantidad prestada y disponible para cada equipo
                Inventario = equipos.Select(e =>
                {
                    // Cantidad de equipos prestados que están pendientes de devolución
                    int prestados = prestamos.Count(p =>
                        p.NombreEquipo == e.Nombre &&
                        p.Estado == "Pendiente");

                    // Crear un objeto EquipoConsulta con la información calculada
                    return new EquipoConsulta
                    {
                        Nombre = e.Nombre,
                        CantidadTotal = e.CantidadTotal,
                        CantidadPrestada = prestados,
                        CantidadDisponible = e.CantidadTotal - prestados
                    };
                }).ToList(),

                // Construir la lista de préstamos, ordenando por fecha de préstamo descendente y formateando las fechas
                Prestamos = prestamos
                    .OrderByDescending(p => p.FechaPrestamo) // Ordenar por fecha de préstamo descendente
                    .Select(p => new PrestamoConsulta // Crear un objeto PrestamoConsulta con la información del préstamo
                    {
                        Id = p.Id,
                        NombreEquipo = p.NombreEquipo,
                        NombreSolicitante = p.NombreSolicitante,
                        Area = p.Area,
                        Motivo = p.Motivo,
                        FechaPrestamo = p.FechaPrestamo.ToString("dd/MM/yyyy"), // Convertir la fecha a formato "dd/MM/yyyy" y a string
                        FechaPrevistaDevolucion = p.FechaPrevistaDevolucion.ToString("dd/MM/yyyy"),
                        Estado = p.Estado
                    }).ToList()
            };
        }
    }

    // Clases para representar la información que se enviará al cliente
    // Contenedor de dos listas: una de equipos (inventario) y otra de préstamos
    public class ResumenConsulta
    {
        public List<EquipoConsulta> Inventario { get; set; }
        public List<PrestamoConsulta> Prestamos { get; set; }
    }

    public class EquipoConsulta
    {
        public string Nombre { get; set; }
        public int CantidadTotal { get; set; }
        public int CantidadPrestada { get; set; }
        public int CantidadDisponible { get; set; }
    }

    public class PrestamoConsulta
    {
        public int Id { get; set; }
        public string NombreEquipo { get; set; }
        public string NombreSolicitante { get; set; }
        public string Area { get; set; }
        public string Motivo { get; set; }
        public string FechaPrestamo { get; set; }
        public string FechaPrevistaDevolucion { get; set; }
        public string Estado { get; set; }
    }
}