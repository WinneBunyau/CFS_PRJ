<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Farmer Management</title>
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
        .box-body {
            padding: 20px;
            color: #444;
            font-size: 1rem;
        }
        .box-header .btn {
            margin-left: 10px;
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
                <h3>Farmer Management</h3>
                <div>
                    <a href="adminDashboard.jsp" class="btn btn-secondary">Go Back to Dashboard</a>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addFarmerModal">Add Farmer</button>
                </div>
            </div>
            <div class="box-body">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Password</th>
                            <th>Phone</th>
                            <th>Address</th>
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
                            String sql = "SELECT * FROM Farmers";
                            ps = conn.prepareStatement(sql);
                            rs = ps.executeQuery();
                            while (rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getInt("farmerId") %></td>
                            <td><%= rs.getString("name") %></td>
                            <td><%= rs.getString("email") %></td>
                            <td><%= rs.getString("password") %></td> <!-- Password Visible -->
                            <td><%= rs.getString("phone") %></td>
                            <td><%= rs.getString("address") %></td>
                            <td>
                                <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#editFarmerModal<%= rs.getInt("farmerId") %>">Edit</button>
                                <button class="btn btn-danger" onclick="confirmDelete(<%= rs.getInt("farmerId") %>)">Delete</button>
                            </td>
                        </tr>
                        
                        <!-- Edit Farmer Modal -->
                        <div class="modal fade" id="editFarmerModal<%= rs.getInt("farmerId") %>" tabindex="-1" aria-labelledby="editFarmerModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Edit Farmer</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form action="UpdateFarmerServlet" method="post">
                                            <input type="hidden" name="farmerId" value="<%= rs.getInt("farmerId") %>">
                                            <div class="mb-3">
                                                <label class="form-label">Name</label>
                                                <input type="text" class="form-control" name="name" value="<%= rs.getString("name") %>" required>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Email</label>
                                                <input type="email" class="form-control" name="email" value="<%= rs.getString("email") %>" required>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Password</label>
                                                <input type="text" class="form-control" name="password" value="<%= rs.getString("password") %>" required>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Phone</label>
                                                <input type="text" class="form-control" name="phone" value="<%= rs.getString("phone") %>" required>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Address</label>
                                                <input type="text" class="form-control" name="address" value="<%= rs.getString("address") %>" required>
                                            </div>
                                            <button type="submit" class="btn btn-primary">Update Farmer</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% 
                            } 
                        } catch (SQLException e) {
                            e.printStackTrace();
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (ps != null) ps.close();
                                if (conn != null) conn.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
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
            <div class="toast-body" id="toastMessage">
                <!-- Message will be inserted here dynamically -->
            </div>
        </div>
    </div>

    <!-- Add Farmer Modal -->
    <div class="modal fade" id="addFarmerModal" tabindex="-1" aria-labelledby="addFarmerModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add Farmer</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="AddFarmerServlet" method="post">
                        <div class="mb-3">
                            <label class="form-label">Name</label>
                            <input type="text" class="form-control" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="text" class="form-control" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Phone</label>
                            <input type="text" class="form-control" name="phone" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Address</label>
                            <input type="text" class="form-control" name="address" required>
                        </div>
                        <button type="submit" class="btn btn-primary">Add Farmer</button>
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
                    Are you sure you want to delete this farmer? This action cannot be undone.
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
            const toastElement = document.getElementById('successToast');
            const toastMessage = document.getElementById('toastMessage');

            if (toastElement && toastMessage) {
                let message = "";

                if (urlParams.get('success') === 'added') {  
                    message = "Farmer added successfully!";
                } else if (urlParams.get('success') === 'updated') {  
                    message = "Farmer updated successfully!";
                } else if (urlParams.get('success') === 'deleted') {  
                    message = "Farmer deleted successfully!";
                }

                if (message) {
                    toastMessage.innerText = message;
                    const toast = new bootstrap.Toast(toastElement);
                    toast.show();
                }
            }

            if (urlParams.get('error') === 'add_failed') {  
                alert("Failed to add farmer. Please try again.");
            } else if (urlParams.get('error') === 'update_failed') {  
                alert("Failed to update farmer. Please try again.");
            } else if (urlParams.get('error') === 'delete_failed') {  
                alert("Failed to delete farmer. Please try again.");
            } else if (urlParams.get('error') === 'not_found') {  
                alert("Farmer not found.");
            }
        };

        function confirmDelete(farmerId) {
            // Set the delete URL dynamically
            document.getElementById("confirmDeleteBtn").href = "DeleteFarmerServlet?id=" + farmerId;

            // Show the confirmation modal
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
            deleteModal.show();
        }
    </script>

</body>
</html>
