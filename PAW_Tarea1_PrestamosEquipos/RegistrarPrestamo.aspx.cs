using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PAW_Tarea1_PrestamosEquipos.Services;

namespace PAW_Tarea1_PrestamosEquipos
{
    public partial class RegistrarPrestamo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SesionPrestamos.Inicializar();
        }
    }
}