﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoiceCreation.aspx.cs" Inherits="InvoiceMgmt.InvoiceCreation" %>

<%@ Register Src="~/NavBar.ascx" TagPrefix="uc" TagName="NavBar" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Invoice Creation</title>
    <link rel="stylesheet" href="css/Invoice.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>

    <script  type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            const addButton = document.getElementById('addRowButton');
            const tableBody = document.querySelector('table tbody');
            const subTotalInput = document.querySelector('.subtotal');
            const Net_Total = document.querySelector('.netTotal');
            const sgstInput = document.querySelector('.sgst');
            const cgstInput = document.querySelector('.cgst');

            if (addButton) {
                addButton.addEventListener('click', function () {
                    // Create a new row and cells
                    const newRow = document.createElement('tr');
                    newRow.innerHTML = `
                        <td><input type="text" class="form-control form-control-sm itemName" placeholder="Item Name" /></td>
                        <td><input type="number" class="form-control form-control-sm quantity" placeholder="Quantity" /></td>
                        <td><input type="number" class="form-control form-control-sm price" placeholder="Price" /></td>
                        <td><input type="text" class="form-control form-control-sm amount" placeholder="Amount" readonly /></td>
                        <td><button class="btn btn-danger btn-sm removeRowButton"><i class="fas fa-trash-alt"></i></button></td>
                        <td></td>
                    `;
                    tableBody.appendChild(newRow);

                    // Add event listeners to the new row's inputs
                    const quantityInput = newRow.querySelector('.quantity');
                    const priceInput = newRow.querySelector('.price');
                    const amountInput = newRow.querySelector('.amount');

                    quantityInput.addEventListener('input', updateAmount);
                    priceInput.addEventListener('input', updateAmount);

                    newRow.querySelector('.removeRowButton').addEventListener('click', function () {
                        newRow.remove();
                        updateSubTotal();
                    });

                    function updateAmount() {
                        // Calculate the amount when either quantity or price changes
                        const quantity = parseFloat(quantityInput.value) || 0;
                        const price = parseFloat(priceInput.value) || 0;
                        const amount = (quantity * price).toFixed(2);
                        amountInput.value = amount;
                        updateSubTotal();

                    }
                });
            } else {
                console.error("Add Row button not found.");
            }

            function updateSubTotal() {
                console.log("updateSubTotal called");
                let subTotal = 0;
                const amounts = document.querySelectorAll('.amount');
                amounts.forEach(amountField => {
                    const amount = parseFloat(amountField.value) || 0;
                    subTotal += amount;
                });
                if (subTotalInput) {
                    console.log("updateSubTotal called");

                    subTotalInput.value = subTotal.toFixed(2);
                }
                updateNetTotal();
            }
            function updateNetTotal() {
                let subTotal = parseFloat(subTotalInput.value) || 0;
                let sgst = parseFloat(sgstInput.value) || 0;
                let cgst = parseFloat(cgstInput.value) || 0;

                // Calculate SGST and CGST based on the subtotal
                let sgstAmount = (subTotal * sgst) / 100;
                let cgstAmount = (subTotal * cgst) / 100;

                // Calculate the net total
                let netTotal = subTotal + sgstAmount + cgstAmount;
                Net_Total.value = netTotal.toFixed(2);
            }
            // Add event listeners to SGST and CGST inputs
            sgstInput.addEventListener('input', updateNetTotal);
            cgstInput.addEventListener('input', updateNetTotal);
        });


        $(document).ready(function () {
            // Call Web Method to get dropdown items
            $.ajax({
                type: "POST",
                url: "WebService.asmx/GetCustomeNameByGstNo",
                contentType: "application/json; charset=utf-8", // Correct content type
                dataType: "json", // Expecting JSON response
                success: function (response) {
                    // The response from the Web Method will be wrapped in a `d` property
                    var items = response.d; // Directly use response.d if it's already an array

                    // Check if items is an array
                    if (Array.isArray(items)) {
                        console.log(items);

                        var dropdownMenu = $('#customerDropdown');
                        console.log(dropdownMenu);

                        // Populate the dropdown menu
                        dropdownMenu.empty();
                        $.each(items, function (index, item) {
                            var option = `<option value="${item}">${item}</option>`;
                            dropdownMenu.append(option);
                        });
                    } else {
                        console.error("Unexpected response format:", items);
                    }
                },
                error: function (error) {
                    console.log("Error:", error);
                }
            });
        });
        function clearForm() {
            document.getElementById('invoiceForm').reset();
        }
        function invoicebtn_Click() {
            console.log('invoicebtn_Click called');
            var customerName = document.getElementById('customerDropdown').value;
            var itemNames = document.querySelectorAll('.itemName');
            var quantities = document.querySelectorAll('.quantity');
            var prices = document.querySelectorAll('.price');
            var amounts = document.querySelectorAll('.amount');
            var subtotal = document.querySelector('.subtotal').value;
            var sgst = document.querySelector('.sgst').value;
            var cgst = document.querySelector('.cgst').value;
            var netamount = document.querySelector('.netTotal').value;
            console.log('TotalAmt', amounts);

            var items = [];
            for (var i = 0; i < itemNames.length; i++) {
                items.push({
                    ItemName: itemNames[i].value,
                    Quantity: quantities[i].value,
                    Price: prices[i].value,
                    Amount: amounts[i].value
                });
            }

            var invoice = {
                CustomerName: customerName,
                SubTotal: subtotal,
                SgstRate: sgst,
                CgstRate: cgst,
                TotalAmt: netamount,
                Details: items
            };
            console.log(invoice);

            $.ajax({
                type: "POST",
                url: "WebService.asmx/BindInvoice",
                data: JSON.stringify({ invoiceRequest: invoice }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "Created") {
                        alert("Invoice Created Successfully");
                        clearForm();
                    } else {
                        console.log(response.d);
                        alert("Something went wrong, Please try again!!");
                    }
                },
                error: function (error) {
                    console.log(error);
                    alert("Something went wrong, Please try again!!");
                }
            });
        }

    </script>
