<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <%@ page import="java.text.NumberFormat" %>
    <style>
        .report-container {
            margin-top: 50px;
            max-width: 900px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            background-color: #f9f9f9;
        }
        .report-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .report-table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        .report-table th, .report-table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .report-table th {
            background-color: #f2f2f2;
        }
        .customer-header {
            margin-top: 40px;
            text-align: center;
        }
        .customer-table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        .customer-table th, .customer-table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .customer-table th {
            background-color: #e9ecef;
        }
        .text-danger {
            color: #dc3545;
        }
    </style>
</head>
<body>

<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<div class="container report-container">
    <h1 class="report-header">Administrator Sales Report by Day</h1>

    <%
        String salesSql = "SELECT year(orderDate), month(orderDate), day(orderDate), SUM(totalAmount) " +
                          "FROM OrderSummary GROUP BY year(orderDate), month(orderDate), day(orderDate)";

        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        try {
            getConnection();
            Statement stmt = con.createStatement();
            stmt.execute("USE orders");

            ResultSet salesRst = stmt.executeQuery(salesSql);

            out.println("<table class=\"table report-table\">");
            out.println("<tr><th>Order Date</th><th>Total Order Amount</th></tr>");

            while (salesRst.next()) {
                String orderDate = salesRst.getString(1) + "-" + salesRst.getString(2) + "-" + salesRst.getString(3);
                String totalAmount = currFormat.format(salesRst.getDouble(4));
                out.println("<tr><td>" + orderDate + "</td><td>" + totalAmount + "</td></tr>");
            }
            out.println("</table>");
        } catch (SQLException ex) {
            out.println("<p class=\"text-danger\">Error: " + ex.getMessage() + "</p>");
        }
    %>

    <h2 class="customer-header">Customer List</h2>
    <%
        String customerSql = "SELECT customerId, firstName, lastName, email FROM Customer";

        try {
            PreparedStatement customerStmt = con.prepareStatement(customerSql);
            ResultSet customerRst = customerStmt.executeQuery();

            out.println("<table class=\"table customer-table\">");
            out.println("<tr><th>Customer ID</th><th>First Name</th><th>Last Name</th><th>Email</th></tr>");

            while (customerRst.next()) {
                int customerId = customerRst.getInt("customerId");
                String firstName = customerRst.getString("firstName");
                String lastName = customerRst.getString("lastName");
                String email = customerRst.getString("email");

                out.println("<tr>");
                out.println("<td>" + customerId + "</td>");
                out.println("<td>" + firstName + "</td>");
                out.println("<td>" + lastName + "</td>");
                out.println("<td>" + email + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        } catch (SQLException ex) {
            out.println("<p class=\"text-danger\">Error: " + ex.getMessage() + "</p>");
        } finally {
            closeConnection();
        }
    %>
</div>

</body>
</html>