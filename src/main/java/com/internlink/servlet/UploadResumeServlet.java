package com.internlink.servlet;

import com.internlink.dao.StudentDAO;
import com.internlink.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.Locale;
import java.util.UUID;

@WebServlet("/UploadResumeServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024)
public class UploadResumeServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Student student = getLoggedInStudent(request);
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/student/login.jsp");
            return;
        }

        String result;
        Path uploadedPath = null;
        try {
            Part resume = request.getPart("resume");
            if (resume == null || resume.getSize() == 0) {
                result = "empty";
            } else if (resume.getSize() > 5 * 1024 * 1024) {
                result = "too-large";
            } else {
                String extension = getAllowedExtension(resume.getSubmittedFileName());
                byte[] content;
                try (InputStream input = resume.getInputStream()) {
                    content = input.readAllBytes();
                }
                if (!hasExpectedSignature(extension, content)) {
                    result = "invalid";
                } else {
                    String storedName = student.getId() + "-" + UUID.randomUUID() + "." + extension;
                    Path resumeDirectory = getResumeDirectory();
                    Files.createDirectories(resumeDirectory);
                    uploadedPath = resumeDirectory.resolve(storedName).normalize();
                    if (!uploadedPath.getParent().equals(resumeDirectory.toAbsolutePath().normalize())) {
                        throw new IOException("Invalid resume storage path.");
                    }
                    Files.write(uploadedPath, content, StandardOpenOption.CREATE_NEW, StandardOpenOption.WRITE);

                    if (!studentDAO.updateResumeFile(student.getId(), storedName)) {
                        Files.deleteIfExists(uploadedPath);
                        result = "failed";
                    } else {
                        String previousResume = student.getResumeFile();
                        student.setResumeFile(storedName);
                        HttpSession session = request.getSession(false);
                        session.setAttribute("student", student);
                        deletePreviousResume(student.getId(), previousResume, resumeDirectory);
                        result = "uploaded";
                    }
                }
            }
        } catch (IllegalArgumentException e) {
            result = "invalid";
        } catch (IllegalStateException e) {
            result = "too-large";
        } catch (SQLException e) {
            if (uploadedPath != null) {
                Files.deleteIfExists(uploadedPath);
            }
            getServletContext().log("Unable to save student resume metadata.", e);
            result = "failed";
        } catch (IOException e) {
            if (uploadedPath != null) {
                Files.deleteIfExists(uploadedPath);
            }
            getServletContext().log("Unable to store student resume.", e);
            result = "failed";
        }

        response.sendRedirect(request.getContextPath() + "/StudentProfileServlet?resume=" + result + "#resume");
    }

    private Student getLoggedInStudent(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute("student");
        return value instanceof Student ? (Student) value : null;
    }

    private Path getResumeDirectory() throws IOException {
        String userHome = System.getProperty("user.home");
        if (userHome == null || userHome.isBlank()) {
            throw new IOException("The application user home directory is not configured.");
        }
        return Path.of(userHome, "InternLink", "uploads", "resumes").toAbsolutePath().normalize();
    }

    private String getAllowedExtension(String submittedName) {
        if (submittedName == null || submittedName.isBlank()) {
            throw new IllegalArgumentException("Select a resume file.");
        }
        String filename = Path.of(submittedName.replace('\\', '/')).getFileName().toString();
        int extensionSeparator = filename.lastIndexOf('.');
        if (extensionSeparator < 0) {
            throw new IllegalArgumentException("Unsupported resume file type.");
        }
        String extension = filename.substring(extensionSeparator + 1).toLowerCase(Locale.ROOT);
        if (!"pdf".equals(extension) && !"doc".equals(extension) && !"docx".equals(extension)) {
            throw new IllegalArgumentException("Unsupported resume file type.");
        }
        return extension;
    }

    private boolean hasExpectedSignature(String extension, byte[] content) {
        if ("pdf".equals(extension)) {
            return startsWith(content, new byte[] {'%', 'P', 'D', 'F', '-'});
        }
        if ("docx".equals(extension)) {
            return startsWith(content, new byte[] {'P', 'K', 3, 4});
        }
        return startsWith(content, new byte[] {
                (byte) 0xD0, (byte) 0xCF, 0x11, (byte) 0xE0,
                (byte) 0xA1, (byte) 0xB1, 0x1A, (byte) 0xE1
        });
    }

    private boolean startsWith(byte[] content, byte[] signature) {
        if (content.length < signature.length) {
            return false;
        }
        for (int i = 0; i < signature.length; i++) {
            if (content[i] != signature[i]) {
                return false;
            }
        }
        return true;
    }

    private void deletePreviousResume(int studentId, String previousResume, Path resumeDirectory) {
        if (previousResume == null
                || !previousResume.matches(studentId + "-[a-f0-9-]+\\.(pdf|doc|docx)")) {
            return;
        }
        Path previousPath = resumeDirectory.resolve(previousResume).normalize();
        if (!previousPath.getParent().equals(resumeDirectory)) {
            return;
        }
        try {
            Files.deleteIfExists(previousPath);
        } catch (IOException e) {
            getServletContext().log("Unable to remove the replaced student resume.", e);
        }
    }
}
