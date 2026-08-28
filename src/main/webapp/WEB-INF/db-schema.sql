-- =====================================================
-- InternLink Database Schema - Run in MySQL
-- =====================================================

USE internlink;

-- -----------------------------------------------------
-- Table: bookmarks (create if not exists)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS bookmarks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    internship_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (internship_id) REFERENCES internships(id) ON DELETE CASCADE,
    UNIQUE KEY unique_bookmark (student_id, internship_id)
);
