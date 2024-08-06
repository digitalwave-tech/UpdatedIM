﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="InvoiceMgmt.Dashboard" %>

<%@ Register Src="~/NavBar.ascx" TagPrefix="uc" TagName="NavBar" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="css/dashboard.css"/>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="wrapper">
            <!-- Main content -->
            <uc:NavBar ID="NavBar1" runat="server" />
        <div id="page-content-wrapper">
        <div class="container-content">
        <div class="h-screen flex-grow-1 overflow-y-lg-auto">
            <!-- Header -->
            <header class="bg-surface-primary border-bottom pt-6">
                <div class="container-fluid">
                    <div class="mb-npx">
                        <div class="row align-items-center mb-4">
                            <div class="col-sm-6 col-12 mb-4 mb-sm-0">
                                <!-- Title -->
                                <h1 class="h2 mb-0 ls-tight">Invoice Management</h1>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <!-- Main -->
            <main class="py-6 bg-surface-secondary">
                <div class="container-fluid">
                    <div class="card shadow border-0 mb-7">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">View Invoice</h5>
                            <div class="d-flex gap-1 h-12">
                                    <input type="text" id="searchInput" class="form-control form-control-sm" placeholder="Search..." list="customerSuggestions" />
                                    <datalist id="customerSuggestions"></datalist>
                                </div>
                        </div>
                        <div class="table-responsive">
                            <table id="invoiceTable" class="table table-hover table-nowrap">
                                <thead class="thead-light">
                                    <tr>
                                        <th scope="col"></th>
                                        <th scope="col">Invoice No</th>
                                        <th scope="col">Invoice Date</th>
                                        <th scope="col">Customer Name</th>
                                        <th scope="col">Amount</th>
                                        <th><button class="btn btn-sm btn-primary" id="downloadBtn">
                                                            <i class="bi bi-download"></i>
                                                        </button></th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                   <%-- data populate dynamically --%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
            </div>
        </div>
        </div>
    </form>
    <script type="text/javascript">
        
        $(document).ready(function () {
            $.ajax({
                type: "POST",
                url: "WebService.asmx/GetInvoices",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var invoices = response.d ? JSON.parse(response.d) : [];
                    var tbody = $('#invoiceTable tbody');
                    tbody.empty();
                    $.each(invoices, function (index, invoice) {
                        console.log(invoice.InvoiceDate);
                        var row = '<tr>' +
                            '<td><input type="checkbox" class="invoice-checkbox" data-id="' + invoice.InvoiceNo + '" /></td>' +
                            '<td>' + invoice.InvoiceNo + '</td>' +
                            '<td>' + invoice.InvoiceDate + '</td>' +
                            '<td>' + invoice.CustomerName + '</td>' +
                            '<td>' + invoice.NetAmt + '</td>' +
                            '<td>' + '</td>' +
                            '<td>' + '</td>' +
                            '</tr>';
                        tbody.append(row);
                    });
                },
                error: function (error) {
                    console.log("Error:", error);
                }
            });
        });

        //$('#downloadBtn').click(function (event) {
        //    event.preventDefault();
        //    console.log("doenloadbt clicked");
        //    var selectedInvoices = $('.invoice-checkbox:checked').map(function () {
        //        return $(this).data('id');
        //    }).get();

        //    if (selectedInvoices.length === 0) {
        //        alert("Please select at least one invoice.");
        //        return;
        //    }

        //    selectedInvoices.forEach(function (invoiceNo) {
        //        console.log(invoiceNo);
        //        console.log(JSON.stringify({ invoicenos: invoiceNo }));
        //        $.ajax({
        //            type: "POST",
        //            url: "WebService.asmx/GetInvoiceItemDetails",
        //            contentType: "application/json; charset=utf-8",
        //            data: JSON.stringify({ invoicenos: invoiceNo }),
        //            dataType: "json",
        //            success: function (response) {
        //                var invoiceDetails = response.d ? JSON.parse(response.d) : {};
        //                fetchInvoiceTemplateAndGeneratePDF(invoiceDetails);
        //            },
        //            error: function (error) {
        //                console.log("Error:", error);
        //            }
        //        });
        //        console.log("requestAPI"+data);
        //    });
        //});

        $('#downloadBtn').click(function (event) {
            event.preventDefault(); // Prevent the default form submission behavior

            console.log("downloadBtn clicked");
            var selectedInvoices = $('.invoice-checkbox:checked').map(function () {
                return $(this).data('id');
            }).get();

            if (selectedInvoices.length === 0) {
                alert("Please select at least one invoice.");
                return;
            }

            // Prepare the data to be sent as an array
            var dataToSend = { invoicenos: selectedInvoices };

            $.ajax({
                type: "POST",
                url: "WebService.asmx/GetInvoiceItemDetails",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(dataToSend),
                dataType: "json",
                success: function (response) {
                    console.log('Response from server:', response);
                    var invoiceDetails = response.d;
                    var sgstAmount = "";
                    var cgstAmount = "";

                    if (invoiceDetails.length > 0) {
                        var html = '<!DOCTYPE html><html><head><title>Invoice Details</title><style>table { border-collapse: collapse; } th, td { border: 1px solid #ddd; padding: 8px; }</style></head><body>';
                        html += '<div style="width:800px;margin-left:-80px" ><h2 style="text-align:center">' + invoiceDetails[0].companyDetails.companyName +'</h2></div>';
                        //html += '<table width="700px" border="1">';
                        html += '<div style="width:800px; margin-left:-80px"><h5 style="text-align:center">' + invoiceDetails[0].companyDetails.companyaddress + '</h5></div>';
                        html += '<div style="width:800px;margin-left:-80px"><h5 style="text-align:center">' + invoiceDetails[0].companyDetails.companycity+ ", " +invoiceDetails[0].companyDetails.companystate + '</h5></div>';
                        html += '<div style="width:800px;margin-left:-80px"><h5 style="text-align:center">Phone No: ' + invoiceDetails[0].companyDetails.companyphoneNo + '</h5></div>';
                        //html += '<tr><td>Company Email:</td><td>' + invoiceDetails[0].companyDetails.companyemail + '</td></tr>';
                        //html += '<tr><td>Company State:</td><td>' + invoiceDetails[0].companyDetails.companystate + '</td></tr>';
                        //html += '<tr><td>Company Pincode:</td><td>' + invoiceDetails[0].companyDetails.companypincode + '</td></tr>';

                        html += '<br>';
                        html += '<br>';

                        //html += '<tr><th colspan="2">Customer Details</th></tr>';
                        $.each(invoiceDetails[0].companyDetails.customerdetails, function (index, customer) {
                            html += '<div class="d-flex"  style="width:800px; justify-content:between">';
                            html += '<div style="margin-left:30px">';
                            html += '<p>To</p>';
                            html += '<p>' + customer.customername + '</p>';
                            html += '<p>' + customer.custoomeraddress + '</p>';
                            html += '<p>' + customer.customercity + ", " + customer.customerstate + '</p>';
                            html += '</div>';

                            var invNo = customer.itemDetails[0].invoiceNo;
                            var invDate = customer.itemDetails[0].invocieDate;

                            html += '<div style="margin-left:280px">';
                            html += '<p>Invoice No: ' + invNo + '</p>';
                            html += '<p>Invoice Date: ' + invDate + '</p>';

                          
                        
                            html += '</div>';
                            html += '</div>';
                        });

                            html += '<br>';
                            html += '<br>';

                            html += '<table width="700px" border="1">';
                            html += '<tr>';
                            html += '<th>Item Name</th>';
                            html += '<th>Quantity</th>';
                            html += '<th>Rate</th>';
                            html += '<th>Amount</th>';
                        html += '</tr>';
                        console.log(invoiceDetails[0].companyDetails.customerdetails[0].itemDetails);
                        $.each(invoiceDetails[0].companyDetails.customerdetails[0].itemDetails, function (index, item) {
                                html += '<tr>';
                                html += '<td>' + item.itemName + '</td>';
                                html += '<td>' + item.quantity + '</td>';
                                html += '<td>' + "₹" + item.price + '</td>';
                                html += '<td>' + "₹" + item.Amount + '</td>';
                                html += '</tr>';
                           });
                     
                        html += '</table>';

                        var subtotal = invoiceDetails[0].companyDetails.customerdetails[0].itemDetails[0].subtotalAmt;
                        var sgstRate = invoiceDetails[0].companyDetails.customerdetails[0].itemDetails[0].SgstRate;
                        var cgstRate = invoiceDetails[0].companyDetails.customerdetails[0].itemDetails[0].CgstRate;
                        sgstAmount = subtotal * sgstRate / 100;
                        cgstAmount = subtotal * cgstRate / 100;

                        html += '<div class="d-flex" style="margin-left:500px">';
                        html += '<div style="margin-left:2px">Sub Total </div>';
                        html += '<div style="margin-left:60px"> ' +"₹" + invoiceDetails[0].companyDetails.customerdetails[0].itemDetails[0].subtotalAmt + '</div>'
                        html += '</div>';
                        html += '<div class="d-flex" style="margin-left:500px">';
                        html += '<div style="margin-left:2px">SGST ' + invoiceDetails[0].companyDetails.customerdetails[0].itemDetails[0].SgstRate + "%" + ' </div>';
                        html += '<div style="margin-left:65px"> ' + "₹" + sgstAmount + '</div>'
                        html += '</div>';
                        html += '<div class="d-flex" style="margin-left:500px">';
                        html += '<div style="margin-left:2px">CGST ' + invoiceDetails[0].companyDetails.customerdetails[0].itemDetails[0].CgstRate + "%" + '</div>';
                        html += '<div style="margin-left:65px"> ' + "₹" +cgstAmount + '</div>'
                        html += '</div>';
                        html += '<br>';
                        html += '<div style="width:200px; background-color:black;margin-left:500px; height:60px">';
                        html += '<div style="margin-left:2px;"><h3 style="color:white;margin-top:5px; margin-left:10px">Total' + "        ₹" + invoiceDetails[0].companyDetails.customerdetails[0].itemDetails[0].netAmount + '</h3></div>';
                        html += '</div>';

                        html += '<br>';
                        html += '<br>';

                        html += '<div class="" style="width:2000px">';
                        html += '<div  style=""><i class="fa fa-fw fa-sm fa-envelope">' +invoiceDetails[0].companyDetails.companyemail + '</i></div>';
                        html += '<div  style=""><i class="fa fa-fw fa-sm fa-phone-volume">' +invoiceDetails[0].companyDetails.companyphoneNo + '</i></div>';
                        
                        html += '</div>';
                        
                        html += '</body></html>';

                        var div = document.createElement('div');
                        div.style.position = 'absolute';
                        div.style.left = '-9999px';
                        div.innerHTML = html;
                        document.body.appendChild(div);

                        try {
                            html2canvas(div).then(function (canvas) {
                                var imgData = canvas.toDataURL('image/png');
                                var doc = new jsPDF();
                                doc.addImage(imgData, 'PNG', 10, 10);
                                var pdf = doc.output('blob');

                                var link = document.createElement('a');
                                link.href = window.URL.createObjectURL(pdf);
                                link.download = 'invoice_details.pdf';
                                link.click();

                                document.body.removeChild(div); // Clean up the element after generating the PDF
                            });
                        } catch (error) {
                            console.error('Error generating PDF:', error);
                            document.body.removeChild(div); // Clean up the element in case of an error
                        }
                    } else {
                        console.error('No invoice details found in the response');
                    }
                },
                error: function (error) {
                    console.log("Error:", error);
                }
            });
        });

        var allCustomers = [];

        // Fetch all customers when the page loads
        $(document).ready(function () {
            $.ajax({
                type: 'POST',
                url: 'WebService.asmx/GetCustomeNameByGstNo',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (response) {
                    allCustomers = response.d; // Store all customers
                    updateCustomerSuggestions(); // Initial bind
                },
                error: function (xhr, status, error) {
                    console.error('Failed to fetch customers:', status, error);
                }
            });

            // Filter customers based on input
            $('#searchInput').on('input', function () {
                updateCustomerSuggestions();
            });

            // Handle customer selection
            $('#searchInput').on('change', function () {
                var selectedCustomer = $(this).val();
                if (selectedCustomer) {
                    fetchInvoices(selectedCustomer);
                }
                //else {
                //    fetchAllInvoices(); // Fetch all invoices if search box is cleared
                //}
            });

        });
       

        // Function to update the datalist based on input
        function updateCustomerSuggestions() {
            var searchTerm = $('#searchInput').val().toLowerCase();
            var suggestions = '';

            if (searchTerm != '') {
                // Filter the customers based on the search term
                var filteredCustomers = allCustomers.filter(function (customer) {
                    return customer.toLowerCase().startsWith(searchTerm);
                });

                // Populate the datalist
                filteredCustomers.forEach(function (customer) {
                    suggestions += '<option value="' + customer + '">';
                });

                $('#customerSuggestions').html(suggestions);
                // Fetch all invoices if search box is cleared
            }
            else {
                console.log("serach empty!1");
                $.ajax({
                    type: "POST",
                    url: "WebService.asmx/GetInvoices",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var invoices = response.d ? JSON.parse(response.d) : [];
                        var tbody = $('#invoiceTable tbody');
                        tbody.empty();
                        $.each(invoices, function (index, invoice) {
                            console.log(invoice.InvoiceDate);
                            var row = '<tr>' +
                                '<td><input type="checkbox" class="invoice-checkbox" data-id="' + invoice.InvoiceNo + '" /></td>' +
                                '<td>' + invoice.InvoiceNo + '</td>' +
                                '<td>' + invoice.InvoiceDate + '</td>' +
                                '<td>' + invoice.CustomerName + '</td>' +
                                '<td>' + invoice.NetAmt + '</td>' +
                                '<td>' + '</td>' +
                                '<td>' + '</td>' +
                                '</tr>';
                            tbody.append(row);
                        });
                    },
                    error: function (error) {
                        console.log("Error:", error);
                    }
                });
            }
        }
       
        function fetchInvoices(customerName) {
            $.ajax({
                type: 'POST',
                url: 'WebService.asmx/GetInvoicesByCustomer',
                data: JSON.stringify({ customerName: customerName }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (response) {
                    updateInvoiceTable(response.d); // Update the table with invoices
                    console.log(response);
                },
                error: function (xhr, status, error) {
                    console.error('Failed to fetch invoices:', status, error);
                }
            });
        }

        // Function to update the invoice table
        function updateInvoiceTable(invoices) {

            console.log("updateInvoiceTable" + invoices);
            var tableBody = $('#invoiceTable tbody');
            tableBody.empty(); // Clear existing rows

            invoices.forEach(function (invoice) {
                var formattedDate = new Date(invoice.InvoiceDate).toLocaleDateString('en-GB');
                console.log("date" + formattedDate);

                var row = '<tr>' +
                    '<td><input type="checkbox" class="invoice-checkbox" data-id="' + invoice.InvoiceNo + '" /></td>' +
                    '<td>' + invoice.InvoiceNo + '</td>' +
                    '<td>' + formattedDate + '</td>' +
                    '<td>' + invoice.CustomerName + '</td>' +
                    '<td>' + invoice.TotalAmt + '</td>' +
                    '<td></td>' +
                    '<td></td>' +
                    '</tr>';
                tableBody.append(row);
            });
        }
      
    </script>

<%--<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.68/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.68/vfs_fonts.js"></script>--%>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.3.3/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.min.js"></script>
</body>
</html>