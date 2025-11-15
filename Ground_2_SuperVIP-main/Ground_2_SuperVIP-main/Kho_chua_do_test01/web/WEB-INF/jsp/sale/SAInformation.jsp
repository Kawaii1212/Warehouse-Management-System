<%-- 
    Document   : SAInformation
    Created on : Nov 16, 2025, 12:16:05 AM
    Author     : Kawaii
--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thông tin cá nhân</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="css/sale/SAInformation.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="css/header.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sale/sale.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sale/SASentNoti.css">
    </head>

</head>

<body>
    <header class="header">
        <div class="header-main">
            <div class="logo">
                <div class="logo-icon">
                    <span class="icon-building"></span>
                </div>
                <span>WM</span>
            </div>
            <nav class="nav-menu">
                <a href="sale" class="nav-item">
                    <span class="icon-products"></span>
                    Hàng hóa
                </a>
                <a href="SAThongBao" class="nav-item">
                    <span class="icon-import"></span>
                    Gửi yêu cầu
                </a>
                <a href="sa-customer" class="nav-item">
                    <span class="icon-export"></span>
                    Khách hàng
                </a>

            </nav>

            <div class="header-right">
                <div class="user-dropdown">
                    <a href="#" class="user-icon gradient" id="dropdownToggle">
                        <i class="fas fa-user-circle fa-2x"></i>
                    </a>
                    <div class="dropdown-menu" id="dropdownMenu">
                        <a href="SAInformation" class="dropdown-item">Thông tin chi tiết</a>
                        <a href="Logout" class="dropdown-item">Đăng xuất</a>
                    </div>
                </div>      
            </div>

        </div>
    </header>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <%@ include file="../sale/SASlidebar.jsp" %>

            <!-- Nội dung chính -->
            <div class="col-md-9">
                <div class="card p-4">

                    <%  String msg = (String) request.getAttribute("msg");
                        String msgType = (String) request.getAttribute("msgType"); // success | danger | warning | info
                        if (msg != null) { %>
                    <div class="alert alert-<%= (msgType != null ? msgType : "info") %>">
                        <%= msg %>
                    </div>
                    <% } %>

                    <div class="card-header bg-white mb-3">
                        <i class="fa-solid fa-circle-info me-2 text-primary"></i>Thông tin cá nhân
                    </div>

                    <!-- Tên + vai trò -->
                    <div class="mb-3 text-center">
                        <h4 class="fw-bold mb-0">
                            <%= ((Model.User) request.getAttribute("user")).getFullName() %>
                        </h4>
                        <button class="btn btn-outline-primary btn-sm mt-1">
                            Nhân viên sale
                        </button>
                    </div>

                    <form action="SAInformation" method="post" class="needs-validation" novalidate>
                        <div class="row">
                            <!-- Cột trái -->
                            <div class="col-md-6">
                                <div class="info-section">
                                    <h6><i class="fa-regular fa-id-card me-2"></i>Thông tin cá nhân</h6>

                                    <!-- Mã người dùng -->
                                    <div class="mb-2">
                                        <label class="label-bold">Mã người dùng:</label>
                                        <span class="ms-2 text-secondary">#<%= ((Model.User) request.getAttribute("user")).getUserId() %></span>
                                    </div>

                                    <!-- Họ và tên -->
                                    <div class="mb-3">
                                        <label class="label-bold">Họ và tên:</label>
                                        <input type="text" class="form-control" name="fullName" 
                                               value="<%= ((Model.User) request.getAttribute("user")).getFullName() %>" required>
                                    </div>

                                    <!-- Giới tính -->
                                    <div class="mb-3">
                                        <label class="label-bold">Giới tính:</label>
                                        <select class="form-select" name="gender">
                                            <option value="1" <%= ((Model.User) request.getAttribute("user")).getGender() != null 
                                        && ((Model.User) request.getAttribute("user")).getGender() ? "selected" : "" %>>Nam</option>
                                            <option value="0" <%= ((Model.User) request.getAttribute("user")).getGender() != null 
                                        && !((Model.User) request.getAttribute("user")).getGender() ? "selected" : "" %>>Nữ</option>
                                        </select>
                                    </div>

                                    <!-- Ngày sinh -->
                                    <div class="mb-3">
                                        <label class="label-bold">Ngày sinh:</label>
                                        <input type="date" class="form-control" name="dob"
                                               value="<%= ((Model.User) request.getAttribute("user")).getDob() != null 
                                                        ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(((Model.User) request.getAttribute("user")).getDob()) 
                                                        : "" %>">
                                    </div>

                                    <!-- CCCD -->
                                    <div class="mb-3">
                                        <label class="label-bold">CCCD/Hộ chiếu:</label>
                                        <input type="text" class="form-control" name="identificationId" title="CCCD phải gồm đúng 12 chữ số" pattern="^\d{12}$"
                                               value="<%= ((Model.User) request.getAttribute("user")).getIdentificationId() != null 
                                                        ? ((Model.User) request.getAttribute("user")).getIdentificationId() 
                                                        : "" %>">
                                    </div>
                                </div>
                            </div>

                            <!-- Cột phải -->
                            <div class="col-md-6">
                                <div class="info-section">
                                    <h6><i class="fa-solid fa-address-book me-2"></i>Thông tin liên hệ</h6>



                                    <!-- Email -->
                                    <div class="mb-3">
                                        <label class="label-bold">Email:</label>
                                        <input type="email" class="form-control" name="email" 
                                               value="<%= ((Model.User) request.getAttribute("user")).getEmail() %>">
                                    </div>

                                    <!-- Số điện thoại -->
                                    <div class="mb-3">
                                        <label class="label-bold">Số điện thoại:</label>
                                        <input type="text" class="form-control" name="phone" title="Số điện thoại 10 số và bắt đầu bằng 0" pattern="^0\d{9}$"
                                               value="<%= ((Model.User) request.getAttribute("user")).getPhone() %>">
                                    </div>

                                    <!-- Địa chỉ -->
                                    <div class="mb-3">
                                        <label class="label-bold">Địa chỉ:</label>
                                        <input type="text" class="form-control" name="address" 
                                               value="<%= ((Model.User) request.getAttribute("user")).getAddress() %>">
                                    </div>

                                    <div class="mb-3">
                                        <label class="label-bold">Tên kho tổng:</label>
                                        <span class="badge bg-success ms-2">
                                            <%= ((Model.User) request.getAttribute("user")).getWarehouseName() != null 
                                                    ? ((Model.User) request.getAttribute("user")).getWarehouseName() 
                                                    : "Chưa có dữ liệu" %>
                                        </span>
                                    </div>

                                    <!-- Địa chỉ kho tổng -->
                                    <div class="mb-3">
                                        <label class="label-bold">Địa chỉ kho tổng:</label>
                                        <span class="badge bg-info ms-2">
                                            <%= request.getAttribute("warehouseAddress") != null
                                                  ? (String) request.getAttribute("warehouseAddress")
                                                  : "Chưa có dữ liệu" %>
                                        </span>
                                    </div>    

                                    <!-- 🟢 Trạng thái tài khoản -->
                                    <div class="mb-3">
                                        <label class="label-bold">Trạng thái tài khoản:</label>
                                        <%
                                            Integer status = ((Model.User) request.getAttribute("user")).getIsActive();
                                            String labelClass = "bg-secondary";
                                            String labelText = "Không xác định";

                                            if (status != null) {
switch (status) {
    case 1:
        labelClass = "bg-success";
        labelText = "Đang hoạt động";
        break;
    case 0:
        labelClass = "bg-danger";
        labelText = "Đã nghỉ việc";
        break;
    case 2:
        labelClass = "bg-warning text-dark";
        labelText = "Chờ phê duyệt";
        break;
    default:
        labelClass = "bg-secondary";
        labelText = "Không xác định";
        break;
}
}
                                        %>
                                        <span class="badge <%= labelClass %> ms-2"><%= labelText %></span>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <!-- Nút thao tác -->
                        <div class="text-end mt-3">
                            <button type="reset" class="btn btn-secondary me-2">
                                <i class="fa-solid fa-rotate-left me-1"></i>Hủy bỏ
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fa-solid fa-floppy-disk me-1"></i>Lưu thay đổi
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

