package com.internlink.servlet;

import com.internlink.dao.InternshipDAO;
import com.internlink.model.Internship;
import com.internlink.model.Student;
import com.internlink.dao.BookmarkDAO;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/InternshipServlet")
public class InternshipServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private final InternshipDAO internshipDAO = new InternshipDAO();
    private final BookmarkDAO bookmarkDAO = new BookmarkDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String keyword = request.getParameter("keyword");
            String[] catParams = request.getParameterValues("categories");
            String[] locParams = request.getParameterValues("locations");
            String duration = request.getParameter("duration");
            String stipend = request.getParameter("stipend");
            int page = 1;
            try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception ignored) {}

            List<String> categories = catParams != null ? Arrays.asList(catParams) : null;
            List<String> locations = locParams != null ? Arrays.asList(locParams) : null;

            String resolvedStipend = null;
            if (stipend != null && !stipend.isEmpty()) {
                resolvedStipend = stipend;
            }

            int totalCount = internshipDAO.countInternships(keyword, categories, locations, duration, resolvedStipend);
            int offset = (page - 1) * PAGE_SIZE;
            List<Internship> internships = internshipDAO.searchInternships(keyword, categories, locations, duration, resolvedStipend, offset, PAGE_SIZE);

            Set<Integer> bookmarkedIds = new HashSet<>();
            HttpSession session = request.getSession(false);
            if (session != null) {
                Student student = (Student) session.getAttribute("student");
                if (student != null) {
                    List<Integer> bmIds = bookmarkDAO.getBookmarkedInternshipIds(student.getId());
                    bookmarkedIds.addAll(bmIds);
                }
            }

            List<Map<String, Object>> cards = new ArrayList<>();
            for (Internship i : internships) {
                Map<String, Object> card = new HashMap<>();
                card.put("id", i.getId());
                card.put("title", i.getTitle());
                card.put("company", i.getCompany());
                card.put("category", i.getCategory());
                card.put("location", i.getLocation());
                card.put("duration", i.getDuration());
                card.put("stipendType", i.getStipendType());
                card.put("stipendAmount", i.getStipend());
                card.put("description", i.getDescription());
                card.put("skills", i.getSkillsArray());
                card.put("applicants", i.getApplicants());
                card.put("emoji", i.getEmoji());
                card.put("color", i.getColor());
                card.put("isBookmarked", bookmarkedIds.contains(i.getId()));
                cards.add(card);
            }

            Map<String, Object> result = new HashMap<>();
            result.put("internships", cards);
            result.put("totalCount", totalCount);
            result.put("page", page);
            result.put("pageSize", PAGE_SIZE);
            result.put("hasMore", offset + internships.size() < totalCount);

            out.print(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            Map<String, String> error = new HashMap<>();
            error.put("error", "An error occurred while fetching internships. Please try again.");
            out.print(gson.toJson(error));
        }
    }
}
