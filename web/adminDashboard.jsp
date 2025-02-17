<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, db.DBConnection" %>
<%
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || adminSession.getAttribute("adminId") == null) {
        response.sendRedirect("adminLogin.jsp?error=Please login first");
        return;
    }

    int totalFarms = 0;
    int totalAnimals = 0;
    int totalCrops = 0;
    double totalAnimalProduce = 0;
    double totalCropProduce = 0;

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        stmt = conn.createStatement();

        // Get total farms
        rs = stmt.executeQuery("SELECT COUNT(*) FROM Farms");
        if (rs.next()) totalFarms = rs.getInt(1);
        rs.close();

        // Get total animals
        rs = stmt.executeQuery("SELECT COUNT(*) FROM Animals");
        if (rs.next()) totalAnimals = rs.getInt(1);
        rs.close();

        // Get total crops
        rs = stmt.executeQuery("SELECT COUNT(*) FROM Crops");
        if (rs.next()) totalCrops = rs.getInt(1);
        rs.close();

        // Get total animal produce (kg)
        rs = stmt.executeQuery("SELECT COALESCE(SUM(quantity), 0) FROM AnimalProduce");
        if (rs.next()) totalAnimalProduce = rs.getDouble(1);
        rs.close();

        // Get total crop produce (kg)
        rs = stmt.executeQuery("SELECT COALESCE(SUM(quantity), 0) FROM crop_produce");
        if (rs.next()) totalCropProduce = rs.getDouble(1);
        
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
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
            background: #2c3e50;
            box-shadow: 2px 0 8px rgba(0, 0, 0, 0.15);
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
            background: #34495e;
            color: #fff;
        }
        .sidebar .dropdown-toggle {
            cursor: pointer;
        }
        .sidebar .dropdown-menu {
            background: #34495e;
            border: none;
            margin-left: 15px;
        }
        .sidebar .dropdown-item {
            color: #bdc3c7;
            padding: 10px 15px;
        }
        .sidebar .dropdown-item:hover {
            background: #3b5998;
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
            background: linear-gradient(135deg, #f39c12, #d35400);
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
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>Admin Panel</h2>
        <a href="adminDashboard.jsp">Dashboard</a>
        <a href="farmerManagement.jsp">Farmer Management</a>
        <a href="adminFarmManagement.jsp">Farm Management</a>
        
        <!-- Dropdown for Animal Management -->
        <div class="dropdown">
            <a class="dropdown-toggle" data-bs-toggle="dropdown">Animal Management</a>
            <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="adminAnimalManagement.jsp">Animal List</a></li>
                <li><a class="dropdown-item" href="adminAnimalTypeManagement.jsp">Animal Types</a></li>
                <li><a class="dropdown-item" href="adminAnimalProduceManagement.jsp">Animal Produce</a></li>
            </ul>
        </div>

        <!-- Dropdown for Crop Management -->
        <div class="dropdown">
            <a class="dropdown-toggle" data-bs-toggle="dropdown">Crop Management</a>
            <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="adminCropManagement.jsp">Crop List</a></li>
                <li><a class="dropdown-item" href="adminCropTypeManagement.jsp">Crop Types</a></li>
                <li><a class="dropdown-item" href="adminCropProduceManagement.jsp">Crop Produce</a></li>
            </ul>
        </div>

        <a href="adminToolManagement.jsp">Tool Management</a>
        <a href="LogoutServlet" class="logout-link">Logout</a>
    </div>

    <!-- Main Content -->
    <div class="content">
        <div class="box">
            <div class="box-header">
                <h3>Welcome, Admin!</h3>
            </div>
            <div class="box-body">
                <div class="row">
                    <div class="col-md-4">
                        <div class="box">
                            <h3>Total Farms</h3>
                            <h5><%= totalFarms %></h5>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="box">
                            <h3>Total Animals</h3>
                            <h5><%= totalAnimals %></h5>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="box">
                            <h3>Total Crops</h3>
                            <h5><%= totalCrops %></h5>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
                
<!-- Bootstrap JS (Letak sebelum </body>) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>