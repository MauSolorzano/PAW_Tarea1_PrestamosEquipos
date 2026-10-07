<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PAW_Tarea1_PrestamosEquipos._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main class="py-4">
        <div class="mb-4">
            <h1>Préstamo de equipos de oficina</h1>
            <p class="lead">Selecciona una opción para continuar.</p>
        </div>

        <section id="menuPrincipal" class="row g-4" aria-label="Menú principal">
            <div class="col-md-4">
                <div class="card h-100">
                    <div class="card-body d-flex flex-column">
                        <h2 class="card-title h4">Registrar préstamo</h2>
                        <p class="card-text">
                            Registra quién solicita un equipo y cuándo lo devolverá.
                   
                        </p>
                        <a href="RegistrarPrestamo.aspx" class="btn btn-primary mt-auto">Registrar
                    </a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card h-100">
                    <div class="card-body d-flex flex-column">
                        <h2 class="card-title h4">Consultar préstamos</h2>
                        <p class="card-text">
                            Consulta los préstamos registrados y las unidades disponibles.
                   
                        </p>
                        <a href="ConsultarPrestamos.aspx" class="btn btn-primary mt-auto">Consultar
                    </a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card h-100">
                    <div class="card-body d-flex flex-column">
                        <h2 class="card-title h4">Procesar devolución</h2>
                        <p class="card-text">
                            Marca como devuelto un equipo que actualmente está prestado.
                   
                        </p>
                        <a href="Devolucion.aspx" class="btn btn-primary mt-auto">Procesar devolución
                    </a>
                    </div>
                </div>
            </div>
        </section>
    </main>

</asp:Content>

