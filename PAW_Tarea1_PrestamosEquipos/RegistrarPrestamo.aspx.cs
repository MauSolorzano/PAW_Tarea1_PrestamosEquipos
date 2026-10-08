using PAW_Tarea1_PrestamosEquipos.Services;
using PAW_Tarea1_PrestamosEquipos.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Services;
using System.Web.UI;

namespace PAW_Tarea1_PrestamosEquipos
{
    public partial class RegistrarPrestamo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SesionPrestamos.Inicializar();
        }
        // Metodo qie pordrá ser llamado mendiante una peticion WEB
        // Se habilita la sesión para poder acceder a los datos de la sesión
        [WebMethod(EnableSession = true)]
        public static ResultadoOperacion Registrar(
        string nombreEquipo,
        string nombreSolicitante,
        string area,
        string motivo,
        string fechaPrestamo,
        string fechaPrevistaDevolucion)
        {
            // Si es distinto de vacío , se le quitan los espacios en blanco al inicio y al final
            nombreEquipo = nombreEquipo?.Trim();
            nombreSolicitante = nombreSolicitante?.Trim();
            area = area?.Trim();
            motivo = motivo?.Trim();

            // Validación de campos vacíos
            if (string.IsNullOrWhiteSpace(nombreEquipo) ||
                string.IsNullOrWhiteSpace(nombreSolicitante) ||
                string.IsNullOrWhiteSpace(area) ||
                string.IsNullOrWhiteSpace(motivo))
            {
                //Alguno de los campos está vacío, se retorna un resultado de operación con éxito = false y un mensaje de error
                return new ResultadoOperacion
                {
                    Exito = false,
                    Mensaje = "Completa todos los campos."
                };
            }
            // Validar la extensión del nombre del solicitante y que contenga solo letras, espacios, puntos, apóstrofes o guiones
            if (nombreSolicitante.Length < 3 || nombreSolicitante.Length > 80 ||
                !Regex.IsMatch(nombreSolicitante, @"^[\p{L}][\p{L} .'-]*$"))
            {
                return new ResultadoOperacion
                {
                    Exito = false,
                    Mensaje = "El nombre debe tener entre 3 y 80 caracteres y contener solo letras, espacios, puntos, apóstrofes o guiones."
                };
            }
            // Validar la extensión del motivo
            if (motivo.Length < 10 || motivo.Length > 250)
            {
                return new ResultadoOperacion
                {
                    Exito = false,
                    Mensaje = "El motivo debe tener entre 10 y 250 caracteres."
                };
            }

            //Lista de áreas válidas
            string[] areasValidas =
            {
                "Administración",
                "Recursos Humanos",
                "Tecnología",
                "Finanzas",
                "Operaciones"
            };
            // Validar que el área seleccionada sea válida
            if (!areasValidas.Contains(area))
            {
                return new ResultadoOperacion
                {
                    Exito = false,
                    Mensaje = "Selecciona un área válida."
                };
            }

            // Validar las fechas de préstamo y devolución
            DateTime fechaPrestamoValidada;
            DateTime fechaDevolucionValidada;

            // Validar que las fechas estén en el formato correcto y sean válidas
            bool fechaPrestamoCorrecta = DateTime.TryParseExact(
                fechaPrestamo,
                "yyyy-MM-dd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out fechaPrestamoValidada);

            bool fechaDevolucionCorrecta = DateTime.TryParseExact(
                fechaPrevistaDevolucion,
                "yyyy-MM-dd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out fechaDevolucionValidada);

            // Validar que las fechas sean correctas
            if (!fechaPrestamoCorrecta || !fechaDevolucionCorrecta)
            {
                return new ResultadoOperacion
                {
                    Exito = false,
                    Mensaje = "Ingresa fechas válidas."
                };
            }

            // Validar que la fecha de préstamo no sea futura
            if (fechaPrestamoValidada.Date > DateTime.Today)
            {
                return new ResultadoOperacion
                {
                    Exito = false,
                    Mensaje = "La fecha del préstamo no puede ser futura."
                };
            }

            // Validar que la fecha prevista de devolución sea igual o posterior a la fecha del préstamo
            if (fechaDevolucionValidada.Date < fechaPrestamoValidada.Date)
            {
                return new ResultadoOperacion
                {
                    Exito = false,
                    Mensaje = "La fecha prevista de devolución debe ser igual o posterior a la fecha del préstamo."
                };
            }
            // Obtener la lista de equipos y préstamos desde la sesión
            List<Equipo> equipos = SesionPrestamos.ObtenerEquipos();
            List<Prestamo> prestamos = SesionPrestamos.ObtenerPrestamos();

            // Buscar el equipo seleccionado por su nombre
            Equipo equipoSeleccionado = equipos.FirstOrDefault(
                equipo => equipo.Nombre == nombreEquipo);

            // Validar que el equipo seleccionado exista
            if (equipoSeleccionado == null)
            {
                return new ResultadoOperacion
                {
                    Exito = false,
                    Mensaje = "Selecciona un equipo válido."
                };
            }
            // Validar cuantos prestamos de este equipo están pendientes y compararlo con la cantidad total del equipo
            int prestamosPendientes = prestamos.Count(
                prestamo => prestamo.NombreEquipo == nombreEquipo &&
                            prestamo.Estado == "Pendiente");
            // Si la cantidad de préstamos pendientes es mayor o igual a la cantidad total del equipo, no se puede registrar el préstamo
            if (prestamosPendientes >= equipoSeleccionado.CantidadTotal)
            {
                return new ResultadoOperacion
                {
                    Exito = false,
                    Mensaje = "No hay unidades disponibles de ese equipo."
                };
            }
            //Generar un nuevo ID para el préstamo
            // Si no hay préstamos, el nuevo ID será 1, de lo contrario, será el máximo ID existente más 1
            int nuevoId = prestamos.Count == 0
                ? 1
                : prestamos.Max(prestamo => prestamo.Id) + 1;

            // Crear un nuevo objeto Prestamo y agregarlo a la lista de préstamos
            prestamos.Add(new Prestamo
            {
                Id = nuevoId,
                NombreEquipo = nombreEquipo,
                NombreSolicitante = nombreSolicitante,
                Area = area,
                Motivo = motivo,
                FechaPrestamo = fechaPrestamoValidada.Date,
                FechaPrevistaDevolucion = fechaDevolucionValidada.Date,
                Estado = "Pendiente"
            });

            // Mensaje de éxito indicando que el préstamo se registró correctamente
            return new ResultadoOperacion
            {
                Exito = true,
                Mensaje = "El préstamo se registró correctamente."
            };
        }
    }
}