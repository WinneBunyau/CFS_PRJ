<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, db.DBConnection, java.util.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    // Check if the farmer is logged in
    if(session == null || session.getAttribute("farmerId") == null){
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }
    int loggedFarmerId = ((Integer)session.getAttribute("farmerId")).intValue();

    // Retrieve crop types from the crop_type table into a Map
    Map<Integer, String> cropTypesMap = new HashMap<Integer, String>();
    Connection connCT = null;
    PreparedStatement psCT = null;
    ResultSet rsCT = null;
    try {
         connCT = DBConnection.getConnection();
         String sqlCT = "SELECT * FROM crop_type";
         psCT = connCT.prepareStatement(sqlCT);
         rsCT = psCT.executeQuery();
         while(rsCT.next()){
             cropTypesMap.put(rsCT.getInt("crop_type_id"), rsCT.getString("crop_type_name"));
         }
    } catch(Exception e){
         e.printStackTrace();
    } finally {
         if(rsCT != null) try { rsCT.close(); } catch(Exception e){}
         if(psCT != null) try { psCT.close(); } catch(Exception e){}
         if(connCT != null) try { connCT.close(); } catch(Exception e){}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Crop Management</title>
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
      <h3>My Crop Management</h3>
      <div>
        <a href="farmerDashboard.jsp" class="btn btn-secondary">Go Back to Dashboard</a>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCropModal">Add Crop</button>
      </div>
    </div>
    <div class="box-body">
      <table class="table table-bordered">
        <thead>
          <tr>
            <th>Crop ID</th>
            <th>Crop Type</th>
            <th>Planting Date</th>
            <th>Harvest Date</th>
            <th>Yield</th>
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
              String sql = "SELECT * FROM crops WHERE farmer_id = ?";
              ps = conn.prepareStatement(sql);
              ps.setInt(1, loggedFarmerId);
              rs = ps.executeQuery();
              while(rs.next()){
          %>
          <tr>
            <td><%= rs.getInt("crop_id") %></td>
            <td><%= rs.getString("crop_name") %></td>
            <td><%= rs.getDate("planting_date") %></td>
            <td><%= rs.getDate("harvest_date") %></td>
            <td><%= rs.getBigDecimal("yield") %></td>
            <td>
              <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#editCropModal<%= rs.getInt("crop_id") %>">Edit</button>
              <a href="DeleteCropServlet?id=<%= rs.getInt("crop_id") %>" class="btn btn-danger">Delete</a>
            </td>
          </tr>
          <!-- Edit Crop Modal -->
          <div class="modal fade" id="editCropModal<%= rs.getInt("crop_id") %>" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title">Edit Crop</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                  <form action="UpdateCropServlet" method="post">
                    <!-- Hidden crop_id and farmer_id -->
                    <input type="hidden" name="crop_id" value="<%= rs.getInt("crop_id") %>">
                    <input type="hidden" name="farmer_id" value="<%= loggedFarmerId %>">
                    
                    <div class="mb-3">
                      <label class="form-label">Crop Type</label>
                      <select class="form-control" name="crop_name" required>
                        <option value="">Select Crop Type</option>
                        <%
                          String currentCropName = rs.getString("crop_name");
                          for(Map.Entry<Integer, String> entry : cropTypesMap.entrySet()){
                            String typeName = entry.getValue();
                            String selected = typeName.equals(currentCropName) ? "selected" : "";
                        %>
                        <option value="<%= typeName %>" <%= selected %>><%= typeName %></option>
                        <% } %>
                      </select>
                    </div>
                    <div class="mb-3">
                      <label class="form-label">Planting Date</label>
                      <input type="date" class="form-control" name="planting_date" value="<%= rs.getDate("planting_date") %>" required>
                    </div>
                    <div class="mb-3">
                      <label class="form-label">Harvest Date</label>
                      <input type="date" class="form-control" name="harvest_date" value="<%= rs.getDate("harvest_date") %>">
                    </div>
                    <div class="mb-3">
                      <label class="form-label">Yield</label>
                      <input type="number" step="0.01" class="form-control" name="yield" value="<%= rs.getBigDecimal("yield") %>">
                    </div>
                    <button type="submit" class="btn btn-primary">Update Crop</button>
                  </form>
                </div>
              </div>
            </div>
          </div>
          <% 
              }
            } catch(Exception e){
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

<!-- Add Crop Modal -->
<div class="modal fade" id="addCropModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Add Crop</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <form action="AddCropServlet" method="post">
          <!-- Auto-fill farmer_id -->
          <input type="hidden" name="farmer_id" value="<%= loggedFarmerId %>">
          <div class="mb-3">
            <label class="form-label">Crop Type</label>
            <select class="form-control" name="crop_name" required>
              <option value="">Select Crop Type</option>
              <% 
                for(Map.Entry<Integer, String> entry : cropTypesMap.entrySet()){
              %>
              <option value="<%= entry.getValue() %>"><%= entry.getValue() %></option>
              <% } %>
            </select>
          </div>
          <div class="mb-3">
            <label class="form-label">Planting Date</label>
            <input type="date" class="form-control" name="planting_date" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Harvest Date</label>
            <input type="date" class="form-control" name="harvest_date">
          </div>
          <div class="mb-3">
            <label class="form-label">Yield</label>
            <input type="number" step="0.01" class="form-control" name="yield">
          </div>
          <button type="submit" class="btn btn-primary">Add Crop</button>
        </form>
      </div>
    </div>
  </div>
</div>

<!-- Success Modal -->
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