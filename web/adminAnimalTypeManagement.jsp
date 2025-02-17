<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, db.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <title>Admin Animal Type Management</title>
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
      <h3>Admin Animal Type Management</h3>
      <div>
        <a href="adminDashboard.jsp" class="btn btn-secondary">Go Back to Dashboard</a>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAnimalTypeModal">Add Animal Type</button>
      </div>
    </div>
    <div class="box-body">
      <table class="table">
        <thead>
          <tr>
             <th>ID</th>
             <th>Animal Type Name</th>
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
               String sql = "SELECT * FROM AnimalTypes";
               ps = conn.prepareStatement(sql);
               rs = ps.executeQuery();
               while(rs.next()){
           %>
           <tr>
             <td><%= rs.getInt("animal_type_id") %></td>
             <td><%= rs.getString("animal_type_name") %></td>
             <td>
               <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#editAnimalTypeModal<%= rs.getInt("animal_type_id") %>">Edit</button>
               <button class="btn btn-danger" onclick="confirmDelete(<%= rs.getInt("animal_type_id") %>)">Delete</button>
             </td>
           </tr>
           <!-- Edit Animal Type Modal -->
           <div class="modal fade" id="editAnimalTypeModal<%= rs.getInt("animal_type_id") %>" tabindex="-1" aria-hidden="true">
             <div class="modal-dialog">
               <div class="modal-content">
                 <div class="modal-header">
                   <h5 class="modal-title">Edit Animal Type</h5>
                   <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                 </div>
                 <div class="modal-body">
                   <form action="UpdateAnimalTypeServlet" method="post">
                     <input type="hidden" name="animal_type_id" value="<%= rs.getInt("animal_type_id") %>">
                     <div class="mb-3">
                       <label class="form-label">Animal Type Name</label>
                       <input type="text" class="form-control" name="animal_type_name" value="<%= rs.getString("animal_type_name") %>" required>
                     </div>
                     <button type="submit" class="btn btn-primary">Update Animal Type</button>
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
               if(rs != null) try{rs.close();} catch(Exception e){}
               if(ps != null) try{ps.close();} catch(Exception e){}
               if(conn != null) try{conn.close();} catch(Exception e){}
             }
           %>
        </tbody>
      </table>
    </div>
  </div>
</div>
<!-- Add Animal Type Modal -->
<div class="modal fade" id="addAnimalTypeModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Add Animal Type</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form action="AddAnimalTypeServlet" method="post">
          <div class="mb-3">
            <label class="form-label">Animal Type Name</label>
            <input type="text" class="form-control" name="animal_type_name" required>
          </div>
          <button type="submit" class="btn btn-primary">Add Animal Type</button>
        </form>
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

<!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteConfirmModalLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this animal type? This action cannot be undone.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a id="confirmDeleteBtn" href="#" class="btn btn-danger">Delete</a>
                </div>
            </div>
        </div>
    </div>
          
<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

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

function confirmDelete(animal_type_id) {
            // Set the delete URL dynamically
            document.getElementById("confirmDeleteBtn").href = "DeleteAnimalTypeServlet?id=" + animal_type_id;

            // Show the confirmation modal
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
            deleteModal.show();
        }
</script>

</body>
</html>
