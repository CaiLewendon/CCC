<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> <!-- Include Chart.js -->
    <%@ page import="java.text.NumberFormat" %>
    <%@ page import="java.util.ArrayList" %>
    <%@ page import="java.util.List" %>
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
        .graph-container {
            margin-top: 50px;
            background-color: #1e1e1e; /* Match dark mode */
            border: 1px solid #444;
            padding: 20px;
            border-radius: 10px;
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
        canvas {
            display: block;
            margin: 0 auto;
        }
    </style>
</head>
<body>

<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<div class="container report-container">
        <!-- Button to navigate to warehouse.jsp -->
    
    <h1 class="report-header">Administrator Sales Report by Day</h1>
    <!-- Existing sales report and customer list tables -->

    <!-- Button for navigating to the Product Management Page -->
    <div class="text-center mt-4">
        <a href="manageProducts.jsp" class="btn btn-primary btn-lg">Manage Products</a>
    </div>
</div>

<div class="container report-container">
    <h1 class="report-header">Administrator Sales Report by Day</h1>

    <%
        String salesSql = "SELECT year(orderDate), month(orderDate), day(orderDate), SUM(totalAmount) " +
                          "FROM OrderSummary GROUP BY year(orderDate), month(orderDate), day(orderDate)";

        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        StringBuilder labels = new StringBuilder("[");
        StringBuilder salesData = new StringBuilder("[");

        try {
            getConnection();
            Statement stmt = con.createStatement();
            stmt.execute("USE orders");

            ResultSet salesRst = stmt.executeQuery(salesSql);

            out.println("<table class=\"table report-table\">");
            out.println("<tr><th>Order Date</th><th>Total Order Amount</th></tr>");

            while (salesRst.next()) {
                String orderDate = salesRst.getString(1) + "-" + salesRst.getString(2) + "-" + salesRst.getString(3);
                double totalAmount = salesRst.getDouble(4);

                labels.append("\"").append(orderDate).append("\",");
                salesData.append(totalAmount).append(",");

                String formattedAmount = currFormat.format(totalAmount);
                out.println("<tr><td>" + orderDate + "</td><td>" + formattedAmount + "</td></tr>");
            }

            if (labels.length() > 1) labels.setLength(labels.length() - 1); // Remove trailing comma
            if (salesData.length() > 1) salesData.setLength(salesData.length() - 1);

            labels.append("]");
            salesData.append("]");

            out.println("</table>");
        } catch (SQLException ex) {
            out.println("<p class=\"text-danger\">Error: " + ex.getMessage() + "</p>");
        } finally {
            closeConnection();
        }
    %>

    <div class="mb-4 text-center">
        <a href="warehouse.jsp" class="btn btn-primary">Go to Warehouse Inventory</a>
    </div>

    <div class="graph-container">
        <h2 class="report-header">Sales Report Graph</h2>
        <canvas id="salesGraph"></canvas> <!-- Canvas for Chart.js -->
        <script>
            // Validate and parse JSP-generated data
            const labels = <%= labels.toString() %>;
            const data = <%= salesData.toString() %>;

            // Render the bar chart
            const ctx = document.getElementById('salesGraph').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Total Sales (USD)',
                        data: data,
                        backgroundColor: 'rgba(75, 192, 192, 0.6)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                        },
                        title: {
                            display: true,
                            text: 'Sales by Day'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        </script>
    </div>

    <h2 class="customer-header">Customer List</h2>
    <%
        String customerSql = "SELECT customerId, firstName, lastName, email FROM customer";

        try {
			getConnection();
			Statement stmt = con.createStatement();
    		stmt.execute("USE orders");
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