<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Update Item</title>
</head>
<body>
<%@ include file="header.jsp" %>

<%
String productId = request.getParameter("productId");
String warehouseId = request.getParameter("warehouseId");
String quantity = request.getParameter("quantity");
String price = request.getParameter("price");

try {
    getConnection();
    Statement stmt = con.createStatement();
    stmt.execute("USE orders");

    PreparedStatement pstmt = con.prepareStatement(
        "UPDATE productinventory SET quantity = ?, price = ? WHERE productId = ? AND warehouseId = ?"
    );
    pstmt.setInt(1, Integer.parseInt(quantity));
    pstmt.setDouble(2, Double.parseDouble(price));
    pstmt.setString(3, productId);
    pstmt.setString(4, warehouseId);
    int rowsUpdated = pstmt.executeUpdate();

    if (rowsUpdated > 0) {
        out.println("<h2>Item updated successfully!</h2>");
    } else {
        out.println("<h2>Failed to update item. Please try again.</h2>");
    }
    closeConnection();
} catch (SQLException ex) {
    out.println("<h2>Error: " + ex.getMessage() + "</h2>");
}
%>

<a href="warehouse.jsp">Go Back</a>

</body>
</html>
