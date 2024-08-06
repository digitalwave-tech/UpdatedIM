<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="InvoiceMgmt.Login" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <title>Invoice Management</title>
    <link rel="stylesheet" href="css/login.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head> 
<body>
    <div class="container" id="container">
        <div class="form-container sign-up">
            <form>
                <%--<asp:ScriptManager ID="ScriptManager1" runat="server" />--%>
                <h3>Create Account</h3>
                <input type="text" id="cmpname" placeholder="Company Name">
                <input type="text" id="addresline" placeholder="Address Line">
                <input type="text" id="city" placeholder="City">
                <input type="text" id="state" placeholder="State">
                <input type="text" id="pincode" placeholder="Pincode">
                <input type="text" id="phone" placeholder="Phone">
                <input type="email" id="email" placeholder="Email">
                <input type="text" id="gstno" placeholder="GST No">
                <input type="text" id="username" placeholder="Username">
                <input type="password" id="password" placeholder="Password">
                <button type="button" onclick="registerbtn_Click()">Sign Up</button>
            </form>
        </div>

        <div class="form-container sign-in">
            <form >
                <h1>Sign In</h1>
                <input type="text" id="uname" placeholder="Username">
                <input type="password" id="passwd" placeholder="Password">
                <a href="#">→ Forget Your Password? ←</a>
                <button type="button" onclick="loginbtn_Click()">Sign In</button>
            </form>
        </div>
        <div class="toggle-container">
            <div class="toggle">
                <div class="toggle-panel toggle-left">
                    <h1>Welcome Back!</h1>
                    <p>Enter your personal details to use all of site features</p>
                    <button class="hidden" id="login">Sign In</button>
                </div>
                <div class="toggle-panel toggle-right">
                    <h1>Hello, Friend!</h1>
                    <p>Register with your personal details to use all of site features</p>
                    <button class="hidden" id="register">Sign Up</button>
                </div>
            </div>
        </div>
    </div>
    <script src="script.js"></script>
    <script type="text/javascript">
        function registerbtn_Click() {
            console.log('registerbtn_Click called');
            var cmpname = document.getElementById('cmpname').value;
            var addresline = document.getElementById('addresline').value;
            var city = document.getElementById('city').value;
            var state = document.getElementById('state').value;
            var pincode = document.getElementById('pincode').value;
            var phone = document.getElementById('phone').value;
            var email = document.getElementById('email').value;
            var gstno = document.getElementById('gstno').value;
            var username = document.getElementById('username').value;
            var password = document.getElementById('password').value;

            $.ajax({
                type: "POST",
                url: "WebService.asmx/CreateAccount",
                data: JSON.stringify({
                    customer: {
                        CompanyName: cmpname,
                        AddressLine: addresline,
                        City: city,
                        States: state,
                        Pincode: pincode,
                        Phone: phone,
                        EmailId: email,
                        GstNo: gstno,
                        username: username,
                        password: password
                    }
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d == "Created") {
                        window.location.href = "/Login.aspx";
                    }
                    else if (response.d== "Company Name already registered")
                    {
                        console.log(response);
                        alert(response.d);

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

        function loginbtn_Click() {
            console.log('loginbtn_Click called');
            var username_ = document.getElementById('uname').value;
            var password_ = document.getElementById('passwd').value;

            $.ajax({
                type: "POST",
                url: "WebService.asmx/Login",
                data: JSON.stringify({ username: username_, password:password_ }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d == true) {
                        window.location.href = "/Dashboard.aspx";
                    }
                    else if (response.d == false) {
                        console.log(response.d);
                        alert("Username or Password is invalid");

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
