<%@ page import="java.sql.*,java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Cai & Charlie's Car Shop - Order List</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container {
            margin-top: 50px;
        }
        .order-table {
            margin-top: 20px;
        }
        .order-details-table {
            margin-top: 10px;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <h1 class="text-center">Order List</h1>

    <%
    String sql = "SELECT orderId, O.CustomerId, totalAmount, firstName+' '+lastName, orderDate "
               + "FROM OrderSummary O JOIN Customer C ON O.customerId = C.customerId";

    NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

    try {
        getConnection();
        Statement stmt = con.createStatement();
        stmt.execute("USE orders");

        ResultSet rst = stmt.executeQuery(sql);

        out.println("<table class='table table-bordered order-table'>");
        out.println("<thead class='thead-dark'>");
        out.println("<tr><th>Order ID</th><th>Order Date</th><th>Customer ID</th><th>Customer Name</th><th>Total Amount</th></tr>");
        out.println("</thead>");
        out.println("<tbody>");

        // Use PreparedStatement for retrieving order details
        sql = "SELECT productId, quantity, price FROM OrderProduct WHERE orderId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);

        while (rst.next()) {
            int orderId = rst.getInt(1);
            out.println("<tr>");
            out.println("<td>" + orderId + "</td>");
            out.println("<td>" + rst.getString(5) + "</td>");
            out.println("<td>" + rst.getInt(2) + "</td>");
            out.println("<td>" + rst.getString(4) + "</td>");
            out.println("<td>" + currFormat.format(rst.getDouble(3)) + "</td>");
            out.println("</tr>");

            // Retrieve all items for the current order
            pstmt.setInt(1, orderId);
            ResultSet rst2 = pstmt.executeQuery();

            out.println("<tr>");
            out.println("<td colspan='5'>");
            out.println("<table class='table table-sm table-bordered order-details-table'>");
            out.println("<thead>");
            out.println("<tr><th>Product ID</th><th>Quantity</th><th>Price</th></tr>");
            out.println("</thead>");
            out.println("<tbody>");

            while (rst2.next()) {
                out.println("<tr>");
                out.println("<td>" + rst2.getInt(1) + "</td>");
                out.println("<td>" + rst2.getInt(2) + "</td>");
                out.println("<td>" + currFormat.format(rst2.getDouble(3)) + "</td>");
                out.println("</tr>");
            }

            out.println("</tbody>");
            out.println("</table>");
            out.println("</td>");
            out.println("</tr>");
        }

        out.println("</tbody>");
        out.println("</table>");
    } catch (SQLException ex) {
        out.println("<div class='alert alert-danger'>Error: " + ex.getMessage() + "</div>");
    } finally {
        closeConnection();
    }
    %>
</div>

</body>
</html>