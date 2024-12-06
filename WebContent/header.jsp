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
%>
    <p align="center">
        <font face="Arial" color="#555555" size="4">
            Welcome, Guest!
        </font>
    </p>
<%
    }
%>
<div align="center">
    <!-- Button for Shopping Cart -->
    <form method="get" action="<%= (authenticatedUser != null) ? "showcart.jsp" : "login.jsp" %>" style="display:inline;">
        <button type="submit" class="btn btn-primary">Go to Shopping Cart</button>
    </form>
    <!-- Button for Customer Profile -->
    <form method="get" action="<%= (authenticatedUser != null) ? "customer.jsp" : "login.jsp" %>" style="display:inline;">
        <button type="submit" class="btn btn-secondary">View Profile</button>
    </form>
</div>
<hr>
