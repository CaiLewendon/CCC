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
        String sql = "SELECT year(orderDate), month(orderDate), day(orderDate), SUM(totalAmount) " +
                     "FROM OrderSummary GROUP BY year(orderDate), month(orderDate), day(orderDate)";

        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        try {
            getConnection();
            Statement stmt = con.createStatement();
            stmt.execute("USE orders");

            ResultSet rst = stmt.executeQuery(sql);

            out.println("<table class=\"table report-table\">");
            out.println("<tr><th>Order Date</th><th>Total Order Amount</th></tr>");

            while (rst.next()) {
                String orderDate = rst.getString(1) + "-" + rst.getString(2) + "-" + rst.getString(3);
                String totalAmount = currFormat.format(rst.getDouble(4));
                out.println("<tr><td>" + orderDate + "</td><td>" + totalAmount + "</td></tr>");
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
