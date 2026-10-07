using PAW_Tarea1_PrestamosEquipos.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PAW_Tarea1_PrestamosEquipos.Services
{
    public static class SesionPrestamos
    {
        private const string ClaveEquipos = "Equipos";
        private const string ClavePrestamos = "Prestamos";

        public static void Inicializar()
        {
            var sesion = HttpContext.Current.Session;

            if (sesion[ClaveEquipos] == null)
            {
                sesion[ClaveEquipos] = new List<Equipo>
                {
                    new Equipo { Nombre = "Laptop", CantidadTotal = 3 },
                    new Equipo { Nombre = "Proyector", CantidadTotal = 2 },
                    new Equipo { Nombre = "Tablet", CantidadTotal = 2 },
                    new Equipo { Nombre = "Cámara", CantidadTotal = 1 },
                    new Equipo { Nombre = "Audífonos", CantidadTotal = 4 }
                };
            }

            if (sesion[ClavePrestamos] == null)
            {
                sesion[ClavePrestamos] = new List<Prestamo>();
            }
        }

        public static List<Equipo> ObtenerEquipos()
        {
            Inicializar();
            return (List<Equipo>)HttpContext.Current.Session[ClaveEquipos];
        }

        public static List<Prestamo> ObtenerPrestamos()
        {
            Inicializar();
            return (List<Prestamo>)HttpContext.Current.Session[ClavePrestamos];
        }
    }

}
