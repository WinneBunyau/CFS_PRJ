<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    if(session == null || session.getAttribute("farmerId") == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }
    int toolId = Integer.parseInt(request.getParameter("toolId"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Secure Tool Payment</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f5f5f5;
        }
        .payment-container {
            max-width: 400px;
            margin: 50px auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }
        .btn-primary {
            background-color: #0056b3;
            border-color: #004085;
        }
        .btn-primary:hover {
            background-color: #004085;
        }
        .form-control {
            border-radius: 8px;
        }
        .form-label {
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="payment-container">
        <h2 class="text-center">Secure Tool Payment</h2>
        <p class="text-center text-muted">Enter your Visa card details to proceed</p>

        <form action="PaymentToolServlet" method="post">
            <input type="hidden" name="toolId" value="<%= toolId %>">
            
            <div class="mb-3">
                <label for="cardNumber" class="form-label">Visa Card Number</label>
                <input type="text" class="form-control" id="cardNumber" name="cardNumber" 
                       placeholder="1234 5678 9012 3456" required 
                       pattern="[0-9]{16}" title="Enter a valid 16-digit Visa card number">
            </div>

            <div class="mb-3">
                <label for="expiry" class="form-label">Expiry Date (MM/YY)</label>
                <input type="text" class="form-control" id="expiry" name="expiry" 
                       placeholder="MM/YY" required 
                       pattern="(0[1-9]|1[0-2])\/[0-9]{2}" title="Enter a valid expiry date (MM/YY)">
            </div>

            <div class="mb-3">
                <label for="cvv" class="form-label">CVV</label>
                <input type="text" class="form-control" id="cvv" name="cvv" 
                       placeholder="123" required 
                       pattern="[0-9]{3}" title="Enter a 3-digit CVV">
            </div>

            <button type="submit" class="btn btn-primary w-100">Submit Payment</button>
            <a href="farmerToolList.jsp" class="btn btn-secondary w-100 mt-2">Cancel</a>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
