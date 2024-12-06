<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Cai & Charlie's Car Shop - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
<style>
    .product-image {
        width: 100%;
        max-width: 300px;
        height: auto;
        border: 2px solid #ddd;
        border-radius: 5px;
        margin-bottom: 15px;
    }
    .product-info {
        font-family: 'Arial', sans-serif;
        font-size: 16px;
    }
    .product-heading {
        margin-bottom: 20px;
        color: #333;
    }
    .add-to-cart {
        margin-top: 20px;
    }
    .back-to-shopping {
        margin-top: 10px;
        color: #007bff;
    }
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container mt-5">
    <div class="row">
        <div class="col-md-12">
            <% 
            // Get product ID from request
            String productId = request.getParameter("id");

            String sql = "SELECT productId, productName, productPrice, productImageURL, productImage, productDesc FROM Product P WHERE productId = ?";

            NumberFormat currFormat = NumberFormat.getCurrencyInstance();

            try {
                getConnection();
                Statement stmt = con.createStatement();
                stmt.execute("USE orders");

                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(productId));

                ResultSet rst = pstmt.executeQuery();

                if (!rst.next()) {
                    out.println("<div class='alert alert-danger'>Invalid product</div>");
                } else {
                    // Display product details
            %>
                    <h1 class="product-heading text-center"><%= rst.getString(2) %></h1>

                    <div class="row">
                        <div class="col-md-6 text-center">
                            <% 
                            // Display image from URL
                            String imageLoc = rst.getString(4);
                            if (imageLoc != null) { 
                            %>
                                <img src="<%= imageLoc %>" alt="<%= rst.getString(2) %>" class="product-image">
                            <% } %>

                            <% 
                            // Display image from database
                            String imageBinary = rst.getString(5);
                            if (imageBinary != null) { 
                            %>
                                <img src="displayImage.jsp?id=<%= rst.getInt(1) %>" alt="<%= rst.getString(2) %>" class="product-image">
                            <% } %>
                        </div>
                        <div class="col-md-6 product-info">
                            <table class="table table-bordered">
                                <tr>
                                    <th>Product ID</th>
                                    <td><%= rst.getInt(1) %></td>
                                </tr>
                                <tr>
                                    <th>Price</th>
                                    <td><%= currFormat.format(rst.getDouble(3)) %></td>
                                </tr>
                                <tr>
                                    <th>Description</th>
                                    <td><%= rst.getString(6) != null ? rst.getString(6) : "No description available" %></td>
                                </tr>
                            </table>
                            <a href="addcart.jsp?id=<%= rst.getInt(1) %>&name=<%= rst.getString(2) %>&price=<%= rst.getDouble(3) %>" class="btn btn-primary btn-block add-to-cart">Add to Cart</a>
                            <a href="listprod.jsp" class="btn btn-link back-to-shopping">Continue Shopping</a>
                        </div>
                    </div>
            <%
                }
            } catch (SQLException ex) {
                out.println("<div class='alert alert-danger'>Error: " + ex.getMessage() + "</div>");
            } finally {
                closeConnection();
            }
            %>
        </div>
    </div>
</div>

</body>
</html>