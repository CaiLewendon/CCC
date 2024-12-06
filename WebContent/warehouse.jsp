<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Ray's Grocery - Warehouse Inventory</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .inventory-container {
            margin-top: 50px;
            max-width: 900px;
            padding: 20px;
            border: 1px solid #444;
            border-radius: 10px;
            background-color: #1e1e1e;
        }
        .inventory-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .inventory-table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        .inventory-table th, .inventory-table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .inventory-table th {
            background-color: #f2f2f2;
        }
        .text-danger {
            color: #dc3545;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container inventory-container">
    <h1 class="inventory-header">Browse Inventory By Warehouse</h1>

    <!-- Filter Form -->
    <form method="get" action="warehouse.jsp">
        <div class="mb-3 text-center">
            <label for="warehouseName" class="form-label">Select Warehouse</label>
            <select class="form-select" name="warehouseName" id="warehouseName">
                <option>All</option>
                <option>Main warehouse</option>
                <option>Extra warehouse</option>
            </select>
        </div>
        <div class="mb-4 text-center">
        <button type="submit" class="btn btn-primary">Submit</button>
        <button type="reset" class="btn btn-secondary">Reset</button>
    </div>
    </form>

    <div class="text-center">
    <% 
        String warehouseName = request.getParameter("warehouseName");
        boolean hasWarehouseParam = warehouseName != null && !warehouseName.equals("") && !warehouseName.equals("All");

        String sqlBase = "SELECT warehouseId, warehouseName FROM warehouse";
        String sql = hasWarehouseParam ? sqlBase + " WHERE warehouseName = ?" : sqlBase;

        String filterMessage = hasWarehouseParam ? 
            "Showing products in warehouse: '" + warehouseName + "'" : 
            "Showing products in all warehouses";
    %>

    <h3><%= filterMessage %></h3>

    <% 
        try {
            getConnection();
            Statement stmt1 = con.createStatement();
            stmt1.execute("USE orders");

            PreparedStatement stmt = con.prepareStatement(sql);
            if (hasWarehouseParam) {
                stmt.setString(1, warehouseName);
            }
            ResultSet rst = stmt.executeQuery();

            while (rst.next()) {
                String getWarehouseId = rst.getString(1);
                String getWarehouseName = rst.getString(2);

                out.println("<h4>" + getWarehouseName + "</h4>");
                out.println("<table class=\"table inventory-table\">");
                out.println("<tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Action</th></tr>");

                String sql2 = "SELECT pi.productId, p.productName, pi.quantity, pi.price " +
                              "FROM productinventory pi " +
                              "JOIN product p ON p.productId = pi.productId " +
                              "WHERE pi.warehouseId = ?";
                PreparedStatement pstmt = con.prepareStatement(sql2);
                pstmt.setString(1, getWarehouseId);
                ResultSet rst2 = pstmt.executeQuery();

                while (rst2.next()) {
                    int productId = rst2.getInt("productId");
                    String productName = rst2.getString("productName");
                    int quantity = rst2.getInt("quantity");
                    double price = rst2.getDouble("price");

                    out.println("<tr>");
                    out.println("<td>" + productId + "</td>");
                    out.println("<td>" + productName + "</td>");
                    out.println("<td>" + quantity + "</td>");
                    out.println("<td>" + NumberFormat.getCurrencyInstance().format(price) + "</td>");
                    out.println("<td>");
                    out.println("<form method='post' action='editItem.jsp' style='display:inline;'>");
                    out.println("<input type='hidden' name='productId' value='" + productId + "'>");
                    out.println("<input type='hidden' name='warehouseId' value='" + getWarehouseId + "'>");
                    out.println("<button type='submit' class='btn btn-sm btn-warning'>Edit</button>");
                    out.println("</form>");
                    out.println("</td>");
                    out.println("</tr>");
                }

                out.println("</table>");
            }
        } catch (SQLException ex) {
            out.println("<p class='text-danger'>Error: " + ex.getMessage() + "</p>");
        } finally {
            closeConnection();
        }
    %>
    </div>
</div>

</body>
</html>