</head>
<body>
    <div id="wrapper">
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
                    <form runat="server" id="invoiceForm">
                        <main class="py-6 bg-surface-secondary">
                            <div class="container-fluid">
                                <div class="card shadow border-0 mb-7">
                                    <div class="card-header bg-white">
                                        <h5 class="mb-3 mt-2">Invoice Creation</h5>
                                    </div>
                                    <br />
                                    <div class="d-flex align-items-center gap-5">
                                        <div class="btn-group h-10 w-25 btn-sm text-dark d-flex align-items-center shadow-none" style="margin-left: 21px;background-color: #f5f9fc">
                                            <select id="customerDropdown" style="background-color: #f5f9fc">
                                                <!-- Options will be populated here -->
                                            </select>
                                        </div>
                                        <button
                                            id="addRowButton" type="button"
                                            class="btn h-10 w-25 btn-sm text-dark d-flex align-items-center border-1 shadow-none"
                                            style="background-color: #f5f9fc">
                                            <i class="bi bi-plus"></i>
                                            <span class="ms-1">Add Row</span>
                                        </button>
                                    </div>
                                    <br />
                                    <div class="table-responsive">
                                        <table class="table table-hover table-nowrap">
                                            <thead class="thead-light">
                                                <tr>
                                                    <th scope="col">Item Name</th>
                                                    <th scope="col">Quantity</th>
                                                    <th scope="col">Price</th>
                                                    <th scope="col">Amount</th>
                                                    <th></th>
                                                    <th></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <!-- Rows will be added here dynamically -->
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="card-footer border-0 mb-3 bg-white">
                                        <div class=" card shadow" style="width:500px">
                                            <div class="d-flex justify-content-between mb-3 px-5 py-3" style="background-color: #f5f9fc">
                                                <div class="col-3">
                                                    Sub Total
                                                    <br />
                                                </div>
                                                <div class="col-3 w-25">
                                                    <input class="subtotal form-control form-control-sm text-end"  value="" />
                                                </div>
                                            </div>
                                            <div class="row d-flex justify-content-between mb-3 px-5 py-1">
                                                <div class="col-3">
                                                    SGST (%)
                                                    <br />
                                                </div>
                                                <div class="col-3 w-25">
                                                    <input class="form-control form-control-sm text-end sgst" value=""  />
                                                </div>
                                            </div>
                                            <div class="row d-flex justify-content-between mb-3 px-5 py-1">
                                                <div class="col-3">
                                                    CGST (%)
                                                    <br />
                                                </div>
                                                <div class="col-3">
                                                    <input class="form-control form-control-sm text-end cgst" value=""  />
                                                </div>
                                            </div>
                                            <div class="d-flex justify-content-between mb-3 px-5 py-3" style="background-color: #f5f9fc">
                                                <div class="">
                                                    Total Amount (₹)
                                                    <br />
                                                </div>
                                                <div class="">
                                                    <input class="form-control form-control-sm text-end netTotal" value="" readonly />
                                                </div>
                                            </div>
                                            <div class="d-flex justify-content-between px-5 py-3">
                                                <div class="">
                                                    <button class="btn btn-secondary btn-sm text-dark d-flex align-items-center border-1 border-white me-2 shadow-none" onclick="invoicebtn_Click();" type="button">
                                                        <span class="ms-1">Submit</span>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </main>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        
    </script>

</body>
</html>
