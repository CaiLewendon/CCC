<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Cai & Charlie's Car Shop</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<h2>Browse Products By Category and Search by Product Name:</h2>

<form method="get" action="listprod.jsp">
  <p align="left">
  <select size="1" name="categoryName">
  <option>All</option>
  <option>Sedan</option>
  <option>SUV</option>
  <option>Truck</option>
  <option>Motorcycle</option>
  <option>Electric Vehicle</option>     
  </select>
  <input type="text" name="productName" size="50">
  <input type="submit" value="Submit"><input type="reset" value="Reset"></p>
</form>

<%
// Colors for different item categories
HashMap<String, String> colors = new HashMap<String, String>();
colors.put("Sedan", "#0000FF");
colors.put("SUV", "#FF0000");
colors.put("Truck", "#000000");
colors.put("Motorcycle", "#6600CC");
colors.put("Electric Vehicle", "#55A5B3");

// Get product name and category to search for
String name = request.getParameter("productName");
String category = request.getParameter("categoryName");
//String authenticatedUser = (String) session.getAttribute("authenticatedUser");

boolean hasNameParam = name != null && !name.equals("");
boolean hasCategoryParam = category != null && !category.equals("") && !category.equals("All");
String filter = "", sql = "";

if (hasNameParam && hasCategoryParam) {
    filter = "<h3>Products containing '" + name + "' in category: '" + category + "'</h3>";
    name = '%' + name + '%';
    sql = "SELECT P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL, "
        + "COALESCE(SUM(OP.quantity), 0) AS totalSales "
        + "FROM Product P "
        + "LEFT JOIN OrderProduct OP ON P.productId = OP.productId "
        + "JOIN Category C ON P.categoryId = C.categoryId "
        + "WHERE P.productName LIKE ? AND C.categoryName = ? "
        + "GROUP BY P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL "
        + "ORDER BY totalSales DESC";
} else if (hasNameParam) {
    filter = "<h3>Products containing '" + name + "'</h3>";
    name = '%' + name + '%';
    sql = "SELECT P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL, "
        + "COALESCE(SUM(OP.quantity), 0) AS totalSales "
        + "FROM Product P "
        + "LEFT JOIN OrderProduct OP ON P.productId = OP.productId "
        + "JOIN Category C ON P.categoryId = C.categoryId "
        + "WHERE P.productName LIKE ? "
        + "GROUP BY P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL "
        + "ORDER BY totalSales DESC";
} else if (hasCategoryParam) {
    filter = "<h3>Products in category: '" + category + "'</h3>";
    sql = "SELECT P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL, "
        + "COALESCE(SUM(OP.quantity), 0) AS totalSales "
        + "FROM Product P "
        + "LEFT JOIN OrderProduct OP ON P.productId = OP.productId "
        + "JOIN Category C ON P.categoryId = C.categoryId "
        + "WHERE C.categoryName = ? "
        + "GROUP BY P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL "
        + "ORDER BY totalSales DESC";
} else {
    filter = "<h3>All Products</h3>";
    sql = "SELECT P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL, "
        + "COALESCE(SUM(OP.quantity), 0) AS totalSales "
        + "FROM Product P "
        + "LEFT JOIN OrderProduct OP ON P.productId = OP.productId "
        + "JOIN Category C ON P.categoryId = C.categoryId "
        + "GROUP BY P.productId, P.productName, P.productPrice, C.categoryName, P.productImageURL "
        + "ORDER BY totalSales DESC";
}

out.println(filter);

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try {
    getConnection();
	Statement stmt = con.createStatement();
	stmt.execute("USE orders");
    PreparedStatement pstmt = con.prepareStatement(sql);
    if (hasNameParam) {
        pstmt.setString(1, name);
        if (hasCategoryParam) {
            pstmt.setString(2, category);
        }
    } else if (hasCategoryParam) {
        pstmt.setString(1, category);
    }

    ResultSet rst = pstmt.executeQuery();

    out.print("<font face=\"Century Gothic\" size=\"2\"><table class=\"table\" border=\"1\"><tr><th class=\"col-md-1\"></th><th>Image</th><th>Product Name</th>");
    out.println("<th>Category</th><th>Price</th><th>Total Sales</th></tr>");
    while (rst.next()) {
        int id = rst.getInt(1);
        String imageUrl = rst.getString(5); // Fetch the image URL
        int totalSales = rst.getInt(6); // Fetch total sales

        out.print("<td class=\"col-md-1\"><a href=\"addcart.jsp?id=" + id + "&name=" + rst.getString(2)
            + "&price=" + rst.getDouble(3) + "\">Add to Cart</a></td>");
        out.print("<td><img src='" + imageUrl + "' alt='" + rst.getString(2) + "' style='width:100px; height:auto;'></td>");

        String itemCategory = rst.getString(4);
        String color = colors.getOrDefault(itemCategory, "#FFFFFF");

        out.println("<td><a href=\"product.jsp?id=" + id + "\"><font color=\"" + color + "\">" + rst.getString(2) + "</font></a></td>"
            + "<td><font color=\"" + color + "\">" + itemCategory + "</font></td>"
            + "<td><font color=\"" + color + "\">" + currFormat.format(rst.getDouble(3))
            + "</font></td>"
            + "<td align=\"center\">" + totalSales + "</td></tr>");
    }
    out.println("</table></font>");

    // Add recommendations randomly from recent product purchases catagories
    if (authenticatedUser != null) {
        String recommendationSql = "SELECT TOP 3 P.productId, P.productName, P.productPrice, P.productImageURL "
            + "FROM Product P "
            + "JOIN Category C ON P.categoryId = C.categoryId "
            + "WHERE C.categoryId IN ("
            + "  SELECT DISTINCT C.categoryId "
            + "  FROM OrderProduct OP "
            + "  JOIN OrderSummary O ON OP.orderId = O.orderId "
            + "  JOIN Product PR ON OP.productId = PR.productId "
            + "  JOIN Category C ON PR.categoryId = C.categoryId "
            + "  WHERE O.customerId = (SELECT customerId FROM Customer WHERE userId = ?)"
            + ") "
            + "ORDER BY NEWID()";

        PreparedStatement recommendationPstmt = con.prepareStatement(recommendationSql);
        recommendationPstmt.setString(1, authenticatedUser);
        ResultSet recommendationRst = recommendationPstmt.executeQuery();

        out.println("<h3>Recommended for You</h3>");
        out.println("<table class=\"table\" border=\"1\"><tr><th>Image</th><th>Product Name</th><th>Price</th></tr>");
        while (recommendationRst.next()) {
            String recImage = recommendationRst.getString("productImageURL");
            String recName = recommendationRst.getString("productName");
            double recPrice = recommendationRst.getDouble("productPrice");

            out.println("<tr>");
            out.println("<td><img src='" + recImage + "' alt='" + recName + "' style='width:100px; height:auto;'></td>");
            out.println("<td>" + recName + "</td>");
            out.println("<td>" + currFormat.format(recPrice) + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
    }

    closeConnection();
} catch (SQLException ex) {
    out.println(ex);
}
%>

</body>
</html>
