<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Devolucion.aspx.cs" Inherits="PAW_Tarea1_PrestamosEquipos.Devolucion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <h1>Procesar devolución</h1>
        <p class="lead">Marca como devueltos los equipos que ya fueron entregados.</p>

        <p>
            <a href="Default.aspx" class="btn btn-default">&larr; Menú principal</a>
        </p>

        <div id="mensajeDevolucion" role="status" aria-live="polite"
            class="alert" style="display: none;">
        </div>

        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <th>Equipo</th>
                        <th>Solicitante</th>
                        <th>Área</th>
                        <th>Fecha del préstamo</th>
                        <th>Devolución prevista</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody id="tablaPendientes">
                </tbody>
            </table>
        </div>
    </div>

    <script type="text/javascript">
    $(function () {

        // Variables para la tabla y el mensaje
        var $tabla = $("#tablaPendientes");
        var $mensaje = $("#mensajeDevolucion");

        // Función para mostrar mensajes de éxito o error
        function mostrarMensaje(texto, tipo) {
            $mensaje
                .removeClass("alert-success alert-danger")
                .addClass("alert-" + tipo)
                .text(texto)
                .show();
        }

        // Función para agregar una celda a una fila
        function agregarCelda($fila, valor) {
            $("<td>")
                .text(valor == null ? "" : valor)
                .appendTo($fila);
        }

        // Función para cargar los préstamos pendientes de devolución
        // Esta función hace una llamada AJAX al servidor para obtener los préstamos pendientes
        function cargarPendientes() {
            $.ajax({
                // Tipo de solicitud
                type: "POST",
                // URL del método en el servidor que devuelve los préstamos pendientes
                url: "Devolucion.aspx/ObtenerPendientes",
                // No enviar datos adicionales, ya que el método no requiere parámetros
                data: "{}",
                // Indicar en que formato se están enviando los datos
                contentType: "application/json; charset=utf-8",
                // Indicar que se espera una respuesta en formato JSON
                dataType: "json"
            })
            // Manejo de la respuesta exitosa
            .done(function (respuesta) {
                // La respuesta del servidor se encuentra en la propiedad 'd' del objeto de respuesta
                // Guardar el resumen en una variable para su posterior uso
                var prestamos = respuesta.d;
                // Limpiar la tabla antes de llenarla con los datos obtenidos
                $tabla.empty();

                // Si no hay préstamos pendientes, mostrar un mensaje en la tabla
                if (prestamos.length === 0) {
                    $tabla.append(
                        '<tr><td colspan="6">No hay préstamos pendientes de devolución.</td></tr>'
                    );
                    return;
                }

                // Bloque para llenar la tabla con los datos obtenidos del servidor
                // each es una función de jQuery que itera sobre cada elemento de un array o un objeto
                // su estructura es $.each(array, function(index, value) { ... });
                // En este caso, se usa el parámetro '_' para indicar que no se necesita el índice del elemento, solo el valor (equipo)
                $.each(prestamos, function (_, prestamo) {
                    // Crear una nueva fila para cada préstamo
                    var $fila = $("<tr>");
                    // Agregar celdas a la fila con los datos del préstamo
                    agregarCelda($fila, prestamo.NombreEquipo);
                    agregarCelda($fila, prestamo.NombreSolicitante);
                    agregarCelda($fila, prestamo.Area);
                    agregarCelda($fila, prestamo.FechaPrestamo);
                    agregarCelda($fila, prestamo.FechaPrevistaDevolucion);
                    // Crear un botón para marcar como devuelto y agregarlo a la fila
                    var $boton = $("<button>", {
                        type: "button",
                        "class": "btn btn-success btn-devolver",
                        text: "Marcar como devuelto"
                    }).attr("data-id", prestamo.Id);

                    // Agregar el botón a la última celda de la fila
                    $("<td>").append($boton).appendTo($fila);
                    // Agregar la fila completa a la tabla
                    $tabla.append($fila);
                });
            })
            // Manejo de errores en la llamada AJAX
            .fail(function (xhr) {
                console.error("Falló la carga de préstamos:", xhr.status, xhr.responseText);
                mostrarMensaje("No fue posible cargar los préstamos pendientes.", "danger");
            });
        }
        // Fin de la función cargarPendientes

        // Manejo del evento click en los botones de devolución
        $tabla.on("click", ".btn-devolver", function () {
            // Obtener el botón que fue clickeado y el ID del préstamo asociado
            var $boton = $(this);
            var idPrestamo = parseInt($boton.attr("data-id"), 10);

            // Confirmar con el usuario antes de procesar la devolución
            if (!window.confirm("¿Confirmas que este equipo fue devuelto?")) {
                return;
            }
            // Deshabilitar el botón para evitar múltiples clics y ocultar cualquier mensaje previo
            $boton.prop("disabled", true);
            $mensaje.hide();

            // Hacer una llamada AJAX al servidor para procesar la devolución
            $.ajax({
                // Tipo de solicitud
                type: "POST",
                // URL del método en el servidor que procesa la devolución
                url: "Devolucion.aspx/ProcesarDevolucion",
                // Enviar el ID del préstamo en formato JSON
                data: JSON.stringify({ id: idPrestamo }),
                // Indicar en que formato se están enviando los datos
                contentType: "application/json; charset=utf-8",
                // Indicar que se espera una respuesta en formato JSON
                dataType: "json"
            })
            // Manejo de la respuesta exitosa
                .done(function (respuesta) {
                // La respuesta del servidor se encuentra en la propiedad 'd' del objeto de respuesta
                var resultado = respuesta.d;
                // Mostrar un mensaje al usuario indicando si la devolución fue exitosa o si hubo un error
                mostrarMensaje(
                    resultado.Mensaje,
                    resultado.Exito ? "success" : "danger"
                );
                // Si la devolución fue exitosa, recargar la lista de préstamos pendientes
                if (resultado.Exito) {
                    cargarPendientes();
                }
            })
            // Manejo de errores en la llamada AJAX
            .fail(function (xhr) {
                console.error("Falló el procesamiento de la devolución:", xhr.status, xhr.responseText);
                mostrarMensaje("No fue posible procesar la devolución.", "danger");
            })
            // Siempre habilitar el botón nuevamente, sin importar si la llamada fue exitosa o fallida
            .always(function () {
                $boton.prop("disabled", false);
            });
        });
        // Cargar los préstamos pendientes de devolución al cargar la página
        cargarPendientes();
    });
    </script>
</asp:Content>
