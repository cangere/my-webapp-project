package com.example.todo.servlet;

import com.example.todo.dao.TaskDAO;
import com.example.todo.model.Task;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "TasksServlet", urlPatterns = {"/api/tasks", "/api/tasks/*"})
public class TasksServlet extends HttpServlet {
    private TaskDAO dao;
    private Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        try {
            dao = new TaskDAO();
        } catch (SQLException e) {
            throw new ServletException("Unable to initialize TaskDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        String path = req.getPathInfo();
        try {
            if (path == null || path.equals("/")) {
                List<Task> list = dao.findAll();
                resp.getWriter().write(gson.toJson(list));
            } else {
                String idStr = path.substring(1);
                int id = Integer.parseInt(idStr);
                Task t = dao.findById(id);
                if (t == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                } else {
                    resp.getWriter().write(gson.toJson(t));
                }
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        String path = req.getPathInfo();
        try {
            Task t = gson.fromJson(req.getReader(), Task.class);
            if (t == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            // If path has an id, treat as update (title and/or completion)
            if (path != null && !path.equals("/")) {
                int id = Integer.parseInt(path.substring(1));
                Task existing = dao.findById(id);
                if (existing == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                if (t.getTitle() != null) {
                    existing.setTitle(t.getTitle());
                }
                existing.setCompleted(t.isCompleted());
                dao.update(existing);
                resp.getWriter().write(gson.toJson(existing));
            } else {
                // Create new task
                if (t.getTitle() == null) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }
                Task created = dao.create(t);
                resp.setStatus(HttpServletResponse.SC_CREATED);
                resp.getWriter().write(gson.toJson(created));
            }
        } catch (JsonSyntaxException | SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        try {
            int id = Integer.parseInt(path.substring(1));
            boolean deleted = dao.delete(id);
            if (deleted) {
                resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
            } else {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
