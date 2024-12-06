<!DOCTYPE html>
<html>
<head>
<title>Cai & Charlie's Car Shop CheckOut Line</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
<style>
    .checkout-container {
        margin-top: 50px;
        max-width: 600px;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 10px;
        background-color: #f9f9f9;
    }
    .checkout-header {
        text-align: center;
        margin-bottom: 30px;
    }
    .form-group input[type="text"] {
        width: 100%;
    }
    .btn-group {
        display: flex;
        justify-content: space-between;
    }
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container checkout-container">
    <h1 class="checkout-header">Complete Your Transaction</h1>
    <form method="get" action="order.jsp">
        <div class="form-group">
            <label for="customerId">Enter your customer ID:</label>
            <input type="text" id="customerId" name="customerId" class="form-control" placeholder="Customer ID" required>
        </div>
        <div class="btn-group mt-4">
            <input type="submit" value="Submit" class="btn btn-success">
            <input type="reset" value="Reset" class="btn btn-secondary">
        </div>
    </form>
</div>

</body>
</html>