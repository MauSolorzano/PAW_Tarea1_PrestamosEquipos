<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ConsultarPrestamos.aspx.cs" Inherits="PAW_Tarea1_PrestamosEquipos.ConsultarPrestamos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <h1>Consultar préstamos e inventario</h1>
        <p class="lead">Revisa las unidades disponibles y los préstamos de esta sesión.</p>
        <p>
            <a href="Default.aspx" class="btn btn-default">&larr; Menú principal</a>
        </p>
        <h2>Inventario</h2>
        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <th>Equipo</th>
                        <th>Cantidad total</th>
                        <th>Unidades prestadas</th>
                        <th>Unidades disponibles</th>
                    </tr>
                </thead>
                <tbody id="tablaInventario">
                </tbody>
            </table>
        </div>

        <h2>Préstamos registrados</h2>
        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <th>ID Préstamo</th>
                        <th>Equipo</th>
                        <th>Solicitante</th>
                        <th>Área</th>
                        <th>Motivo</th>
                        <th>Fecha del préstamo</th>
                        <th>Devolución prevista</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody id="tablaPrestamos">
                </tbody>
            </table>
        </div>


        <div id="mensajeConsulta" role="status" aria-live="polite"
            class="alert" style="display: none;">
        </div>
    </div>


    <script type="text/javascript">

        $(function () { 

            // Variables para las tablas y el mensaje
            var $tablaInventario = $("#tablaInventario");
            var $tablaPrestamos = $("#tablaPrestamos");
            var $mensaje = $("#mensajeConsulta");

            // Función para agregar una celda a una fila
            function agregarCelda($fila, valor) {
                $("<td>")
                .text(valor == null ? "" : valor)
                .appendTo($fila);
            }
                
            // Función para mostrar un mensaje de error
            function mostrarError(texto) {
            $mensaje
                .removeClass("alert-success")
                .addClass("alert-danger")
                .text(texto
                .show();
            }

            // Solicitar el resumen de inventario y préstamos al servidor por medio de Ajax
            $.ajax({
                //Tipo de solicitud
                type: "POST",
                //URL del método en el servidor que devuelve el resumen
                url: "ConsultarPrestamos.aspx/ObtenerResumen",
                // No enviar datos adicionales, ya que el método no requiere parámetros
                data: "{}",
                // Indicar en que formato se están enviando los datos
                contentType: "application/json; charset=utf-8",
                // Indicar en que formato se espera la respuesta del servidor
                dataType: "json"
             })

            .done(function (respuesta) {

                // La respuesta del servidor se encuentra en la propiedad 'd' del objeto de respuesta
                // Guardar el resumen en una variable para su posterior uso
                var resumen = respuesta.d;

                // Limpiar las tablas y el mensaje antes de llenarlas con los datos obtenidos
                $tablaInventario.empty();
                $tablaPrestamos.empty();

                // Ocultar el mensaje de error si estaba visible
                $mensaje.hide();

                // Bloque para llenar la tabla de inventario con los datos obtenidos del servidor
                // each es una función de jQuery que itera sobre cada elemento de un array o un objeto
                // su estructura es $.each(array, function(index, value) { ... });
                // En este caso, se usa el parámetro '_' para indicar que no se necesita el índice del elemento, solo el valor (equipo)
                $.each(resumen.Inventario, function (_, equipo) {
                    // Crear una nueva fila para la tabla de inventario
                    var $fila = $("<tr>");
                    // Agregar celdas a la fila con los datos del equipo
                    agregarCelda($fila, equipo.Nombre);
                    agregarCelda($fila, equipo.CantidadTotal);
                    agregarCelda($fila, equipo.CantidadPrestada);
                    agregarCelda($fila, equipo.CantidadDisponible);
                    // Agregar la fila completa a la tabla de inventario
                    $tablaInventario.append($fila);
                });
                // Verificar si no hay préstamos registrados y mostrar un mensaje en la tabla de préstamos
                if (resumen.Prestamos.length === 0) {
                    $tablaPrestamos.append(
                        '<tr><td colspan="8">Todavía no hay préstamos registrados.</td></tr>'
                    );
                    return;
                }
                // Bloque para llenar la tabla de préstamos con los datos obtenidos del servidor
                $.each(resumen.Prestamos, function (_, prestamo) {
                    // Se crea una nueva fila para la tabla de préstamos
                    var $fila = $("<tr>");
                    // Se agregan celdas a la fila con los datos del préstamo
                    agregarCelda($fila, prestamo.Id);
                    agregarCelda($fila, prestamo.NombreEquipo);
                    agregarCelda($fila, prestamo.NombreSolicitante);
                    agregarCelda($fila, prestamo.Area);
                    agregarCelda($fila, prestamo.Motivo);
                    agregarCelda($fila, prestamo.FechaPrestamo);
                    agregarCelda($fila, prestamo.FechaPrevistaDevolucion);
                    agregarCelda($fila, prestamo.Estado);
                    // Se agrega la fila completa a la tabla de préstamos
                    $tablaPrestamos.append($fila);
                });
            })
            // Manejo de errores en caso de que la solicitud Ajax falle
            .fail(function (xhr) {
                console.error("Falló la consulta Ajax:", xhr.status, xhr.responseText);
                mostrarError("No fue posible cargar el inventario y los préstamos.");
            });
        });
    </script>
</asp:Content>
