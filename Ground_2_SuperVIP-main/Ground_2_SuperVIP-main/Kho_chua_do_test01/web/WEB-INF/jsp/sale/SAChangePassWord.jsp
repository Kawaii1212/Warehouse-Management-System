<%-- 
    Document   : SAChangePassWord
    Created on : Nov 16, 2025, 1:53:27 AM
    Author     : Kawaii
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đổi mật khẩu</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="css/warehouse/SAChangePassWord.css" rel="stylesheet" type="text/css"/>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sale/sale.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sale/SASentNoti.css">

    </head>
<style> /* Sidebar Styling */ .sidebar { width: 300px; } .sidebar-link { display: flex; align-items: center; color: #374151; text-decoration: none; padding: 8px 12px; border-radius: 6px; margin-bottom: 4px; transition: all 0.2s; } .sidebar-link:hover { background-color: #eff6ff; color: #2563eb; } .sidebar-link.active { background-color: #dbeafe; color: #2563eb; font-weight: 600; } /* Card & Form */ .card { border-radius: 10px; border: none; } .form-control { border-radius: 8px; } .alert { border-radius: 8px; } </style>
    <body>    <header class="header">
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
                <div class="col-md-3">
    <div class="sidebar p-3 bg-white shadow-sm rounded">
        <h6 class="text-secondary mb-3">Gian hàng</h6>
        <a href="SAInformation" class="sidebar-link <%= request.getRequestURI().contains("InformationAccount") ? "active" : "" %>">
            <i class="bi bi-info-circle me-2"></i> Thông tin tài khoản
        </a>
        <a href="SAChangePassWord" class="sidebar-link <%= request.getRequestURI().contains("ChangePassword") ? "active" : "" %>">
            <i class="bi bi-lock me-2"></i> Đổi mật khẩu
        </a>
        

    </div>
</div>

                <!-- Nội dung chính -->
                <div class="col-md-9">
                    <div class="card p-4">
                        <div class="card-header bg-white mb-3">
                            <i class="fa-solid fa-lock me-2 text-primary"></i>Đổi mật khẩu
                        </div>

                        <% String msg = (String) request.getAttribute("message");
   String type = (String) request.getAttribute("msgType");
   if (msg != null && type != null) { %>
                        <div class="alert alert-<%= type %> alert-dismissible fade show" role="alert">
                            <%= msg %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% } %>

                        <div class="alert alert-info">
                            <i class="fa-solid fa-shield-halved me-2"></i>
                            <strong>Bảo mật tài khoản:</strong>
                            Để đảm bảo an toàn cho tài khoản, vui lòng chọn mật khẩu mạnh và không chia sẻ với bất kỳ ai.
                            Mật khẩu mới phải khác với mật khẩu hiện tại.
                        </div>

                        <form action="SAChangePassWord" method="post">
                            <div class="mb-3">
                                <label class="label-bold">Mật khẩu hiện tại <span class="required">*</span></label>
                                <input type="password" class="form-control" name="currentPassword" placeholder="Nhập mật khẩu hiện tại...">
                            </div>

                            <div class="mb-3">
                                <label class="label-bold">Mật khẩu mới <span class="required">*</span></label>
                                <input type="password" class="form-control" name="newPassword" placeholder="Nhập mật khẩu mới...">
                            </div>

                            <div class="mb-4">
                                <label class="label-bold">Xác nhận mật khẩu mới <span class="required">*</span></label>
                                <input type="password" class="form-control" name="confirmPassword" placeholder="Xác nhận mật khẩu mới...">
                            </div>

                            <div class="text-end">
                                <button type="reset" class="btn-cancel me-2">
                                    <i class="fa-solid fa-rotate-left me-1"></i> Hủy bỏ
                                </button>
                                <button type="submit" class="btn-save">
                                    <i class="fa-solid fa-key me-1"></i> Đổi mật khẩu
                                </button>
                            </div>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

