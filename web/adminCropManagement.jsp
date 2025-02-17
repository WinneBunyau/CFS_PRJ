<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, db.DBConnection, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <title>Admin Crop Management</title>
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
      <h3>Admin Crop Management</h3>
      <div>
        <a href="adminDashboard.jsp" class="btn btn-secondary">Go Back to Dashboard</a>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCropModal">Add Crop</button>
      </div>
    </div>
    <div class="box-body">
      <%-- Retrieve allowed crop types into a map for dropdowns --%>
      <%
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
        } catch(Exception ex) {
          ex.printStackTrace();
        } finally {
          if(rsCT != null) try { rsCT.close(); } catch(Exception e){}
          if(psCT != null) try { psCT.close(); } catch(Exception e){}
          if(connCT != null) try { connCT.close(); } catch(Exception e){}
        }
      %>
      
      <table class="table">
        <thead>
          <tr>
             <th>Crop ID</th>
             <th>Crop Type</th>
             <th>Farmer ID</th>
             <th>Farmer Name</th>
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
              // Join crops with Farmers to obtain the farmer's name
              String sql = "SELECT c.*, f.name AS farmer_name FROM crops c JOIN Farmers f ON c.farmer_id = f.farmerId";
              ps = conn.prepareStatement(sql);
              rs = ps.executeQuery();
              while(rs.next()){
          %>
          <tr>
             <td><%= rs.getInt("crop_id") %></td>
             <td><%= rs.getString("crop_name") %></td>
             <td><%= rs.getInt("farmer_id") %></td>
             <td><%= rs.getString("farmer_name") %></td>
             <td><%= rs.getDate("planting_date") %></td>
             <td><%= rs.getDate("harvest_date") %></td>
             <td><%= rs.getBigDecimal("yield") %></td>
             <td>
               <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#editCropModal<%= rs.getInt("crop_id") %>">Edit</button>
               <button class="btn btn-danger" onclick="confirmDelete(<%= rs.getInt("crop_id") %>)">Delete</button>
             </td>
          </tr>
          <!-- Edit Crop Modal -->
          <div class="modal fade" id="editCropModal<%= rs.getInt("crop_id") %>" tabindex="-1" aria-hidden="true">
             <div class="modal-dialog">
               <div class="modal-content">
                 <div class="modal-header">
                   <h5 class="modal-title">Edit Crop</h5>
                   <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                 </div>
                 <div class="modal-body">
                   <form action="UpdateCropServlet" method="post">
                     <!-- Hidden fields for crop_id and farmer_id -->
                     <input type="hidden" name="crop_id" value="<%= rs.getInt("crop_id") %>">
                     <input type="hidden" name="farmer_id" value="<%= rs.getInt("farmer_id") %>">
                     
                     <div class="mb-3">
                       <label class="form-label">Farmer ID</label>
                       <input type="number" class="form-control" name="farmer_id_display" value="<%= rs.getInt("farmer_id") %>" disabled>
                     </div>
                     <div class="mb-3">
                       <label class="form-label">Farmer Name</label>
                       <input type="text" class="form-control" value="<%= rs.getString("farmer_name") %>" disabled>
                     </div>
                     <div class="mb-3">
                       <label class="form-label">Crop Type</label>
                       <select class="form-control" name="crop_name" required>
                         <option value="">Select Crop Type</option>
                         <% 
                           for(Map.Entry<Integer, String> entry : cropTypesMap.entrySet()){
                             String selected = "";
                             if(entry.getValue().equals(rs.getString("crop_name"))) {
                               selected = "selected";
                             }
                         %>
                         <option value="<%= entry.getValue() %>" <%= selected %>><%= entry.getValue() %></option>
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

<!-- Add Crop Modal -->
<div class="modal fade" id="addCropModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Add Crop</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form action="AddCropServlet" method="post">
          <div class="mb-3">
            <label class="form-label">Farmer ID</label>
            <input type="number" class="form-control" name="farmer_id" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Crop Type</label>
            <select class="form-control" name="crop_name" required>
              <option value="">Select Crop Type</option>
              <% for(Map.Entry<Integer, String> entry : cropTypesMap.entrySet()) { %>
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
            
<!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteConfirmModalLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this crop ? This action cannot be undone.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a id="confirmDeleteBtn" href="#" class="btn btn-danger">Delete</a>
                </div>
            </div>
        </div>
    </div>
            
<!-- Success Modal -->
<div class="modal fade" id="successModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Success</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p id="successMessage"></p>
      </div>
    </div>
  </div>
</div>

<script>
window.onload = function() {
    var urlParams = new URLSearchParams(window.location.search);
    var successMessage = urlParams.get('success');
    
    if (successMessage) {
        var successMessageElement = document.getElementById('successMessage');
        successMessageElement.textContent = successMessage;
        var successModal = new bootstrap.Modal(document.getElementById('successModal'));
        successModal.show();
    }
};
    function confirmDelete(crop_id) {
            // Set the delete URL dynamically
            document.getElementById("confirmDeleteBtn").href = "DeleteCropServlet?id=" + crop_id;

            // Show the confirmation modal
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
            deleteModal.show();
        }
    
</script>



<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
