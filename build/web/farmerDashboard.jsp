<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession farmerSession = request.getSession(false);
    if (farmerSession == null || farmerSession.getAttribute("farmerId") == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Farmer Dashboard</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- Google Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:400,500,700">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: #ecf0f5;
            margin: 0;
            padding: 0;
        }
        /* Sidebar Styling */
        .sidebar {
            width: 260px;
            height: 100vh;
            position: fixed;
            background: #198754; /* Premium green */
            padding-top: 20px;
        }
        .sidebar h2 {
            color: #ecf0f1;
            text-align: center;
            margin-bottom: 30px;
            font-weight: 500;
            font-size: 1.4rem;
        }
        .sidebar a {
            display: block;
            color: #bdc3c7;
            padding: 12px 20px;
            text-decoration: none;
            transition: background 0.3s, color 0.3s;
            font-size: 1rem;
        }
        .sidebar a:hover {
            background: #145c32;
            color: #fff;
        }
        .sidebar .dropdown-toggle {
            cursor: pointer;
        }
        .sidebar .dropdown-menu {
            background: #145c32;
            border: none;
            margin-left: 15px;
        }
        .sidebar .dropdown-item {
            color: #bdc3c7;
            padding: 10px 15px;
        }
        .sidebar .dropdown-item:hover {
            background: #0d3d22;
            color: #fff;
        }
        .logout-link {
            margin: 20px;
            background: #e74c3c;
            text-align: center;
            border-radius: 4px;
            padding: 10px 0;
            color: #fff;
            text-decoration: none;
            transition: background 0.3s;
        }
        .logout-link:hover {
            background: #c0392b;
        }
        /* Main Content Styling */
        .content {
            margin-left: 280px;
            padding: 30px;
        }
        /* Premium Box Style */
        .box {
            background: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border: 1px solid #ddd;
            margin-bottom: 30px;
            overflow: hidden;
        }
        .box-header {
            background: linear-gradient(135deg, #28a745, #218838);
            padding: 15px 20px;
        }
        .box-header h3 {
            margin: 0;
            color: #fff;
            font-weight: 500;
        }
        .box-body {
            padding: 20px;
            color: #444;
            font-size: 1rem;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>Farmer Dashboard</h2>
        <a href="farmerDashboard.jsp">Dashboard</a>
        <a href="farmManagement.jsp">Farm Management</a>
        
        <!-- Dropdown for Animal Management -->
        <div class="dropdown">
            <a class="dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-expanded="false">Animal Management</a>
            <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="farmerAnimalManagement.jsp">Animal List</a></li>
                <li><a class="dropdown-item" href="farmerAnimalProduceManagement.jsp">Animal Produce</a></li>
            </ul>
        </div>
        
        <!-- Dropdown for Crop Management -->
        <div class="dropdown">
            <a class="dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-expanded="false">Crop Management</a>
            <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="farmerCropManagement.jsp">Crop List</a></li>
                <li><a class="dropdown-item" href="farmerCropProduceManagement.jsp">Crop Produce</a></li>
            </ul>
        </div>
        
        <a href="farmerToolList.jsp">Tool Management</a>
        <a href="LogoutServlet" class="logout-link">Logout</a>
    </div>

    <div class="content">
        <div class="box">
            <div class="box-header">
                <h3>Welcome, Farmer!</h3>
            </div>
            <div class="box-body">
                <div class="box" style="position: relative; text-align: center;">
                    <img src="image/pic_1.png" alt="Agriculture" style="width: 100%; height: auto; border-radius: 5px;">
                    <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); 
                                background: rgba(0, 0, 0, 0.6); color: white; padding: 20px; border-radius: 5px;">
                        <h3>Focus on a Sustainable Agricultural Ecosystem</h3>
                        <p>"Efficient farming requires more than just land and seeds. It demands access to tools, 
                            proper yield management, and collaboration within the community. Through our platform, we connect 
                            farmers with the resources they need to ensure more sustainable and productive agriculture."</p>
                    </div>
                </div>
            </div> 
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
