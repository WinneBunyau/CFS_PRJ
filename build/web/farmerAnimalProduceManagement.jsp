<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, db.DBConnection" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    // Check if the session exists and a farmer is logged in
    if(session == null || session.getAttribute("farmerId") == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }
    int loggedFarmerId = ((Integer)session.getAttribute("farmerId")).intValue();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Animal Produce Management</title>
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
      <h3>My Animal Produce Management</h3>
      <div>
        <a href="farmerDashboard.jsp" class="btn btn-secondary">Go Back to Dashboard</a>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProduceModal">Add Produce</button>
      </div>
    </div>
    <div class="box-body">
      <table class="table table-bordered">
        <thead>
          <tr>
            <th>ID</th>
            <th>Animal ID</th>
            <th>Animal Name</th>
            <th>Animal Type</th>
            <th>Quantity</th>
            <th>Produce Date</th>
            <th>Storage Location</th>
            <th>Produce Type</th>
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
              // Join AnimalProduce, Animals, and AnimalTypes to get animal name and type
              String sql = "SELECT ap.animal_produce_id, ap.animal_id, ap.quantity, ap.animal_produce_date, ap.animal_storage_location, ap.animal_produce_type, " +
                           "a.animal_name, t.animal_type_name " +
                           "FROM AnimalProduce ap " +
                           "JOIN Animals a ON ap.animal_id = a.animal_id " +
                           "LEFT JOIN AnimalTypes t ON a.animal_type_id = t.animal_type_id " +
                           "WHERE a.farmer_id = ?";
              ps = conn.prepareStatement(sql);
              ps.setInt(1, loggedFarmerId);
              rs = ps.executeQuery();
              while(rs.next()){
          %>
          <tr>
            <td><%= rs.getInt("animal_produce_id") %></td>
            <td><%= rs.getInt("animal_id") %></td>
            <td><%= rs.getString("animal_name") %></td>
            <td><%= rs.getString("animal_type_name") != null ? rs.getString("animal_type_name") : "N/A" %></td>
            <td><%= rs.getBigDecimal("quantity") %></td>
            <td><%= rs.getDate("animal_produce_date") %></td>
            <td><%= rs.getString("animal_storage_location") %></td>
            <td><%= rs.getString("animal_produce_type") %></td>
            <td>
              <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#editProduceModal<%= rs.getInt("animal_produce_id") %>">Edit</button>
              <a href="DeleteAnimalProduceServlet?id=<%= rs.getInt("animal_produce_id") %>" class="btn btn-danger">Delete</a>
            </td>
          </tr>
          <!-- Edit Produce Modal -->
          <div class="modal fade" id="editProduceModal<%= rs.getInt("animal_produce_id") %>" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title">Edit Produce</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  <form action="UpdateAnimalProduceServlet" method="post">
                    <input type="hidden" name="animal_produce_id" value="<%= rs.getInt("animal_produce_id") %>">
                    <div class="mb-3">
                      <label class="form-label">Animal ID</label>
                      <input type="number" class="form-control" name="animal_id" value="<%= rs.getInt("animal_id") %>" required>
                    </div>
                    <div class="mb-3">
                      <label class="form-label">Quantity</label>
                      <input type="number" step="0.01" class="form-control" name="quantity" value="<%= rs.getBigDecimal("quantity") %>" required>
                    </div>
                    <div class="mb-3">
                      <label class="form-label">Produce Date</label>
                      <input type="date" class="form-control" name="animal_produce_date" value="<%= rs.getDate("animal_produce_date") %>" required>
                    </div>
                    <div class="mb-3">
                      <label class="form-label">Storage Location</label>
                      <input type="text" class="form-control" name="animal_storage_location" value="<%= rs.getString("animal_storage_location") %>" required>
                    </div>
                    <div class="mb-3">
                      <label class="form-label">Produce Type</label>
                      <input type="text" class="form-control" name="animal_produce_type" value="<%= rs.getString("animal_produce_type") %>" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Update Produce</button>
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

<!-- Add Produce Modal -->
<div class="modal fade" id="addProduceModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Add Animal Produce</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form action="AddAnimalProduceServlet" method="post">
          <div class="mb-3">
            <label class="form-label">Animal ID</label>
            <input type="number" class="form-control" name="animal_id" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Quantity</label>
            <input type="number" step="0.01" class="form-control" name="quantity" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Produce Date</label>
            <input type="date" class="form-control" name="animal_produce_date" value="<%= new java.sql.Date(System.currentTimeMillis()) %>" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Storage Location</label>
            <input type="text" class="form-control" name="animal_storage_location" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Produce Type</label>
            <input type="text" class="form-control" name="animal_produce_type" required>
          </div>
          <button type="submit" class="btn btn-primary">Add Produce</button>
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