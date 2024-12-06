<%@ page import="java.sql.*,java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Map,java.math.BigDecimal" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Cai & Charlie's Car Shop Order Processing</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
<style>
    .container {
        margin-top: 50px;
    }
    .order-summary-table {
        width: 100%;
        margin-top: 20px;
        border: 1px solid #ddd;
    }
    .order-summary-table th, .order-summary-table td {
        padding: 10px;
        text-align: center;
        border-bottom: 1px solid #ddd;
    }
    .order-total {
        font-weight: bold;
        text-align: right;
    }
    .message {
        text-align: center;
        margin-top: 20px;
    }
    .return-link {
        display: block;
        text-align: center;
        margin-top: 30px;
    }
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <% 
    // Get customer id
    String custId = request.getParameter("customerId");
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (custId == null || custId.equals("")) {
    %>
        <div class="alert alert-danger text-center">
            <h1>Invalid customer ID. Please go back and try again.</h1>
        </div>
    <%
    } else if (productList == null) {
    %>
        <div class="alert alert-info text-center">
            <h1>Your shopping cart is empty!</h1>
        </div>
    <%
    } else {
        int num = -1;
        try {
            num = Integer.parseInt(custId);
        } catch(Exception e) {
    %>
            <div class="alert alert-danger text-center">
                <h1>Invalid customer ID. Please go back and try again.</h1>
            </div>
    <%
            return;
        }

        String sql = "SELECT customerId, firstName+' '+lastName FROM Customer WHERE customerId = ?";
        NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

        try {
            getConnection();
            Statement stmt = con.createStatement();
            stmt.execute("USE orders");

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, num);
            ResultSet rst = pstmt.executeQuery();
            int orderId = 0;
            String custName = "";

            if (!rst.next()) {
    %>
                <div class="alert alert-danger text-center">
                    <h1>Invalid customer ID. Please go back and try again.</h1>
                </div>
    <%
            } else {
                custName = rst.getString(2);

                // Insert order summary
                sql = "INSERT INTO OrderSummary (customerId, totalAmount, orderDate) VALUES(?, 0, ?);";
                pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                pstmt.setInt(1, num);
                pstmt.setTimestamp(2, new java.sql.Timestamp(new Date().getTime()));
                pstmt.executeUpdate();
                ResultSet keys = pstmt.getGeneratedKeys();
                keys.next();
                orderId = keys.getInt(1);

                double total = 0;

    %>
                <h1 class="text-center">Your Order Summary</h1>
                <table class="table order-summary-table">
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
                        Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
                        while (iterator.hasNext()) {
                            Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                            ArrayList<Object> product = entry.getValue();

                            String productId = (String) product.get(0);
                            String productName = (String) product.get(1);
                            double price = Double.parseDouble((String) product.get(2));
                            int quantity = ((Integer) product.get(3));

                            double subtotal = price * quantity;
                            total += subtotal;

                            // Insert order product
                            sql = "INSERT INTO OrderProduct (orderId, productId, quantity, price) VALUES(?, ?, ?, ?)";
                            pstmt = con.prepareStatement(sql);
                            pstmt.setInt(1, orderId);
                            pstmt.setInt(2, Integer.parseInt(productId));
                            pstmt.setInt(3, quantity);
                            pstmt.setDouble(4, price);
                            pstmt.executeUpdate();

                        %>
                            <tr>
                                <td><%= productId %></td>
                                <td><%= productName %></td>
                                <td><%= quantity %></td>
                                <td><%= currFormat.format(price) %></td>
                                <td><%= currFormat.format(subtotal) %></td>
                            </tr>
                        <%
                        }
                        %>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="4" class="order-total">Order Total</td>
                            <td class="order-total"><%= currFormat.format(total) %></td>
                        </tr>
                    </tfoot>
                </table>
                <div class="message">
                    <h1>Order completed. Your order reference number is: <%= orderId %></h1>
                    <h2>Shipping to customer: <%= custId %>, Name: <%= custName %></h2>
                </div>
                <div class="return-link">
                    <a href="shop.html" class="btn btn-primary btn-lg">Return to Shopping</a>
                </div>
    <%
                // Update order total
                sql = "UPDATE OrderSummary SET totalAmount=? WHERE orderId=?";
                pstmt = con.prepareStatement(sql);
                pstmt.setDouble(1, total);
                pstmt.setInt(2, orderId);
                pstmt.executeUpdate();

                // Clear session variables (cart)
                session.setAttribute("productList", null);
            }
        } catch (SQLException ex) {
    %>
            <div class="alert alert-danger text-center">
                <h1>Error: <%= ex.getMessage() %></h1>
            </div>
    <%
        } finally {
            closeConnection();
        }
    }
    %>
</div>

</body>
</html>