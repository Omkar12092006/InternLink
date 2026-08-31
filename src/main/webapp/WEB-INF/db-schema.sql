-- =====================================================
-- InternLink Database Schema - Run in MySQL
-- =====================================================

CREATE DATABASE IF NOT EXISTS internlink;
USE internlink;

-- -----------------------------------------------------
-- Table: students (create if not exists)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    university VARCHAR(100),
    major VARCHAR(100),
    graduation_year INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------
-- Table: internships (create if not exists)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS internships (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    company VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    location VARCHAR(100) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    description TEXT,
    skills VARCHAR(500),
    paid TINYINT(1) DEFAULT 1,
    stipend VARCHAR(50),
    applicants INT DEFAULT 0,
    emoji VARCHAR(10) DEFAULT 'work',
    color VARCHAR(20) DEFAULT '#22C55E',
    posted_date DATE DEFAULT (CURRENT_DATE),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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

-- -----------------------------------------------------
-- Seed data: sample internships
-- -----------------------------------------------------
INSERT INTO internships (title, company, category, location, duration, description, skills, paid, stipend, applicants, emoji, color, posted_date) VALUES
('Software Engineering Intern', 'Google', 'Software Engineering', 'San Francisco', 'Summer (3 months)', 'Join Google engineering teams to build scalable systems. Work on real products used by billions of people worldwide.', 'Java, Python, Data Structures, Algorithms', 1, '$8,000/mo', 245, 'code', '#3B82F6', '2026-08-15'),
('Data Science Intern', 'Meta', 'Data Science', 'Remote', 'Summer (3 months)', 'Analyze massive datasets to derive actionable insights. Build ML models that power content recommendations.', 'Python, SQL, Machine Learning, Statistics', 1, '$7,500/mo', 189, 'analytics', '#A855F7', '2026-08-18'),
('Product Management Intern', 'Amazon', 'Product Management', 'New York', 'Co-op (6 months)', 'Drive product strategy for Amazon marketplace features. Work directly with senior PMs and engineering teams.', 'Communication, Analytics, Strategy, Agile', 1, '$6,800/mo', 312, 'dashboard', '#F59E0B', '2026-08-20'),
('UX/UI Design Intern', 'Apple', 'UX/UI Design', 'San Francisco', 'Summer (3 months)', 'Design intuitive interfaces for Apple products. Collaborate with human interface team on next-gen experiences.', 'Figma, Sketch, Prototyping, User Research', 1, '$7,200/mo', 156, 'palette', '#EF4444', '2026-08-22'),
('Backend Engineering Intern', 'Microsoft', 'Software Engineering', 'Remote', 'Co-op (6 months)', 'Build cloud services on Azure platform. Work with distributed systems at massive scale.', 'C#, .NET, Azure, SQL', 1, '$7,000/mo', 278, 'code', '#06B6D4', '2026-08-25'),
('Machine Learning Intern', 'OpenAI', 'Data Science', 'San Francisco', 'Summer (3 months)', 'Research and implement cutting-edge ML models. Contribute to AI safety and alignment projects.', 'Python, PyTorch, Deep Learning, NLP', 1, '$9,000/mo', 421, 'analytics', '#22C55E', '2026-08-26'),
('Frontend Engineering Intern', 'Netflix', 'Software Engineering', 'Remote', 'Summer (3 months)', 'Build the streaming interface used by 200M+ subscribers. Optimize performance for global scale.', 'React, TypeScript, CSS, JavaScript', 1, '$8,200/mo', 198, 'code', '#EC4899', '2026-08-27'),
('Product Design Intern', 'Spotify', 'UX/UI Design', 'New York', 'Co-op (6 months)', 'Design audio experiences for millions of creators and listeners. Shape the future of music discovery.', 'Figma, Design Systems, Motion, Accessibility', 1, '$6,500/mo', 134, 'palette', '#22C55E', '2026-08-28'),
('Data Engineering Intern', 'Uber', 'Data Science', 'India', 'Summer (3 months)', 'Build data pipelines that power real-time pricing and routing. Work with petabyte-scale datasets.', 'Python, Spark, Kafka, Airflow', 1, '$5,500/mo', 167, 'analytics', '#3B82F6', '2026-08-29'),
('Software Engineering Intern', 'Stripe', 'Software Engineering', 'Remote', 'Summer (3 months)', 'Build financial infrastructure for the internet. Work on payments APIs used by millions of businesses.', 'Ruby, Go, API Design, Distributed Systems', 1, '$8,500/mo', 223, 'code', '#A855F7', '2026-08-30'),
('Community Intern', 'Local Non-Profit', 'Product Management', 'India', 'Co-op (6 months)', 'Help manage community outreach programs. Great opportunity for students passionate about social impact.', 'Communication, Organization, Social Media', 0, NULL, 45, 'dashboard', '#F59E0B', '2026-08-30'),
('Research Intern', 'MIT Lab', 'Data Science', 'Remote', 'Summer (3 months)', 'Conduct research in computational biology. Publish papers and contribute to open-source scientific tools.', 'Python, R, Bioinformatics, Statistics', 0, NULL, 89, 'analytics', '#06B6D4', '2026-08-31');
