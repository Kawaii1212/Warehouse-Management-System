package Controller.WareHouse;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import DAL.StockMovementsRequestDAO;
import DAL.StockMovementResponseDAO;
import DAL.StockMovementDAO;
import DAL.ProductDetailSerialDAO;
import Model.StockMovementResponse;

@WebServlet(name = "WHCompleteRequestController", urlPatterns = {"/WHCompleteRequest"})
public class WHCompleteRequestController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String ctx = request.getContextPath();

        // --- Input ---
        int movementId = parseIntOrDefault(request.getParameter("movementId"), -1);
        String action  = nv(request.getParameter("action"), "complete"); // approve | reject | complete
        String note    = nv(request.getParameter("note"), "");

        if (movementId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "movementId không hợp lệ");
            return;
        }

        // --- DAO ---
        StockMovementsRequestDAO reqDAO = new StockMovementsRequestDAO();

        // Lấy kho đích: ưu tiên param, thiếu thì lấy từ DB
        Integer toWarehouseId = parseNullableInt(request.getParameter("toWarehouseId"));
        if (toWarehouseId == null) {
            toWarehouseId = reqDAO.findToWarehouseId(movementId); // helper ở dưới
        }

        // Lấy userId từ session; nếu null thì fallback CreatedBy của phiếu
        Integer userId = getUserIdFromSession(request);
        if (userId == null) {
            Integer createdBy = reqDAO.findCreatedBy(movementId); // helper ở dưới
            userId = createdBy; // ResponsedBy là NOT NULL -> buộc phải có
        }

        // --- Reject ---
        if ("reject".equalsIgnoreCase(action)) {
            StockMovementResponseDAO respDAO = new StockMovementResponseDAO();

            StockMovementResponse r = new StockMovementResponse();
            r.setMovementId(movementId);
            r.setResponsedBy(userId);
            r.setResponseAt(new java.util.Date());
            r.setResponseStatus("REJECTED"); // hoặc "REJECT"
            r.setNote(note);

            respDAO.insertStockMovementResponse(r);

            response.sendRedirect(ctx + "/WHImportRequest?msg=rejected");
            return;
        }

        // --- Approve/Complete: phải có kho đích ---
        if (toWarehouseId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Không xác định được kho đích (ToWarehouseID)");
            return;
        }

        // 1) Cộng tồn vào WarehouseProducts theo chi tiết phiếu
        StockMovementDAO smDAO = new StockMovementDAO();
        boolean applied = smDAO.applyInboundToWarehouse(movementId, toWarehouseId);
        if (!applied) {
            request.setAttribute("error", "Không thể cập nhật tồn kho (WarehouseProducts).");
            request.getRequestDispatcher("/WEB-INF/jsp/warehouse/import-error.jsp").forward(request, response);
            return;
        }

        // 2) (Tuỳ chọn) Cập nhật serial thuộc phiếu về kho đích
        try {
            ProductDetailSerialDAO serialDAO = new ProductDetailSerialDAO();
            serialDAO.moveSerialsToWarehouseByMovement(movementId, toWarehouseId);
        } catch (Throwable ignore) { /* nếu chưa dùng serial có thể bỏ qua */ }

        // 3) Ghi phản hồi COMPLETED/APPROVED
        StockMovementResponseDAO respDAO = new StockMovementResponseDAO();

        StockMovementResponse r = new StockMovementResponse();
        r.setMovementId(movementId);
        r.setResponsedBy(userId);
        r.setResponseAt(new java.util.Date());
        r.setResponseStatus("COMPLETED"); // hoặc "APPROVED" theo quy ước của bạn
        r.setNote(note);

        respDAO.insertStockMovementResponse(r);

        // 4) Điều hướng: quay về danh sách hàng hoá để thấy tồn tăng
        response.sendRedirect(ctx + "/WareHouseProduct?msg=import_completed");
    }

    /* ================== helpers ================== */

    private static int parseIntOrDefault(String s, int d) {
        try { return Integer.parseInt(s.trim()); } catch (Exception e) { return d; }
    }

    private static Integer parseNullableInt(String s) {
        try { return (s == null || s.isBlank()) ? null : Integer.valueOf(s.trim()); }
        catch (Exception e) { return null; }
    }

    private static String nv(String s, String d) {
        return (s == null) ? d : s;
    }

    private static Integer getUserIdFromSession(jakarta.servlet.http.HttpServletRequest request) {
        Object o1 = request.getSession().getAttribute("userId");
        if (o1 instanceof Integer) return (Integer) o1;
        Object o2 = request.getSession().getAttribute("UserID");
        if (o2 instanceof Integer) return (Integer) o2;
        return null;
    }
}
