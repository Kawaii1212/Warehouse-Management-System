package Controller.Admin;

import DAL.BranchDAO;
import DAL.RoleDAO;
import DAL.UserDAO;
import Model.User;
import Model.Branch;
import Model.Role;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "NhanVienController", urlPatterns = {"/NhanVien"})
public class NhanVienController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // ====== NHẬN THAM SỐ ======
        String search = request.getParameter("search");
        String statusParam = request.getParameter("status");
        String roleParam = request.getParameter("role");
        String branchParam = request.getParameter("branch");

        String status = (statusParam == null) ? "all" : statusParam;
        String role = (roleParam == null) ? "None" : roleParam;
        String branch = (branchParam == null) ? "all" : branchParam;

        // ====== LẤY DỮ LIỆU ======
        BranchDAO branchDAO = new BranchDAO();
        RoleDAO roleDAO = new RoleDAO();

        List<Branch> branches = branchDAO.getAllBranches();
        List<Role> roles = roleDAO.getAllRoles();

        // ====== LẤY DANH SÁCH NHÂN VIÊN THEO ROLE ======
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        List<User> allUsers = new ArrayList<>();

        if (currentUser != null) {
            // Refresh current user from database to ensure we have the latest data
            User freshUser = userDAO.getUserById(currentUser.getUserId());
            if (freshUser == null) {
                freshUser = currentUser; // Fallback to session user if refresh fails
            } else {
                // Update session with fresh user data
                request.getSession().setAttribute("currentUser", freshUser);
            }

            int currentUserRoleId = freshUser.getRoleId();
            int currentUserId = freshUser.getUserId();

            if (currentUserRoleId == 0) {
                // Role 0 (Admin): Lấy tất cả nhân viên từ tất cả chi nhánh
                allUsers = userDAO.getAllUsers();
            } else if (currentUserRoleId == 1) {
                // Role 1 (Branch Manager): Lấy nhân viên theo chi nhánh của người truy cập
                Integer currentUserBranchId = freshUser.getBranchId();
                if (currentUserBranchId != null) {
                    allUsers = userDAO.getUsersByBranchId(currentUserBranchId);
                } else {
                    // Nếu người dùng không có branchId, trả về danh sách rỗng
                    allUsers = new ArrayList<>();
                }
            } else {
                // Các role khác: Lấy nhân viên theo chi nhánh (giống role 1)
                Integer currentUserBranchId = freshUser.getBranchId();
                if (currentUserBranchId != null) {
                    allUsers = userDAO.getUsersByBranchId(currentUserBranchId);
                } else {
                    allUsers = new ArrayList<>();
                }
            }

            // Loại bỏ chính người đang đăng nhập khỏi danh sách
            final int finalCurrentUserId = currentUserId;
            allUsers = allUsers.stream()
                    .filter(u -> u != null && u.getUserId() != finalCurrentUserId)
                    .collect(Collectors.toList());
        } else {
            // Nếu không có currentUser, lấy tất cả (fallback)
            allUsers = userDAO.getAllUsers();
        }

        // ====== LỌC DỮ LIỆU ======
        List<User> filteredUsers = allUsers.stream()
                // Lọc theo chi nhánh
                .filter(u -> {
                    if (!"all".equalsIgnoreCase(branch)) {
                        String userBranch = (u.getBranchName() != null) ? u.getBranchName() : "";
                        return branch.equalsIgnoreCase(userBranch);
                    }
                    return true;
                })
                // Lọc theo vai trò
                .filter(u -> {
                    if (!"None".equalsIgnoreCase(role)) {
                        String userRole = (u.getRoleName() != null) ? u.getRoleName() : "";
                        return role.equalsIgnoreCase(userRole);
                    }
                    return true;
                })
                // Lọc theo trạng thái
                .filter(u -> {
                    if (!"all".equalsIgnoreCase(status)) {
                        switch (status.toLowerCase()) {
                            case "active":       // Đang làm
                                return u.getIsActive() == 1;
                            case "inactive":     // Nghỉ việc
                                return u.getIsActive() == 0;
                            case "pending":      // Chờ phê duyệt
                                return u.getIsActive() == 2;
                            default:
                                return true;
                        }
                    }
                    return true;
                })
                // Lọc theo tìm kiếm
                .filter(u -> {
                    if (search != null && !search.trim().isEmpty()) {
                        String keyword = search.trim().toLowerCase();
                        if (keyword.matches("\\d+")) {
                            // Tìm theo mã nhân viên
                            try {
                                int id = Integer.parseInt(keyword);
                                return u.getUserId() == id;
                            } catch (NumberFormatException e) {
                                return false;
                            }
                        } else {
                            // Tìm theo tên, email, số điện thoại
                            boolean matchesName = (u.getFullName() != null && 
                                    u.getFullName().toLowerCase().contains(keyword));
                            boolean matchesEmail = (u.getEmail() != null && 
                                    u.getEmail().toLowerCase().contains(keyword));
                            boolean matchesPhone = (u.getPhone() != null && 
                                    u.getPhone().toLowerCase().contains(keyword));
                            return matchesName || matchesEmail || matchesPhone;
                        }
                    }
                    return true;
                })
                .collect(Collectors.toList());

        // ====== PHÂN TRANG ======
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                int parsedPage = Integer.parseInt(pageParam.trim());
                if (parsedPage > 0) {
                    page = parsedPage;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalUsers = filteredUsers.size();
        int totalPages = (totalUsers > 0) ? (int) Math.ceil((double) totalUsers / pageSize) : 1;

        // Ensure page is within valid range
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }
        if (page < 1) {
            page = 1;
        }

        int fromIndex = Math.max((page - 1) * pageSize, 0);
        int toIndex = Math.min(fromIndex + pageSize, totalUsers);

        List<User> paginatedUsers;
        if (fromIndex >= totalUsers) {
            paginatedUsers = List.of(); // Empty list
        } else {
            paginatedUsers = filteredUsers.subList(fromIndex, toIndex);
        }

        // ====== TRUYỀN DỮ LIỆU SANG JSP ======
        request.setAttribute("users", paginatedUsers);
        request.setAttribute("branches", branches);
        request.setAttribute("roles", roles);

        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedRole", role);
        request.setAttribute("selectedBranch", branch);
        request.setAttribute("searchKeyword", search);

        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);

        request.getRequestDispatcher("/WEB-INF/jsp/admin/NhanVien.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
