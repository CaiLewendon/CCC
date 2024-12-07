<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.servlet.http.Part" %>
<%@ page import="java.io.File" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Products</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .manage-products-container {
            max-width: 900px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #444;
            border-radius: 10px;
            background-color: #1e1e1e;
            color: #e0e0e0;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .btn {
            margin-top: 10px;
            padding: 10px 20px;
            font-size: 1.1em;
        }

        .btn-success {
            background-color: #388e3c;
            border-color: #2e7d32;
        }

        .btn-warning {
            background-color: #ffa000;
            border-color: #ff8f00;
        }

        .btn-danger {
            background-color: #d32f2f;
            border-color: #c62828;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .form-section {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #2c2c2c;
            border-radius: 8px;
        }

        .form-section h2 {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<div class="container manage-products-container">
    <h1 class="text-center">Manage Products</h1>

    <!-- Add Product -->
    <div class="form-section">
        <h2>Add Product</h2>
        <form method="post" action="manageProducts.jsp" enctype="multipart/form-data">
            <input type="hidden" name="action" value="add">
            <div class="form-group">
                <label for="addProductName">Product Name:</label>
                <input type="text" name="productName" id="addProductName" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="addProductPrice">Product Price:</label>
                <input type="number" step="0.01" name="productPrice" id="addProductPrice" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="addCategoryId">Category ID:</label>
                <input type="number" name="categoryId" id="addCategoryId" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="addProductDesc">Product Description:</label>
                <textarea name="productDesc" id="addProductDesc" class="form-control" required></textarea>
            </div>
            <div class="form-group">
                <label for="addProductImage">Product Image:</label>
                <input type="file" name="productImage" id="addProductImage" class="form-control" accept=".jpg,.png,.webp">
            </div>
            <button type="submit" class="btn btn-success">Add Product</button>
        </form>
    </div>

    <!-- Update Product -->
    <div class="form-section">
        <h2>Update Product</h2>
        <form method="post" action="manageProducts.jsp" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">
            <div class="form-group">
                <label for="updateProductId">Product ID:</label>
                <input type="number" name="productId" id="updateProductId" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="updateProductName">Product Name (leave blank to keep current):</label>
                <input type="text" name="productName" id="updateProductName" class="form-control">
            </div>
            <div class="form-group">
                <label for="updateProductPrice">Product Price (leave blank to keep current):</label>
                <input type="number" step="0.01" name="productPrice" id="updateProductPrice" class="form-control">
            </div>
            <div class="form-group">
                <label for="updateCategoryId">Category ID (leave blank to keep current):</label>
                <input type="number" name="categoryId" id="updateCategoryId" class="form-control">
            </div>
            <div class="form-group">
                <label for="updateProductDesc">Product Description (leave blank to keep current):</label>
                <textarea name="productDesc" id="updateProductDesc" class="form-control"></textarea>
            </div>
            <div class="form-group">
                <label for="updateProductImage">Product Image (optional):</label>
                <input type="file" name="productImage" id="updateProductImage" class="form-control" accept=".jpg,.png,.webp">
            </div>
            <button type="submit" class="btn btn-warning">Update Product</button>
        </form>
    </div>

    <!-- Delete Product -->
    <div class="form-section">
        <h2>Delete Product</h2>
        <form method="post" action="manageProducts.jsp">
            <input type="hidden" name="action" value="delete">
            <div class="form-group">
                <label for="deleteProductId">Product ID:</label>
                <input type="number" name="productId" id="deleteProductId" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-danger">Delete Product</button>
        </form>
    </div>
</div>

<%
    // Handle Add, Update, Delete actions
    String action = request.getParameter("action");
    if (action != null) {
        try {
            getConnection();
            Statement constmt = con.createStatement();
            constmt.execute("USE orders");
            if ("add".equalsIgnoreCase(action)) {
                String name = request.getParameter("productName");
                double price = Double.parseDouble(request.getParameter("productPrice"));
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                String desc = request.getParameter("productDesc");
                Part filePart = request.getPart("productImage");

                String imageFileName = null;
                if (filePart != null && filePart.getSize() > 0) {
                    imageFileName = new File(filePart.getSubmittedFileName()).getName();
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    filePart.write(uploadPath + File.separator + imageFileName);
                }

                PreparedStatement stmt = con.prepareStatement(
                        "INSERT INTO product (productName, productPrice, categoryId, productDesc, productImageURL) VALUES (?, ?, ?, ?, ?)");
                stmt.setString(1, name);
                stmt.setDouble(2, price);
                stmt.setInt(3, categoryId);
                stmt.setString(4, desc);
                stmt.setString(5, imageFileName != null ? "uploads/" + imageFileName : null);
                stmt.executeUpdate();
                out.println("<div class='alert alert-success'>Product added successfully!</div>");
            } else if ("update".equalsIgnoreCase(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                String name = request.getParameter("productName");
                String price = request.getParameter("productPrice");
                String categoryId = request.getParameter("categoryId");
                String desc = request.getParameter("productDesc");
                Part filePart = request.getPart("productImage");

                StringBuilder sql = new StringBuilder("UPDATE product SET ");
                List<Object> params = new ArrayList<>();
                if (name != null && !name.isEmpty()) {
                    sql.append("productName = ?, ");
                    params.add(name);
                }
                if (price != null && !price.isEmpty()) {
                    sql.append("productPrice = ?, ");
                    params.add(Double.parseDouble(price));
                }
                if (categoryId != null && !categoryId.isEmpty()) {
                    sql.append("categoryId = ?, ");
                    params.add(Integer.parseInt(categoryId));
                }
                if (desc != null && !desc.isEmpty()) {
                    sql.append("productDesc = ?, ");
                    params.add(desc);
                }
                if (filePart != null && filePart.getSize() > 0) {
                    String imageFileName = new File(filePart.getSubmittedFileName()).getName();
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    filePart.write(uploadPath + File.separator + imageFileName);
                    sql.append("productImageURL = ?, ");
                    params.add("uploads/" + imageFileName);
                }

                sql.setLength(sql.length() - 2); // Remove trailing comma
                sql.append(" WHERE productId = ?");
                params.add(productId);

                PreparedStatement stmt = con.prepareStatement(sql.toString());
                for (int i = 0; i < params.size(); i++) {
                    stmt.setObject(i + 1, params.get(i));
                }
                stmt.executeUpdate();
                out.println("<div class='alert alert-success'>Product updated successfully!</div>");
            } else if ("delete".equalsIgnoreCase(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                PreparedStatement stmt = con.prepareStatement("DELETE FROM product WHERE productId = ?");
                stmt.setInt(1, productId);
                stmt.executeUpdate();
                out.println("<div class='alert alert-success'>Product deleted successfully!</div>");
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        } finally {
            closeConnection();
        }
    }
%>

</body>
</html>