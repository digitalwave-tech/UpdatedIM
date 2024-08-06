<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NavBar.ascx.cs" Inherits="InvoiceMgmt.NavBar" %>
<link rel="stylesheet" href="css/navbar.css" />
<link rel="stylesheet" href="css/fontawesome-free-5.15.4-web/css/all.min.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<!-- Dashboard -->
<div class="d-flex flex-column flex-lg-row h-lg-full bg-surface-secondary" style="width:300px">
    <!-- Vertical Navbar -->
    <nav class="navbar show navbar-vertical h-lg-screen navbar-expand-lg px-0 py-3 navbar-light bg-white border-bottom border-bottom-lg-0 border-end-lg" id="navbarVertical">
        <div class="container-fluid">
            <!-- Toggler -->
            <button class="navbar-toggler ms-n2" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarCollapse" aria-controls="sidebarCollapse" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <!-- Brand -->
            <a class="navbar-brand py-lg-2 mb-lg-5 px-lg-6 me-0" href="#">
                <img src="Image/logo-png.png" alt="..." style="width:180px; height:60px"/>
            </a>
            <!-- User menu (mobile) -->
            <%--<div class="navbar-user d-lg-none">
                <!-- Dropdown -->
                <div class="dropdown">
                    <!-- Toggle -->
                    <a href="#" id="sidebarAvatar" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <div class="avatar-parent-child">
                            <img alt="Image Placeholder" src="https://images.unsplash.com/photo-1548142813-c348350df52b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=3&w=256&h=256&q=80" class="avatar avatar- rounded-circle">
                            <span class="avatar-child avatar-badge bg-success"></span>
                        </div>
                    </a>
                    <!-- Menu -->
                    <div class="dropdown-menu dropdown-menu-end" aria-labelledby="sidebarAvatar">
                        <a href="#" class="dropdown-item">Profile</a>
                        <a href="#" class="dropdown-item">Settings</a>
                        <a href="#" class="dropdown-item">Billing</a>
                        <hr class="dropdown-divider">
                        <a href="#" class="dropdown-item">Logout</a>
                    </div>
                </div>
            </div>--%>
            <!-- Collapse -->
            <div class="collapse navbar-collapse" id="sidebarCollapse">
                <!-- Navigation -->
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="Dashboard.aspx">
                            <i class="bi bi-house h3"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="InvoiceCreation.aspx">
                            <i class="bi bi-bar-chart h3"></i> Invoice
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="CustomerCreation.aspx">
                            <i class="bi bi-person-plus h3"></i> Customer
                        </a>
                    </li>
                   
                </ul>
                
                <!-- Push content down -->
                <div class="mt-auto"></div>
                <!-- User (md) -->
                <ul class="navbar-nav">
                    
                    <li class="nav-item">
                        <a class="nav-link" href="Login.aspx">
                            <i class="bi bi-box-arrow-left h3"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
   
</div>
<script src="javascript/navbar.js"></script>

