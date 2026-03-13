package com.example.todo.dao;

import com.example.todo.model.Task;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {
    private static final String DB_URL = "jdbc:sqlite:todo.db";

    public TaskDAO() throws SQLException {
        try {
            Class.forName("org.sqlite.JDBC");
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQLite JDBC driver not found", e);
        }
        try (Connection conn = DriverManager.getConnection(DB_URL)) {
            String create = "CREATE TABLE IF NOT EXISTS tasks (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "title TEXT NOT NULL, " +
                    "completed BOOLEAN NOT NULL CHECK (completed IN (0,1))" +
                    ");";
            try (Statement stmt = conn.createStatement()) {
                stmt.execute(create);
            }
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL);
    }

    public List<Task> findAll() throws SQLException {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT id, title, completed FROM tasks";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Task t = new Task(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getBoolean("completed")
                );
                list.add(t);
            }
        }
        return list;
    }

    public Task findById(int id) throws SQLException {
        String sql = "SELECT id, title, completed FROM tasks WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Task(
                            rs.getInt("id"),
                            rs.getString("title"),
                            rs.getBoolean("completed")
                    );
                }
                return null;
            }
        }
    }

    public Task create(Task t) throws SQLException {
        String sql = "INSERT INTO tasks(title, completed) VALUES(?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getTitle());
            ps.setBoolean(2, t.isCompleted());
            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new SQLException("Creating task failed, no rows affected.");
            }
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    t.setId(keys.getInt(1));
                }
            }
        }
        return t;
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM tasks WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }

    public boolean update(Task t) throws SQLException {
        String sql = "UPDATE tasks SET title = ?, completed = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getTitle());
            ps.setBoolean(2, t.isCompleted());
            ps.setInt(3, t.getId());
            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }
}
