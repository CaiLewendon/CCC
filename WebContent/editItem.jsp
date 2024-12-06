<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Edit Item</title>
</head>
<body>
<%@ include file="header.jsp" %>

<h2>Edit Inventory Item</h2>

<%
String productId = request.getParameter("productId");
String warehouseId = request.getParameter("warehouseId");
String productName = "";
int quantity = 0;
double price = 0.0;

try {
    getConnection();
    Statement stmt = con.createStatement();
    stmt.execute("USE orders");
    PreparedStatement pstmt = con.prepareStatement(
        "SELECT p.productName, pi.quantity, pi.price " +
        "FROM productinventory pi " +
        "JOIN product p ON p.productId = pi.productId " +
        "WHERE pi.productId = ? AND pi.warehouseId = ?"
    );
    pstmt.setString(1, productId);
    pstmt.setString(2, warehouseId);
    ResultSet rst = pstmt.executeQuery();
    if (rst.next()) {
        productName = rst.getString(1);
        quantity = rst.getInt(2);
        price = rst.getDouble(3);
    }
    closeConnection();
} catch (SQLException ex) {
    out.println(ex);
}
%>

<form method="post" action="updateWarehouseItem.jsp">
    <input type="hidden" name="productId" value="<%= productId %>">
    <input type="hidden" name="warehouseId" value="<%= warehouseId %>">
    <p>Product Name: <strong><%= productName %></strong></p>
    <p>Quantity: <input type="number" name="quantity" value="<%= quantity %>"></p>
    <p>Price: <input type="text" name="price" value="<%= price %>"></p>
    <p><input type="submit" value="Update"></p>
</form>

</body>
</html>
