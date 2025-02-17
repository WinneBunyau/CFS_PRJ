<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background: #f4f4f4;
            display: flex;
            height: 100vh;
            justify-content: center;
            align-items: center;
        }
        .login-container {
            background: #fff;
            padding: 3rem;
            border-radius: 12px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            text-align: center;
        }
        .login-container h1 {
            font-size: 2.5rem;
            margin-bottom: 2rem;
            font-weight: bold;
        }
        .form-control {
            height: 55px;
            font-size: 1.2rem;
        }
        .btn-login {
            background-color: #007bff;
            border: none;
            padding: 12px;
            font-size: 1.2rem;
        }
        .btn-login:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Admin Login</h1>
        <form action="AdminLoginServlet" method="post">
            <div class="mb-4">
                <input type="text" name="username" class="form-control" required placeholder="Enter Username">
            </div>
            <div class="mb-4">
                <input type="password" name="password" class="form-control" required placeholder="Enter Password">
            </div>
            <button type="submit" class="btn btn-login w-100 text-white">Login</button>
        </form>
    </div>
</body>
</html>
