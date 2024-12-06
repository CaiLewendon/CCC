<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
</head>
<body>
    <%@ include file="auth.jsp" %>
    <%@ page import="java.text.NumberFormat" %>
    <%@ include file="jdbc.jsp" %>
    <%@ include file="header.jsp" %>

    <%
        // Get the authenticated user's username from the session
        String userName = (String) session.getAttribute("authenticatedUser");

        // SQL query to fetch customer information
        String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password " +
                     "FROM Customer WHERE userid = ?";
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        try {
            // Display heading
            out.println("<h3>Customer Profile</h3>");

            // Establish database connection
            getConnection();

            // Use the orders database
            Statement stmt = con.createStatement();
            stmt.execute("USE orders");

            // Prepare the SQL statement
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userName);

            // Execute the query
            ResultSet rst = pstmt.executeQuery();

            // Display customer details if found
            if (rst.next()) {
                out.println("<table class=\"table\" border=\"1\">");
                out.println("<tr><th>Id</th><td>" + rst.getString(1) + "</td></tr>");
                out.println("<tr><th>First Name</th><td>" + rst.getString(2) + "</td></tr>");
                out.println("<tr><th>Last Name</th><td>" + rst.getString(3) + "</td></tr>");
                out.println("<tr><th>Email</th><td>" + rst.getString(4) + "</td></tr>");
                out.println("<tr><th>Phone</th><td>" + rst.getString(5) + "</td></tr>");
                out.println("<tr><th>Address</th><td>" + rst.getString(6) + "</td></tr>");
                out.println("<tr><th>City</th><td>" + rst.getString(7) + "</td></tr>");
                out.println("<tr><th>State</th><td>" + rst.getString(8) + "</td></tr>");
                out.println("<tr><th>Postal Code</th><td>" + rst.getString(9) + "</td></tr>");
                out.println("<tr><th>Country</th><td>" + rst.getString(10) + "</td></tr>");
                out.println("<tr><th>User ID</th><td>" + rst.getString(11) + "</td></tr>");
                out.println("</table>");
            }
        } catch (SQLException ex) {
            // Display SQL exception
            out.println("<p>Error: " + ex.getMessage() + "</p>");
        } finally {
            // Close the database connection
            closeConnection();
        }
    %>
</body>
</html>