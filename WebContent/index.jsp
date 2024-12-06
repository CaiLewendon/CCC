<!DOCTYPE html>
<html>
<head>
    <title>Cai & Charlie's Car Shop - Main Page</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .main-container {
            margin-top: 50px;
            text-align: center;
        }
        .action-links a {
            display: block;
            margin: 15px 0;
            font-size: 1.2em;
        }
        .welcome-message {
            font-size: 1.5em;
            margin-top: 20px;
            color: #555;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container main-container">
    <div class="row">
        <div class="col-md-12">
            <h2 class="mb-4">Welcome to Cai & Charlie's Car Shop</h2>
            <div class="action-links">
                <a href="login.jsp" class="btn btn-primary btn-lg">Login</a>
                <a href="listprod.jsp" class="btn btn-success btn-lg">Begin Shopping</a>
                <a href="listorder.jsp" class="btn btn-info btn-lg">List All Orders</a>
                <a href="customer.jsp" class="btn btn-warning btn-lg">Customer Info</a>
                <a href="admin.jsp" class="btn btn-danger btn-lg">Administrators</a>
                <a href="logout.jsp" class="btn btn-secondary btn-lg">Log Out</a>
            </div>
            <%
                String userName = (String) session.getAttribute("authenticatedUser");
                if (userName != null) {
            %>
                <div class="welcome-message">
                    Signed in as: <strong><%= userName %></strong>
                </div>
            <%
                }
            %>
        </div>
    </div>
</div>

</body>
</html>