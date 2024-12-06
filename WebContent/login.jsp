<!DOCTYPE html>
<html>
<head>
    <title>Login Screen</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .login-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            background-color: #f9f9f9;
        }
        .login-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
	<link href="darkmode.css" rel="stylesheet">
</head>
<body>

<div class="login-container">
    <h3 class="login-header">Please Login to System</h3>

    <%
    // Display error message if login failed
    if (session.getAttribute("loginMessage") != null) {
    %>
        <div class="error-message">
            <%= session.getAttribute("loginMessage").toString() %>
        </div>
    <%
    }
    %>

    <form name="MyForm" method="post" action="validateLogin.jsp">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" name="username" id="username" class="form-control" maxlength="10" required>
        </div>
        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" name="password" id="password" class="form-control" maxlength="10" required>
        </div>
        <button type="submit" class="btn btn-primary btn-block">Log In</button>
    </form>
</div>

</body>
</html>