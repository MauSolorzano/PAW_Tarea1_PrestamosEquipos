<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Devolucion.aspx.cs" Inherits="PAW_Tarea1_PrestamosEquipos.Devolucion" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div>
    <h1>Procesar devolución</h1>
    <p class="lead">Marca como devueltos los equipos que ya fueron entregados.</p>

    <p>
        <a href="Default.aspx" class="btn btn-default">&larr; Menú principal</a>
    </p>

    <div id="mensajeDevolucion" role="status" aria-live="polite"
         class="alert" style="display: none;"></div>

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
</asp:Content>
