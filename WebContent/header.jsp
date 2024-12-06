<%
    // Retrieve the authenticated user's username from the session
    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
%>
<H1 align="center">
    <font face="cursive" color="#3399FF">
        <a href="index.jsp">Ray's Grocery</a>
    </font>
</H1>
<%
    // Display the personalized welcome message if the user is logged in
    if (authenticatedUser != null && !authenticatedUser.isEmpty()) {
%>
    <p align="center">
        <font face="Arial" color="#555555" size="4">
            Welcome, <b><%= authenticatedUser %></b>!
        </font>
    </p>
<%
    } else {
        // Display a generic message if no user is logged in
%>
    <p align="center">
        <font face="Arial" color="#555555" size="4">
            Welcome, Guest!
        </font>
    </p>
<%
    }
%>
<hr>
