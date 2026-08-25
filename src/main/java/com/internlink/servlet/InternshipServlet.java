package com.internlink.servlet;

import com.internlink.dao.InternshipDAO;
import com.internlink.model.Internship;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/InternshipServlet")
public class InternshipServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");

        InternshipDAO dao = new InternshipDAO();
        List<Internship> internships = dao.getAllInternships();

        Gson gson = new Gson();
        String json = gson.toJson(internships);

        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }
}
