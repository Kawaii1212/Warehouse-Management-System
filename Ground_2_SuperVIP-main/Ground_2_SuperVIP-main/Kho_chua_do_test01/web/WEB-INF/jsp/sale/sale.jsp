<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Hàng hóa - Sale</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sale/sale.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sale/SASentNoti.css">
    <link rel="stylesheet" href="css/header.css"/>
   
</head>
<body>
    
<header class="header">
    <div class="header-main">
        <div class="logo">
            <div class="logo-icon"><span class="icon-building"></span></div>
            <span>WM</span>
        </div>
        <nav class="nav-menu">
           
            <a href="sale" class="nav-item active "><span class="icon-products"></span> Hàng hóa</a>
            <a href="SAThongBao" class="nav-item "><span class="icon-transactions"></span> Gửi yêu cầu</a>
            <a href="sa-customer" class="nav-item"><span class="icon-partners"></span> Đối tác</a>

        </nav>

        <div class="header-right">
            <div class="user-dropdown">
                <a href="#" class="user-icon gradient" id="dropdownToggle">
                    <i class="fas fa-user-circle fa-2x"></i>
                </a>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="InformationAccount" class="dropdown-item">Thông tin chi tiết</a>
                    <a href="Login" class="dropdown-item">Đăng xuất</a>
                </div>
            </div>
        </div>
    </div>
</header>


<script>
document.addEventListener('DOMContentLoaded', function () {
    const dropdown = document.querySelector('.user-dropdown');
    const toggle = document.getElementById('dropdownToggle');
    toggle.addEventListener('click', function (e) {
        e.preventDefault(); dropdown.classList.toggle('active');
    });
    document.addEventListener('click', function (e) {
        if (!dropdown.contains(e.target)) dropdown.classList.remove('active');
    });
});
</script>

<div class="container">
    <!-- ==== SIDEBAR: BỘ LỌC ==== -->
    <aside class="sidebar">
        <!-- Form lọc (gửi GET tới /sale) -->
        <form action="${pageContext.request.contextPath}/sale" method="get">
            <input type="hidden" name="action" value="list"/>

            <!-- Nhóm hàng (Danh mục) -->
            <div class="sidebar-section">
                <h3 class="sidebar-title">Nhóm hàng</h3>
                <div style="max-height:220px; overflow:auto; border:1px solid #e5e7eb; border-radius:6px; padding:8px;">
                    <c:forEach var="c" items="${categories}">
                        <c:set var="checked" value="${selectedCategoryNames != null && selectedCategoryNames.contains(c.categoryName)}"/>
                        <div class="filter-item">
                            <label style="display:flex; gap:8px; align-items:center;">
                                <input type="checkbox" name="categoryName" value="${c.categoryName}"
                                       <c:if test="${checked}">checked</c:if> />
                                <span>${c.categoryName}</span>
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Tồn kho -->
            <div class="sidebar-section">
                <h3 class="sidebar-title">Tồn kho</h3>
                <div class="filter-item">
                    <label><input type="radio" name="stock" value="all"      <c:if test="${empty stock || stock=='all'}">checked</c:if> /> Tất cả</label>
                </div>
                <div class="filter-item">
                    <label><input type="radio" name="stock" value="in"       <c:if test="${stock=='in'}">checked</c:if> /> Còn hàng</label>
                </div>
                <div class="filter-item">
                    <label><input type="radio" name="stock" value="out"      <c:if test="${stock=='out'}">checked</c:if> /> Hết hàng</label>
                </div>
                <div class="filter-item">
                    <label><input type="radio" name="stock" value="belowMin" <c:if test="${stock=='belowMin'}">checked</c:if> /> Dưới định mức</label>
                </div>
                <div class="filter-item">
                    <label><input type="radio" name="stock" value="aboveMax" <c:if test="${stock=='aboveMax'}">checked</c:if> /> Vượt định mức</label>
                </div>

                <div class="filter-item" style="margin-top:8px;">
                    <label>Ngưỡng tồn:</label>
                    <input type="number" min="0" name="stockThreshold"
                           style="width:100%; padding:6px; border:1px solid #d1d5db; border-radius:6px;"
                           value="<c:out value='${empty stockThreshold ? 30 : stockThreshold}'/>">
                </div>
            </div>

            <div class="sidebar-section">
                <button type="submit" class="btn btn-primary" style="width:100%;">Lọc</button>
            </div>
        </form>
    </aside>

    <!-- ==== MAIN: DANH SÁCH ==== -->
    <main class="main-content">
        <div class="content-header">
            <h1 class="page-title">Hàng hóa</h1>

            <!-- Tìm kiếm giữ lại filter hiện tại -->
                <form action="${pageContext.request.contextPath}/sale" method="get" class="search-container" style="display:flex;gap:8px;align-items:center">
                    <input type="hidden" name="action" value="list"/>

                    <!-- Render lại categoryName đang chọn để không mất filter khi tìm -->
                    <c:forEach var="cn" items="${selectedCategoryNames}">
                        <input type="hidden" name="categoryName" value="${cn}"/>
                    </c:forEach>

                    <input type="hidden" name="stock" value="${stock}"/>
                    <input type="hidden" name="stockThreshold" value="${stockThreshold}"/>

                    <input type="text" name="keyword" class="search-input" placeholder="Theo tên hàng"
                           value="<c:out value='${keyword}'/>" />
                    <button type="submit" class="btn btn-outline">Tìm</button>
                </form>

            <div class="action-buttons">
                <!-- Với SAHomePage chỉ xem, bạn có thể ẩn các nút CRUD -->
                <a class="btn" href="#" onclick="alert('Chức năng dành cho quản trị!');return false;">☰</a>
            </div>
        </div>

        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr>
                    <th><input type="checkbox"></th>
                    <th>ID</th>
                    <th>Tên hàng</th>
                    <th>Danh mục</th>
                    <th>Thương hiệu</th>
                    <th>Nhà cung cấp</th>
                    <th>Giá bán</th>
                    <th>Giá vốn</th>
                    <th>Tồn kho</th>
                    <th>Ngày tạo</th>
                    <th>Chi tiết</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty products}">
                        <tr>
                            <td colspan="11" style="text-align:center; color:#64748b; padding:18px;">
                                Không có sản phẩm nào khớp bộ lọc.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td><input type="checkbox"></td>
                                <td>${p.productId}</td>
                                <td>${p.productName}</td>
                                <td>${p.categoryName}</td>
                                <td>${p.brandName}</td>
                                <td>${p.supplierName}</td>

                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.retailPrice}">
                                            <fmt:formatNumber value="${p.retailPrice}" type="number" minFractionDigits="0"/> ₫
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.costPrice}">
                                            <fmt:formatNumber value="${p.costPrice}" type="number" minFractionDigits="0"/> ₫
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:set var="qty" value="${p.totalQty}" />
                                    <span class="qty-pill <c:out value='${qty != null && qty > 0 ? "pill-in" : "pill-out"}'/>">
                                        <c:out value='${qty == null ? 0 : qty}'/>
                                    </span>
                                </td>

                                <td><c:out value="${p.createdAt}"/></td>

                                <td>
                                    <a class="btn" href="${pageContext.request.contextPath}/sale?action=detail&id=${p.productId}">
                                        Xem
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </main>
</div>

</body>
</html>
