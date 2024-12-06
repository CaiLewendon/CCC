<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
<style>
    .cart-table {
        width: 100%;
        margin-top: 20px;
        border: 1px solid #ddd;
    }
    .cart-table th, .cart-table td {
        padding: 10px;
        text-align: center;
        border-bottom: 1px solid #ddd;
    }
    .cart-total {
        font-weight: bold;
        font-size: 1.2em;
        text-align: right;
        padding-right: 20px;
    }
    .cart-buttons {
        margin-top: 20px;
    }
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container mt-5">
    <div class="row">
        <div class="col-md-12">
            <% 
            @SuppressWarnings({"unchecked"})
            HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

            if (productList == null) {
            %>
                <div class="alert alert-info text-center" role="alert">
                    <h2>Your shopping cart is empty!</h2>
                </div>
            <%
                productList = new HashMap<String, ArrayList<Object>>();
            } else {
                NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);
            %>
                <h1 class="text-center mb-4">Your Shopping Cart</h1>
                <table class="cart-table table table-striped">
                    <thead>
                        <tr>
                            <th>Product ID</th>
                            <th>Product Name</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        double total = 0;
                        Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();

                        while (iterator.hasNext()) {
                            Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                            ArrayList<Object> product = (ArrayList<Object>) entry.getValue();

                            if (product.size() < 4) {
                                out.println("<tr><td colspan='5' class='text-danger'>Invalid product data</td></tr>");
                                continue;
                            }

                            int productId = Integer.parseInt(product.get(0).toString());
                            String productName = product.get(1).toString();
                            double productPrice = Double.parseDouble(product.get(2).toString());
                            int quantity = Integer.parseInt(product.get(3).toString());
                            double subtotal = productPrice * quantity;

                            total += subtotal;
                        %>
                            <tr>
                                <td><%= productId %></td>
                                <td><%= productName %></td>
                                <td><%= quantity %></td>
                                <td><%= currFormat.format(productPrice) %></td>
                                <td><%= currFormat.format(subtotal) %></td>
                            </tr>
                        <%
                        }
                        %>
                        <tr>
                            <td colspan="4" class="cart-total">Order Total</td>
                            <td class="cart-total"><%= currFormat.format(total) %></td>
                        </tr>
                    </tbody>
                </table>
                <div class="cart-buttons text-center">
                    <a href="checkout.jsp" class="btn btn-success btn-lg">Check Out</a>
                    <a href="listprod.jsp" class="btn btn-primary btn-lg">Continue Shopping</a>
                </div>
            <%
            }
            %>
        </div>
    </div>
</div>

</body>
</html>