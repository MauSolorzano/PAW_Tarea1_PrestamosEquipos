<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegistrarPrestamo.aspx.cs" Inherits="PAW_Tarea1_PrestamosEquipos.RegistrarPrestamo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <h1>Registrar préstamo</h1>
        <p class="lead">Complete los datos para solicitar un equipo de oficina.</p>

        <div class="row">
            <div class="col-md-8">

                <div class="form-group">
                    <label for="dlEquipo">Equipo</label>
                    <select id="dlEquipo" class="form-control" required>
                        <option value="">Seleccione un equipo</option>
                        <option value="Laptop">Laptop</option>
                        <option value="Proyector">Proyector</option>
                        <option value="Tablet">Tablet</option>
                        <option value="Cámara">Cámara</option>
                        <option value="Audífonos">Audífonos</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="txtSolicitante">Nombre de la persona solicitante</label>
                    <input id="txtSolicitante" type="text" class="form-control"
                        minlength="3" maxlength="80" required />
                </div>

                <div class="form-group">
                    <label for="dlArea">Área o departamento</label>
                    <select id="dlArea" class="form-control" required>
                        <option value="">Seleccione un área</option>
                        <option value="Administración">Administración</option>
                        <option value="Recursos Humanos">Recursos Humanos</option>
                        <option value="Tecnología">Tecnología</option>
                        <option value="Finanzas">Finanzas</option>
                        <option value="Operaciones">Operaciones</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="txtMotivo">Motivo del préstamo</label>
                    <textarea id="txtMotivo" class="form-control" rows="3"
                        minlength="10" maxlength="250" required></textarea>
                </div>

                <div class="form-group">
                    <label for="txtFechaPrestamo">Fecha del préstamo</label>
                    <input id="txtFechaPrestamo" type="date" class="form-control" required />
                </div>

                <div class="form-group">
                    <label for="txtFechaDevolucion">Fecha prevista de devolución</label>
                    <input id="txtFechaDevolucion" type="date" class="form-control" required />
                </div>

                <div id="mensajeRegistro" role="status" aria-live="polite"
                    class="alert" style="display: none;">
                </div>

                <button id="btnRegistrar" type="button" class="btn btn-primary">
                    Registrar préstamo
           
                </button>

                <a href="Default.aspx" class="btn btn-default">Menú principal</a>
            </div>
        </div>
    </div>
    <script type="text/javascript">

       $(function () {

        // Referencias a los elementos del formulario HTML
        var $fechaPrestamo = $("#txtFechaPrestamo");
        var $fechaDevolucion = $("#txtFechaDevolucion");
        var $mensaje = $("#mensajeRegistro");
        var $boton = $("#btnRegistrar");

        // Función para obtener la fecha actual en formato ISO (YYYY-MM-DD)
        function fechaLocalISO() {
            var hoy = new Date();
            var mes = hoy.getMonth() + 1;
            var dia = hoy.getDate();

            return hoy.getFullYear() + "-" +
                (mes < 10 ? "0" + mes : mes) + "-" +
                (dia < 10 ? "0" + dia : dia);
        }

        // Guardar la fecha actual en una variable para usarla en las validaciones
           var hoy = fechaLocalISO();

        // Establecer la fecha máxima para los campos de fecha de préstamo 
           $fechaPrestamo.attr("max", hoy);

        // Poner la fecha de hoy como valor predeterminado en el campo de fecha de préstamo si está vacío
        if (!$fechaPrestamo.val()) {
            $fechaPrestamo.val(hoy);
        }

        // Establecer la fecha mínima para el campo de fecha de devolución, no puede ser anterior a la fecha de préstamo 
        $fechaDevolucion.attr("min", $fechaPrestamo.val());
           
        // Si se cambia la fecha de préstamo, actualizar la fecha mínima de devolución y limpiar el campo si es necesario
        $fechaPrestamo.on("change", function () {
            $fechaDevolucion.attr("min", this.value);

            if ($fechaDevolucion.val() &&
                $fechaDevolucion.val() < this.value)
            {
                $fechaDevolucion.val("");
            }
        });

        // Función para mostrar mensajes de éxito o error en el formulario
        function mostrarMensaje(texto, tipo) {
            $mensaje
                .removeClass("alert-success alert-danger")
                .addClass("alert-" + tipo)
                .text(texto)
                .show();
        }

        // Función para validar los campos del formulario antes de enviarlo
           function validarFormulario() {

            // Obtener los valores de los campos del formulario
            var equipo = $("#dlEquipo").val();
            var solicitante = $("#txtSolicitante").val().trim();
            var area = $("#dlArea").val();
            var motivo = $("#txtMotivo").val().trim();
            var fechaPrestamo = $fechaPrestamo.val();
            var fechaDevolucion = $fechaDevolucion.val();
            // Expresión regular para validar nombres
            var patronNombre = /^[\p{L}][\p{L} .'-]*$/u;

            // Enviar un mensaje de error si alguni de los campos esta vacío
            if (!equipo || !solicitante || !area || !motivo ||
                !fechaPrestamo || !fechaDevolucion) {
                mostrarMensaje("Es necesario completar todos los campos.", "danger");
                return false;
            }
            // Validar el nombre del solicitante con la expresión regular y la longitud. Si algo falla mostrar el mensaje 
            if (solicitante.length < 3 || solicitante.length > 80 ||
                !patronNombre.test(solicitante)) {
                mostrarMensaje(
                    "El nombre debe tener entre 3 y 80 caracteres y usar letras, espacios, puntos, apóstrofes o guiones.",
                    "danger"
                );
                return false;
            }
            // Validar el motivo del préstamo con la longitud. Si algo falla mostrar el mensaje
            if (motivo.length < 10 || motivo.length > 250) {
                mostrarMensaje(
                    "El motivo debe tener entre 10 y 250 caracteres.",
                    "danger"
                );
                return false;
            }
            // Validar que la fecha del prestamo no sea futura. Si algo falla mostrar el mensaje
            if (fechaPrestamo > hoy) {
                mostrarMensaje(
                    "La fecha del préstamo no puede ser futura.",
                    "danger"
                );
                return false;
            }
            // Validar que la fecha de devolución no sea anterior a la fecha del préstamo. Si algo falla mostrar el mensaje
            if (fechaDevolucion < fechaPrestamo) {
                mostrarMensaje(
                    "La devolución debe ser igual o posterior a la fecha del préstamo.",
                    "danger"
                );
                return false;
            }
            // Si todo es correcto, retornar true
            return true;
        }

            // Al presionar el botón de registrar, validar el formulario y enviar los datos al servidor mediante Ajax
            $boton.on("click", function () {
            // Ocultar mensajes anteriores
            $mensaje.hide();

            // Validar el formulario antes de enviar los datos a través de la funcion validarFormulario. Si algo falla, retornar y no enviar los datos
            if (!validarFormulario()) {
                return;
            }
            // Se desabilita el botón para evitar múltiples envíos mientras se procesa la solicitud
            $boton.prop("disabled", true);

            // Enviar los datos del formulario al servidor mediante una solicitud Ajax POST sin recargar la página.
            // Se envían los datos en formato JSON y se espera una respuesta JSON del servidor. 
            // Se manejan los casos de éxito y error para mostrar mensajes al usuario.
               $.ajax({
                // Tipo de solicitud 
                   type: "POST",
                // URL del método del servidor que procesará la solicitud
                   url: "RegistrarPrestamo.aspx/Registrar",
                // Datos del formulario convertidos a JSON
                data: JSON.stringify({
                    nombreEquipo: $("#dlEquipo").val(),
                    nombreSolicitante: $("#txtSolicitante").val().trim(),
                    area: $("#dlArea").val(),
                    motivo: $("#txtMotivo").val().trim(),
                    fechaPrestamo: $fechaPrestamo.val(),
                    fechaPrevistaDevolucion: $fechaDevolucion.val()
                }),
                // Indicar en que formato se están enviando los datos
                contentType: "application/json; charset=utf-8",
                // Indicar en que formato se espera la respuesta del servidor
                dataType: "json"
               })
            // Si el servidor responde correctamente, se procesa la respuesta y se muestra un mensaje al usuario. 
            .done(function (respuesta) {
                var resultado = respuesta.d;

                mostrarMensaje(
                    resultado.Mensaje,
                    resultado.Exito ? "success" : "danger"
                );

                // Si el registro fue exitoso, se limpian los campos del formulario.
                if (resultado.Exito) {
                    $("#dlEquipo").val("");
                    $("#txtSolicitante").val("");
                    $("#dlArea").val("");
                    $("#txtMotivo").val("");
                    $fechaPrestamo.val(hoy);
                    $fechaDevolucion.val("");
                    $fechaDevolucion.attr("min", hoy);
                }
            })
            // Si la solicitud Ajax falla, se muestra un mensaje de error en la consola 
                .fail(function (xhr, estado, error) {
                    console.error("Falló la solicitud Ajax:", {
                        estado: estado,
                        error: error,
                        codigoHTTP: xhr.status,
                        respuesta: xhr.responseText
                    });
                    // Además, se muestra un mensaje de error al usuario indicando que la solicitud falló y que revise la consola del navegador para más detalles.
                    mostrarMensaje(
                        "La solicitud falló (HTTP " + xhr.status +
                        "). Revisa la pestaña Console del navegador.",
                        "danger"
                    );
                })
             // Finalmente, independientemente de si la solicitud Ajax fue exitosa o fallida, 
             // se vuelve a habilitar el botón de registrar para permitir al usuario intentar nuevamente si es necesario.
            .always(function () {
                $boton.prop("disabled", false);
            });
        });
    });
</script>
</asp:Content>
