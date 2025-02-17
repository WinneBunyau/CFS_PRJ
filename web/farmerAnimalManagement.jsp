<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, db.DBConnection, java.util.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    // Check if a session exists and if a farmer is logged in.
    if(session == null || session.getAttribute("farmerId") == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }
    // Safely retrieve the logged-in farmer's ID.
    Integer loggedFarmerIdObj = (Integer) session.getAttribute("farmerId");
    int loggedFarmerId = loggedFarmerIdObj.intValue();

    // Retrieve allowed animal types from the AnimalTypes table.
    Map<Integer, String> animalTypesMap = new HashMap<Integer, String>();
    Connection conn2 = null;
    PreparedStatement ps2 = null;
    ResultSet rs2 = null;
    try {
        conn2 = DBConnection.getConnection();
        String sql2 = "SELECT * FROM AnimalTypes";
        ps2 = conn2.prepareStatement(sql2);
        rs2 = ps2.executeQuery();
        while(rs2.next()){
            animalTypesMap.put(rs2.getInt("animal_type_id"), rs2.getString("animal_type_name"));
        }
    } catch(Exception ex) {
        ex.printStackTrace();
    } finally {
        if(rs2 != null) try { rs2.close(); } catch(Exception e){}
        if(ps2 != null) try { ps2.close(); } catch(Exception e){}
        if(conn2 != null) try { conn2.close(); } catch(Exception e){}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Animal Management</title>
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
      <h3>My Animal Management</h3>
      <div>
        <a href="farmerDashboard.jsp" class="btn btn-secondary">Go Back to Dashboard</a>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAnimalModal">Add Animal</button>
      </div>
    </div>
    <div class="box-body">
      <table class="table table-bordered">
        <thead>
          <tr>
            <th>ID</th>
            <th>Animal Name</th>
            <th>Animal Type</th>
            <th>Birth Date</th>
            <th>Weight</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
              conn = DBConnection.getConnection();
              String sql = "SELECT * FROM Animals WHERE farmer_id = ?";
              ps = conn.prepareStatement(sql);
              ps.setInt(1, loggedFarmerId);
              rs = ps.executeQuery();
              while(rs.next()){
          %>
          <tr>
            <td><%= rs.getInt("animal_id") %></td>
            <td><%= rs.getString("animal_name") %></td>
            <td><%= animalTypesMap.get(rs.getInt("animal_type_id")) %></td>
            <td><%= rs.getDate("birth_date") %></td>
            <td><%= rs.getBigDecimal("weight") %></td>
            <td>
              <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#editAnimalModal<%= rs.getInt("animal_id") %>">Edit</button>
              <a href="DeleteAnimalServlet?id=<%= rs.getInt("animal_id") %>" class="btn btn-danger">Delete</a>
            </td>
          </tr>
          <!-- Edit Animal Modal -->
          <div class="modal fade" id="editAnimalModal<%= rs.getInt("animal_id") %>" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title">Edit Animal</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                  <form action="UpdateAnimalServlet" method="post">
                    <input type="hidden" name="animal_id" value="<%= rs.getInt("animal_id") %>">
                    <input type="hidden" name="farmer_id" value="<%= loggedFarmerId %>">
                    <div class="mb-3">
                      <label class="form-label">Animal Name</label>
                      <input type="text" class="form-control" name="animal_name" value="<%= rs.getString("animal_name") %>" required>
                    </div>
                    <div class="mb-3">
                      <label class="form-label">Animal Type</label>
                      <select class="form-control" name="animal_type_id" required>
                        <option value="">Select Animal Type</option>
                        <% 
                          for(Map.Entry<Integer, String> entry : animalTypesMap.entrySet()){
                            int typeId = entry.getKey();
                            String typeName = entry.getValue();
                            String selected = (typeId == rs.getInt("animal_type_id")) ? "selected" : "";
                        %>
                        <option value="<%= typeId %>" <%= selected %>><%= typeName %></option>
                        <% } %>
                      </select>
                    </div>
                    <div class="mb-3">
                      <label class="form-label">Birth Date</label>
                      <input type="date" class="form-control" name="birth_date" value="<%= rs.getDate("birth_date") %>" required>
                    </div>
                    <div class="mb-3">
                      <label class="form-label">Weight</label>
                      <input type="number" step="0.01" class="form-control" name="weight" value="<%= rs.getBigDecimal("weight") %>" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Update Animal</button>
                  </form>
                </div>
              </div>
            </div>
          </div>
          <% 
              }
            } catch(Exception e) {
              e.printStackTrace();
            } finally {
              if(rs != null) try { rs.close(); } catch(Exception e){}
              if(ps != null) try { ps.close(); } catch(Exception e){}
              if(conn != null) try { conn.close(); } catch(Exception e){}
            }
          %>
        </tbody>
      </table>
    </div>
  </div>
</div>
<!-- Add Animal Modal -->
<div class="modal fade" id="addAnimalModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Add Animal</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <form action="AddAnimalServlet" method="post">
          <input type="hidden" name="farmer_id" value="<%= loggedFarmerId %>">
          <div class="mb-3">
            <label class="form-label">Animal Name</label>
            <input type="text" class="form-control" name="animal_name" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Animal Type</label>
            <select class="form-control" name="animal_type_id" required>
              <option value="">Select Animal Type</option>
              <% for(Map.Entry<Integer, String> entry : animalTypesMap.entrySet()) { %>
              <option value="<%= entry.getKey() %>"><%= entry.getValue() %></option>
              <% } %>
            </select>
          </div>
          <div class="mb-3">
            <label class="form-label">Birth Date</label>
            <input type="date" class="form-control" name="birth_date" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Weight</label>
            <input type="number" step="0.01" class="form-control" name="weight" required>
          </div>
          <button type="submit" class="btn btn-primary">Add Animal</button>
        </form>
      </div>
    </div>
  </div>
</div>

<!-- success modal -->        
<div class="modal fade" id="successModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-success text-white">
        <h5 class="modal-title">Success</h5>
      </div>
      <div class="modal-body text-center">
        <p id="successMessage"></p>
      </div>
    </div>
  </div>
</div>


<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.addEventListener("DOMContentLoaded", function () {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('success')) {
      const message = urlParams.get('success');
      document.getElementById("successMessage").innerText = message;
      const successModal = new bootstrap.Modal(document.getElementById("successModal"));
      successModal.show();
      setTimeout(() => {
        successModal.hide();
      }, 2000);
    }
  });
  
</script>
</body>
</html>