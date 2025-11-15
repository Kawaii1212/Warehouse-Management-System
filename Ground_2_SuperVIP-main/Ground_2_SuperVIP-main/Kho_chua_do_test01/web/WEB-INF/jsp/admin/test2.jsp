<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chi Tiết Sản Phẩm</title>
    <style>
        :root{
            --bg: #0f172a;
            --bg-soft: #111827;
            --card: #ffffff;
            --text: #0f172a;
            --muted: #64748b;
            --primary: #6366f1;
            --primary-2: #7c3aed;
            --ring: #93c5fd;
            --border: #e5e7eb;
            --danger: #ef4444;
            --success: #10b981;
            --radius: 14px;
            
            /* --- THAY ĐỔI --- */
            /* Shadow nhẹ nhàng, hiện đại hơn */
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
            --shadow-soft: 0 1px 3px rgba(0,0,0,.06);
        }
        *{box-sizing:border-box}
        html,body{height:100%}
        body{
            margin:0;
            font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, "Apple Color Emoji","Segoe UI Emoji";
            color: var(--text);

            /* --- THAY ĐỔI --- */
            /* Đổi sang nền xám nhạt, sạch sẽ */
            background: #f8fafc;
            
            min-height:100vh;
            padding: clamp(16px, 3vw, 32px);
        }
        .container{
            max-width: 1100px;
            margin: 0 auto;
        }
        .card{
            background: var(--card);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: clip;

            /* --- THAY ĐỔI --- */
            /* Thêm viền mỏng cho thẻ */
            border: 1px solid var(--border);
        }
        .page-header{
            /* --- THAY ĐỔI --- */
            /* Bỏ background gradient, dùng nền trắng */
            /* background: linear-gradient(135deg, var(--primary) 0%, var(--primary-2) 100%); */
            /* color: #fff; */

            /* Thêm đường viền đáy để ngăn cách tiêu đề */
            border-bottom: 1px solid var(--border);
            padding: clamp(18px, 3.5vw, 28px) clamp(18px, 3.5vw, 32px);
        }
        .page-title{
            margin: 0;
            font-size: clamp(20px, 3.2vw, 28px);
            line-height: 1.2;
            font-weight: 700;
            letter-spacing: .2px;

            /* --- THAY ĐỔI --- */
            /* Đổi màu chữ tiêu đề (vì nền đã đổi sang trắng) */
            color: var(--text);
        }
        .content{
            display:grid;
            grid-template-columns: 380px 1fr;
            gap: clamp(18px, 2.8vw, 28px);
            padding: clamp(18px, 3.5vw, 32px);
        }
        @media (max-width: 920px){
            .content{ grid-template-columns: 1fr; }
        }

        /* Left: image preview */
        .media{
            position: relative;
        }
        .media .preview{
            position: relative;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--shadow-soft);
            background: #f3f4f6;

            /* --- THAY ĐỔI --- */
            /* Thêm viền mỏng cho ảnh */
            border: 1px solid var(--border);
        }
        .media .preview img{
            display:block;
            width:100%;
            height:auto;
            object-fit: cover;
            aspect-ratio: 1 / 1;
        }
        .hint{
            margin-top:6px;
            font-size: 12px;
            color: var(--muted);
        }

        /* Form */
        .form-details {
            display:flex;
            flex-direction: column;
            gap: 18px;
        }
        .grid-2{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        @media (max-width: 640px){
            .grid-2{ grid-template-columns: 1fr; }
        }
        .field{
            display:flex;
            flex-direction: column;
            gap: 8px;
        }
        .label{
            font-size: 12px;
            font-weight: 700;
            color: var(--muted);
            letter-spacing: .4px;
            text-transform: uppercase;
        }

        /* ========== CSS ĐÃ TINH CHỈNH ========== */
        .value-display {
            margin: 0;
            padding: 12px 12px;
            border: 1px solid var(--border);
            border-radius: 10px;
            font-size: 15px;
            background: #f8fafc; 
            
            /* --- THAY ĐỔI --- */
            /* Làm cho dữ liệu hiển thị rõ hơn */
            color: #111827; 
            font-weight: 500;

            min-height: 44px; 
            line-height: 1.5;
            word-break: break-word; 
            display: flex;
            align-items: center;
        }

        .status-badge {
            display: inline-block;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 13px;
        }
        .status-badge.success {
            background: rgba(16, 185, 129, .1);
            color: #059669;
        }
        .status-badge.danger {
            background: rgba(239, 68, 68, .1);
            color: #dc2626;
        }
        /* ========== KẾT THÚC CSS TINH CHỈNH ========== */


        /* Buttons */
        .actions{
            display:flex;
            gap: 10px;
            margin-top: 8px;
            flex-wrap: wrap;
        }
        .btn{
            padding: 12px 16px;
            border-radius: 10px;
            border: 1px solid transparent;
            font-weight: 700;
            cursor:pointer;
            transition: transform .06s ease, box-shadow .2s ease, background .2s ease;
            text-decoration: none; 
        }
        .btn:active{ transform: translateY(1px); }
        .btn-primary{
            /* --- THAY ĐỔI --- */
            /* Bỏ gradient, dùng màu đồng nhất */
            /* background: linear-gradient(135deg, var(--primary) 0%, var(--primary-2) 100%); */
            background: var(--primary);
            color:#fff;
            /* Shadow nhẹ hơn */
            box-shadow: 0 4px 14px rgba(99,102,241,.3);
        }
        .btn-primary:hover{ 
            box-shadow: 0 6px 18px rgba(99,102,241,.38); 
            background: #5558e9; /* Hơi đậm lên khi hover */
        }
        .btn-secondary{
            background:#fff;
            border-color: var(--border);
            color: #111827;
        }
        .btn-secondary:hover{
            background:#f8fafc;
            /* Làm viền đậm hơn khi hover */
            border-color: #d1d5db; 
        }
    </style>
</head>
<body>
<div class="container">
    <div class="card">
        <header class="page-header">
            <h1 class="page-title">Chi Tiết Sản Phẩm</h1>
        </header>

        <section class="content">
            <aside class="media">
                <div class="preview" aria-live="polite">
                    <img id="previewImg"
                         src="${product.imageUrl != null ? product.imageUrl : 'https://via.placeholder.com/600x600?text=No+Image'}"
                         alt="${product.productName != null ? product.productName : 'Hình sản phẩm'}">
                </div>
            </aside>

            <section>
                <div class="form-details">

                    <div class="grid-2">
                        <div class="field">
                            <span class="label">Mã Sản Phẩm</span>
                            <p class="value-display">${product.productId}</p>
                        </div>

                        <div class="field">
                            <span class="label">Tên Sản Phẩm</span>
                            <p class="value-display">${product.productName}</p>
                        </div>
                    </div>

                    <div class="grid-2">
                        <div class="field">
                            <span class="label">Thương Hiệu</span>
                            <p class="value-display">${product.brandName}</p>
                        </div>

                        <div class="field">
                            <span class="label">Danh Mục</span>
                            <p class="value-display">${product.categoryName}</p>
                        </div>
                    </div>

                    <div class="field">
                        <span class="label">Nhà Cung Cấp</span>
                        <p class="value-display">${product.supplierName}</p>
                    </div>

                    <div class="grid-2">
                        <div class="field">
                            <span class="label">Giá Vốn</span>
                            <p class="value-display">
                                <fmt:formatNumber value="${product.costPrice}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                            </p>
                        </div>
                        <div class="field">
                            <span class="label">Giá Bán Lẻ</span>
                            <p class="value-display">
                                <fmt:formatNumber value="${product.retailPrice}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                            </p>
                        </div>
                    </div>

                    <div class="grid-2">
                        <div class="field">
                            <span class="label">VAT (%)</span>
                            <p class="value-display">${product.vat}</p>
                        </div>

                        <div class="field">
                            <span class="label">Số hàng tồn</span>
                            <p class="value-display">${product.totalQty}</p>
                        </div>
                    </div>

                    <div class="field">
                        <span class="label">Trạng Thái</span>
                        <div class="value-display">
                            <c:if test="${product.isActive}">
                                <span class="status-badge success">Đang kinh doanh</span>
                            </c:if>
                            <c:if test="${not product.isActive}">
                                <span class="status-badge danger">Ngừng kinh doanh</span>
                            </c:if>
                        </div>
                    </div>

                    <div class="actions">
                       
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/sale?action=list">↩️ Quay lại danh sách</a>
                    </div>

                </div> 
            </section>
        </section>
    </div>
</div>
</body>
</html>