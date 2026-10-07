using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PAW_Tarea1_PrestamosEquipos.Models;

namespace PAW_Tarea1_PrestamosEquipos
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            IniciarSesion();
        }


        private void IniciarSesion()
        {
            if (Session["Equipos"] == null)
            {
                List<Equipo> equipos = new List<Equipo>
                {
                    new Equipo { Nombre = "Laptop", CantidadTotal = 3 },
                    new Equipo { Nombre = "Proyector", CantidadTotal = 2 },
                    new Equipo { Nombre = "Tablet", CantidadTotal = 2 },
                    new Equipo { Nombre = "Cámara", CantidadTotal = 1 },
                    new Equipo { Nombre = "Audífonos", CantidadTotal = 4 }
                };

                Session["Equipos"] = equipos;
            }

            if (Session["Prestamos"] == null)
            {
                List<Prestamo> prestamos = new List<Prestamo>();
                Session["Prestamos"] = prestamos;
            }
        }

    }
}
