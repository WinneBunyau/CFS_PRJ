<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Farmer Registration</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center">Farmer Registration</h1>
        
        <%-- Display error or success messages if available --%>
        <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger"><%= request.getParameter("error") %></div>
        <% } else if(request.getParameter("success") != null) { %>
            <div class="alert alert-success"><%= request.getParameter("success") %></div>
        <% } %>
        
        <form action="RegisterServlet" method="post" class="w-50 mx-auto mt-3">
            <div class="mb-3">
                <label class="form-label">Full Name:</label>
                <input type="text" name="name" class="form-control" placeholder="Enter your full name" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Email:</label>
                <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Password:</label>
                <input type="password" name="password" class="form-control" placeholder="Enter a password" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Phone:</label>
                <input type="text" name="phone" class="form-control" placeholder="Enter your phone number">
            </div>
            <div class="mb-3">
                <label class="form-label">Address:</label>
                <textarea name="address" class="form-control" placeholder="Enter your address"></textarea>
            </div>
            <button type="submit" class="btn btn-success w-100">Register</button>
        </form>
        
        <div class="text-center mt-3">
            <a href="index.jsp" class="btn btn-outline-success">Back to Home</a>
            <p class="mt-2">Already have an account? <a href="login.jsp">Login here</a></p>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
