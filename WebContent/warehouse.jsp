<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Ray's Grocery</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<h2>Browse Inventory By Warehouse</h2>

<form method="get" action="warehouse.jsp">
  <p align="left">
  <select size="1" name="warehouseName">
  <option>All</option>
  <option>Main warehouse</option>
  <option>Extra warehouse</option>      
  </select>
  <input type="submit" value="Submit"><input type="reset" value="Reset"></p>
</form>

<%
// Colors for different item categories
HashMap<String,String> colors = new HashMap<String,String>();		// This may be done dynamically as well, a little tricky...
colors.put("Sedan", "#0000FF");
colors.put("SUV", "#FF0000");
colors.put("Truck", "#000000");
colors.put("Motorcycle", "#6600CC");
colors.put("Electric Vehicle", "#55A5B3");
%>

<%
// Get product name to search for
String name = request.getParameter("productName");
String warehouseName = request.getParameter("warehouseName");

boolean hasNameParam = name != null && !name.equals("");
boolean hasWarehouseParam = warehouseName != null && !warehouseName.equals("") && !warehouseName.equals("All");




String sqlbase = "SELECT warehouseId, warehouseName FROM warehouse";
String sql = "", filter = "";

if (hasWarehouseParam)
{
	filter = "<h3>Products in Warehouse: '"+warehouseName+"'</h3>";
	sql = sqlbase + " WHERE warehouseName = ?";
}
else
{
	filter = "<h3>All Products</h3>";
    sql = sqlbase;
}

out.println(filter);


NumberFormat currFormat = NumberFormat.getCurrencyInstance();
try 
{
    getConnection();
	Statement stmt1 = con.createStatement(); 			
	stmt1.execute("USE orders");


    PreparedStatement stmt = con.prepareStatement(sql);
    if (hasWarehouseParam) stmt.setString(1, warehouseName);
    ResultSet rst = stmt.executeQuery();
    
    while(rst.next()){
        String getWarehouseId = rst.getString(1);
        String getWarehouseName = rst.getString(2);
    
        out.print("<table border=\"1\"><tr><th> Warehouse:"+getWarehouseName+" </th></tr>");
    
        String sql2 = "SELECT pi.productId, p.productName, pi.quantity, pi.price FROM productinventory pi JOIN product p ON p.productId = pi.productId WHERE pi.warehouseId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql2);
        pstmt.setString(1,getWarehouseId);
        ResultSet rst2 = pstmt.executeQuery();
    
        out.println("<tr align=\"right\"><td colspan=\"4\"><table border=\"1\">");
            out.println("<th>Product Id</th><th>Product Name</th> <th>Quantity</th> <th>Price</th></tr>");
            while (rst2.next())
            {
                out.print("<tr><td>"+rst2.getInt(1)+"</td>");
                out.print("<td>"+rst2.getString(2)+"</td>");
                out.print("<td>"+rst2.getInt(3)+"</td>");
                out.println("<td>"+currFormat.format(rst2.getDouble(4))+"</td>");
                out.print("<td><form method='post' action='editItem.jsp'>");
                    out.print("<input type='hidden' name='productId' value='" + rst2.getInt(1) + "'>");
                    out.print("<input type='hidden' name='warehouseId' value='" + getWarehouseId + "'>");
                    out.print("<input type='submit' value='Edit'></form></td></tr>");
            }
            out.println("</table></td></tr>");
            out.println("</table>");
    }
    
    
	closeConnection();
} catch (SQLException ex) {
	out.println(ex);
}
%>

</body>
</html>

