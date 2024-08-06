<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerCreation.aspx.cs" Inherits="InvoiceMgmt.CustomerCreation" %>

<%@ Register Src="~/NavBar.ascx" TagPrefix="uc" TagName="NavBar" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="css/Customer.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
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
                                <div class="card-header">
                                    <h5 class="mb-0">Customer Creation</h5>
                                </div>
                                <div class="container" style="margin-left: -20px">
                                    <form class="p-md-5" style="margin-left: 20px">
                                        <div class="btn-group gap-3">
                                            <div class="form-floating mb-3">
                                                <input type="text" id="txtfname" class="form-control" value="" />
                                                <span style="color: #b8635f"></span>
                                                <label class="form-label" for="form4Example1">First Name</label>
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input type="text" id="txtlname" class="form-control" value="" />
                                                <label class="form-label" for="form4Example2">Last Name</label>
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input type="text" id="txtphone" class="form-control" value="" />
                                                <label class="form-label" for="form4Example2">Phone No.</label>
                                            </div>
                                        </div>
                                        <div class="form-floating mb-3" >
                                            <input type="text" id="txtaddress" class="form-control" value="" />
                                            <label class="form-label" for="form4Example2">Address</label>
                                        </div>
                                        <div class="btn-group gap-3">
                                            <div class="form-floating mb-3">
                                                <input type="text" id="txtstate" class="form-control" value="" />
                                                <label class="form-label" for="form4Example2">State</label>
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input type="text" id="txtcity" class="form-control" value="" />
                                                <label class="form-label" for="form4Example2">City</label>
                                            </div>
                                        </div>
                                        <br />
                                        <div class="btn-group gap-3">
                                            <div class="form-floating mb-3">
                                                <input type="text" id="txtemail" class="form-control" value="" />
                                                <span style="color: #b8635f"></span>
                                                <label class="form-label" for="form4Example2">Email Address</label>
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input type="text" id="txtpincode" class="form-control" value="" />
                                                <label class="form-label" for="form4Example2">PinCode</label>
                                            </div>
                                        </div>
                                        <div class="card-footer border-0 mb-3 bg-white" style="margin-left: -20px">
                                            <button class="btn btn-secondary btn-sm d-flex align-items-center me-2  shadow-none text-dark" type="button" onclick="customerbtn_Click();">
                                                <span class="ms-1">Submit</span>
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
            </div>
        </div>
    </div>

     <script type="text/javascript">
         function customerbtn_Click() {
             console.log('customerbtn_Click called');
             var fname = document.getElementById('txtfname').value;
             var lname = document.getElementById('txtlname').value;
             var phone = document.getElementById('txtphone').value;
             var address = document.getElementById('txtaddress').value;
             var state = document.getElementById('txtstate').value;
             var city = document.getElementById('txtcity').value;
             var email = document.getElementById('txtemail').value;
             var pincode = document.getElementById('txtpincode').value;
             $.ajax({
                 type: "POST",
                 url: "WebService.asmx/CreateCustomer",
                 data: JSON.stringify({
                     customers: {
                         FirstName: fname,
                         LastName: lname,
                         AddressLine: address,
                         City: city,
                         States: state,
                         Pincode: pincode,
                         Phone: phone,
                         EmailId: email
                     }
                 }),
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 success: function (response) {
                     if (response.d == "Created") {
                         alert("Customer Created Successfully");
                     }
                     else {
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
</body>
</html>
