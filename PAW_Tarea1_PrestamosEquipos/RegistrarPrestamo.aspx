<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegistrarPrestamo.aspx.cs" Inherits="PAW_Tarea1_PrestamosEquipos.RegistrarPrestamo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <div class="container">
    <h1>Registrar préstamo</h1>
    <p class="lead">Complete los datos para solicitar un equipo de oficina.</p>

    <div class="row">
        <div class="col-md-8">

            <div class="form-group">
                <label for="ddlEquipo">Equipo</label>
                <select id="ddlEquipo" class="form-control" required>
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
                <label for="ddlArea">Área o departamento</label>
                <select id="ddlArea" class="form-control" required>
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
                 class="alert" style="display: none;"></div>

            <button id="btnRegistrar" type="button" class="btn btn-primary">
                Registrar préstamo
            </button>

            <a href="Default.aspx" class="btn btn-default">Menú principal</a>
        </div>
    </div>
</div>
</asp:Content>
