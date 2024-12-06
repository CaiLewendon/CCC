<!DOCTYPE html>
<html>
<head>
    <title>Customer Profile</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .profile-container {
            margin-top: 50px;
            max-width: 800px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            background-color: #f9f9f9;
        }
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .profile-table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        .profile-table th, .profile-table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .profile-table th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>

<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<div class="container profile-container">
    <h1 class="profile-header">Customer Profile</h1>

    <%
        String userName = (String) session.getAttribute("authenticatedUser");
        String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password " +
                     "FROM Customer WHERE userid = ?";
        try {
            getConnection();
            Statement stmt = con.createStatement();
            stmt.execute("USE orders");

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userName);
            ResultSet rst = pstmt.executeQuery();

            if (rst.next()) {
                out.println("<table class=\"profile-table\">");
                out.println("<tr><th>Customer ID</th><td>" + rst.getString(1) + "</td></tr>");
                out.println("<tr><th>First Name</th><td>" + rst.getString(2) + "</td></tr>");
                out.println("<tr><th>Last Name</th><td>" + rst.getString(3) + "</td></tr>");
                out.println("<tr><th>Email</th><td>" + rst.getString(4) + "</td></tr>");
                out.println("<tr><th>Phone Number</th><td>" + rst.getString(5) + "</td></tr>");
                out.println("<tr><th>Address</th><td>" + rst.getString(6) + "</td></tr>");
                out.println("<tr><th>City</th><td>" + rst.getString(7) + "</td></tr>");
                out.println("<tr><th>State</th><td>" + rst.getString(8) + "</td></tr>");
                out.println("<tr><th>Postal Code</th><td>" + rst.getString(9) + "</td></tr>");
                out.println("<tr><th>Country</th><td>" + rst.getString(10) + "</td></tr>");
                out.println("<tr><th>User ID</th><td>" + rst.getString(11) + "</td></tr>");
                out.println("</table>");
            } else {
                out.println("<p class=\"text-danger\">No customer details found.</p>");
            }
        } catch (SQLException ex) {
            out.println("<p class=\"text-danger\">Error: " + ex.getMessage() + "</p>");
        } finally {
            closeConnection();
        }
    %>
</div>

</body>
</html>