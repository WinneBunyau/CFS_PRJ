<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, db.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Farm Management</title>
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
                <h3>Admin Farm Management</h3>
                <div>
                    <a href="adminDashboard.jsp" class="btn btn-secondary">Go Back to Dashboard</a>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addFarmModal">Add Farm</button>
                </div>
            </div>
            <div class="box-body">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Farm Name</th>
                            <th>Location</th>
                            <th>Size (acre)</th>
                            <th>Water Source</th>
                            <th>Rent Duration (/month)</th>
                            <th>Rent Amt (RM/month)</th>
                            <th>Status</th>
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
                            String sql = "SELECT * FROM Farms";
                            ps = conn.prepareStatement(sql);
                            rs = ps.executeQuery();
                            while (rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getInt("farmId") %></td>
                            <td><%= rs.getString("farm_name") %></td>
                            <td><%= rs.getString("farm_location") %></td>
                            <td><%= rs.getBigDecimal("farm_size") %></td>
                            <td><%= rs.getString("water_source") %></td>
                            <td><%= rs.getString("rent_duration") %></td>
                            <td><%= rs.getBigDecimal("rent_amt") %></td>
                            <td><%= rs.getString("status") %></td>
                            <td>
                                <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#editFarmModal<%= rs.getInt("farmId") %>">Edit</button>
                                <!-- Delete Button with Modal Trigger -->
                                <button class="btn btn-danger" onclick="confirmDelete(<%= rs.getInt("farmId") %>)">Delete</button>

                            </td>
                        </tr>
                        <!-- Edit Farm Modal -->
                        <div class="modal fade" id="editFarmModal<%= rs.getInt("farmId") %>" tabindex="-1" aria-labelledby="editFarmModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header bg-warning text-dark">
                                        <h5 class="modal-title">Edit Farm</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form action="UpdateFarmServlet" method="post">
                                            <input type="hidden" name="farmId" value="<%= rs.getInt("farmId") %>">
                                            <div class="row">
                                                <!-- Farm Name -->
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Farm Name</label>
                                                    <input type="text" class="form-control" name="farm_name" value="<%= rs.getString("farm_name") %>" required>
                                                </div>
                                                <!-- Location -->
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Location</label>
                                                    <input type="text" class="form-control" name="farm_location" value="<%= rs.getString("farm_location") %>" required>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <!-- Size -->
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Size (acre)</label>
                                                    <input type="number" step="0.01" class="form-control" name="farm_size" value="<%= rs.getBigDecimal("farm_size") %>" required>
                                                </div>
                                                <!-- Water Source -->
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Water Source</label>
                                                    <input type="text" class="form-control" name="water_source" value="<%= rs.getString("water_source") %>">
                                                </div>
                                            </div>
                                            <div class="row">
                                                <!-- Rent Duration -->
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Rent Duration (/month)</label>
                                                    <input type="text" class="form-control" name="rent_duration" value="<%= rs.getString("rent_duration") %>">
                                                </div>
                                                <!-- Rent Amount -->
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Rent Amt (RM/month)</label>
                                                    <input type="number" step="0.01" class="form-control" name="rent_amt" value="<%= rs.getBigDecimal("rent_amt") %>">
                                                </div>
                                            </div>
                                            <div class="row">
                                                <!-- Status -->
                                                <div class="col-md-12 mb-3">
                                                    <label class="form-label">Status</label>
                                                    <select class="form-control" name="status" required>
                                                        <option value="available" <%= "available".equals(rs.getString("status")) ? "selected" : "" %>>Available</option>
                                                        <option value="rented" <%= "rented".equals(rs.getString("status")) ? "selected" : "" %>>Rented</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <!-- Update Farm Button -->
                                            <button type="submit" class="btn btn-success w-100">Update Farm</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <% 
                            } 
                        } catch (Exception e) {
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
                    
    <!-- Success Toast -->
    <div class="toast-container position-absolute top-0 start-50 translate-middle-x p-3">
        <div class="toast" id="successToast" role="alert" aria-live="assertive" aria-atomic="true" style="width: 350px; font-size: 1.2rem;">
            <div class="toast-header">
                <strong class="me-auto text-success">Success</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                Farm has been successfully updated!
            </div>
        </div>
    </div>
    
    <!-- Success Toast for Add Farm -->
    <div class="toast-container position-absolute top-0 start-50 translate-middle-x p-3">
        <div class="toast" id="addSuccessToast" role="alert" aria-live="assertive" aria-atomic="true" style="width: 350px; font-size: 1.2rem;">
            <div class="toast-header">
                <strong class="me-auto text-success">Success</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                Farm added successfully!
            </div>
        </div>
    </div>
    
    <!-- Success Toast for Delete Farm -->
    <div class="toast-container position-absolute top-0 start-50 translate-middle-x p-3">
        <div class="toast" id="deleteSuccessToast" role="alert" aria-live="assertive" aria-atomic="true" style="width: 350px; font-size: 1.2rem;">
            <div class="toast-header">
                <strong class="me-auto text-danger">Deleted</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                Farm deleted successfully!
            </div>
        </div>
    </div>


    <!-- Add Farm Modal -->
<div class="modal fade" id="addFarmModal" tabindex="-1" aria-labelledby="addFarmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <!-- Stylish Header (Deep Blue) -->
            <div class="modal-header text-white" style="background: linear-gradient(135deg, #1a237e, #0d47a1);">
                <h5 class="modal-title fw-bold">➕ Add a New Farm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <!-- Form Body -->
            <div class="modal-body px-4">
                <form action="AddFarmServlet" method="post">
                    <div class="row g-3">
                        <!-- Farm Name -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Farm Name</label>
                            <input type="text" class="form-control" name="farm_name" placeholder="Enter farm name" required>
                        </div>
                        <!-- Location -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Location</label>
                            <input type="text" class="form-control" name="farm_location" placeholder="Enter location" required>
                        </div>
                    </div>

                    <div class="row g-3 mt-2">
                        <!-- Size -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Size (acre)</label>
                            <input type="number" step="0.01" class="form-control" name="farm_size" placeholder="e.g. 2.5" required>
                        </div>
                        <!-- Water Source -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Water Source</label>
                            <input type="text" class="form-control" name="water_source" placeholder="e.g. River, Well">
                        </div>
                    </div>

                    <div class="row g-3 mt-2">
                        <!-- Rent Duration -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Rent Duration (Months)</label>
                            <input type="text" class="form-control" name="rent_duration" placeholder="e.g. 12">
                        </div>
                        <!-- Rent Amount -->
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Rent Amount (RM/month)</label>
                            <input type="number" step="0.01" class="form-control" name="rent_amt" placeholder="e.g. 1500">
                        </div>
                    </div>

                    <!-- Status -->
                    <div class="mt-3">
                        <label class="form-label fw-semibold">Status</label>
                        <select class="form-select" name="status" required>
                            <option value="available">Available</option>
                            <option value="rented">Rented</option>
                        </select>
                    </div>

                    <!-- Submit Button -->
                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary w-100 fw-bold" style="background-color: #0d47a1; border: none;">
                            ➕ Add Farm
                        </button>
                    </div>
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
                Are you sure you want to delete this farm? This action cannot be undone.
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
        const urlParams = new URLSearchParams(window.location.search);

        // Show success toast if farm was added, updated, or deleted
        if (urlParams.get('addSuccess') === 'true') {
            const toast = new bootstrap.Toast(document.getElementById('addSuccessToast'));
            toast.show(); // Show the add farm success toast
        } else if (urlParams.get('updateSuccess') === 'true') {
            const toast = new bootstrap.Toast(document.getElementById('successToast'));
            toast.show(); // Show the update farm success toast
        } else if (urlParams.get('deleteSuccess') === 'true') {
            const toast = new bootstrap.Toast(document.getElementById('deleteSuccessToast'));
            toast.show(); // Show the delete farm success toast
        }
    };
</script>
<script>
    function confirmDelete(farmId) {
        // Set the delete URL dynamically
        document.getElementById("confirmDeleteBtn").href = "DeleteFarmServlet?id=" + farmId;
        
        // Show the confirmation modal
        var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
        deleteModal.show();
    }
</script>


</body>
</html>
