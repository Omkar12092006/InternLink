package com.internlink.servlet;

import com.internlink.dao.BookmarkDAO;
import com.internlink.model.Student;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/BookmarkServlet")
public class BookmarkServlet extends HttpServlet {

    private final BookmarkDAO bookmarkDAO = new BookmarkDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        Student student = (session != null) ? (Student) session.getAttribute("student") : null;

        if (student == null) {
            response.setStatus(401);
            result.put("success", false);
            result.put("redirect", request.getContextPath() + "/student/login.jsp");
            result.put("message", "Please log in to bookmark internships.");
            out.print(gson.toJson(result));
            return;
        }

        try {
            int internshipId = Integer.parseInt(request.getParameter("internshipId"));
            int studentId = student.getId();

            if (bookmarkDAO.isBookmarked(studentId, internshipId)) {
                boolean removed = bookmarkDAO.removeBookmark(studentId, internshipId);
                result.put("success", removed);
                result.put("bookmarked", false);
                result.put("message", removed ? "Bookmark removed." : "Failed to remove bookmark.");
            } else {
                boolean added = bookmarkDAO.addBookmark(studentId, internshipId);
                result.put("success", added);
                result.put("bookmarked", added);
                result.put("message", added ? "Bookmark added." : "Failed to add bookmark.");
            }
        } catch (NumberFormatException e) {
            response.setStatus(400);
            result.put("success", false);
            result.put("message", "Invalid internship ID.");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            result.put("success", false);
            result.put("message", "An error occurred. Please try again.");
        }

        out.print(gson.toJson(result));
    }
}
