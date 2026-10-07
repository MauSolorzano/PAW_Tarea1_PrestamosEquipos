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
                    <th>Equipo</th>
                    <th>Solicitante</th>
                    <th>Área</th>
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
         class="alert" style="display: none;"></div>
</div>
</asp:Content>
