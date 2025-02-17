<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    // Use the implicit session object
    if (session == null || session.getAttribute("farmerId") == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tool Management</title>
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
        .container {
            max-width: 1200px;
        }
        /* Premium Box Style */
        .box {
            background: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border: 1px solid #ddd;
            overflow: hidden;
            margin-bottom: 30px;
        }
        .box-header {
            background: linear-gradient(135deg, #f39c12, #d35400);
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .box-header h3 {
            margin: 0;
            color: #fff;
            font-weight: 500;
            font-size: 1.5rem;
        }
        .box-header .btn {
            margin-left: 10px;
        }
        .box-body {
            padding: 20px;
            color: #444;
            font-size: 1rem;
        }
        /* Premium Table Style */
        .table {
            margin-bottom: 0;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
<div class="container mt-5">
  <div class="box">
    <div class="box-header">
      <h3>Tool Management</h3>
      <div>
        <a href="farmerDashboard.jsp" class="btn btn-secondary">Go Back to Dashboard</a>
      </div>
    </div>
    <div class="box-body">
      <table class="table table-bordered">
        <thead>
          <tr>
            <th>ID</th>
            <th>Tool Name</th>
            <th>Type</th>
            <th>Rental Duration</th>
            <th>Rental Amt (RM/month)</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
              conn = DBConnection.getConnection();
              // Show all tools regardless of status
              String sql = "SELECT * FROM Tools";
              ps = conn.prepareStatement(sql);
              rs = ps.executeQuery();
              while(rs.next()){
          %>
          <tr>
            <td><%= rs.getInt("toolId") %></td>
            <td><%= rs.getString("tool_name") %></td>
            <td><%= rs.getString("tool_type") %></td>
            <td><%= rs.getString("rental_duration") %></td>
            <td><%= rs.getBigDecimal("rental_amt") %></td>
            <td><%= rs.getString("status") %></td>
            <td>
              <% if("available".equalsIgnoreCase(rs.getString("status"))) { %>
                <a href="PaymentTool.jsp?toolId=<%= rs.getInt("toolId") %>" class="btn btn-success">Rent</a>
              <% } else { %>
                <button class="btn btn-secondary" disabled>Rented</button>
              <% } %>
            </td>
          </tr>
          <%
              }
            } catch(Exception e) {
              e.printStackTrace();
            } finally {
              if(rs != null) try { rs.close(); } catch(Exception e) {}
              if(ps != null) try { ps.close(); } catch(Exception e) {}
              if(conn != null) try { conn.close(); } catch(Exception e) {}
            }
          %>
        </tbody>
      </table>
    </div>
  </div>
</div>
<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>