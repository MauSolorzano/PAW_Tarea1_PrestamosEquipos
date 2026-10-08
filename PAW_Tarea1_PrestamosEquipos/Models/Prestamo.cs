using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace PAW_Tarea1_PrestamosEquipos.Models
{
    public class Prestamo
    {
        public int Id { get; set; }
        public string NombreEquipo { get; set; }
        public string NombreSolicitante { get; set; }
        public string Area { get; set; }
        public string Motivo { get; set; }
        public DateTime FechaPrestamo { get; set; }
        public DateTime FechaPrevistaDevolucion { get; set; }
        public string Estado { get; set; }

    }
}