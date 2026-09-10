-- InternLink database schema (MySQL 8+)
CREATE DATABASE IF NOT EXISTS internlink;
USE internlink;

CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    university_id VARCHAR(50),
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(30),
    course VARCHAR(100),
    university VARCHAR(100),
    major VARCHAR(100),
    graduation_year INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(150) NOT NULL,
    hr_name VARCHAR(100) NOT NULL,
    industry VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(30) NOT NULL,
    website VARCHAR(255),
    location VARCHAR(150),
    description TEXT,
    password VARCHAR(255) NOT NULL,
    verified TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS internships (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NULL,
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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_internship_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    internship_id INT NOT NULL,
    student_id INT NULL,
    applicant_name VARCHAR(100) NOT NULL,
    applicant_email VARCHAR(100) NOT NULL,
    university VARCHAR(150),
    cover_letter TEXT,
    resume_link VARCHAR(500),
    status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    applied_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_application_internship FOREIGN KEY (internship_id) REFERENCES internships(id) ON DELETE CASCADE,
    CONSTRAINT fk_application_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE SET NULL,
    UNIQUE KEY unique_application (internship_id, applicant_email)
);

CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Supporting table used by the existing student bookmark feature.
CREATE TABLE IF NOT EXISTS bookmarks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    internship_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (internship_id) REFERENCES internships(id) ON DELETE CASCADE,
    UNIQUE KEY unique_bookmark (student_id, internship_id)
);

INSERT INTO internships
    (title, company, category, location, duration, description, skills, paid, stipend, applicants, emoji, color, posted_date)
VALUES
    ('Software Engineering Intern', 'Google', 'Software Engineering', 'San Francisco', 'Summer (3 months)', 'Join Google engineering teams to build scalable systems.', 'Java, Python, Data Structures, Algorithms', 1, '$8,000/mo', 245, 'code', '#3B82F6', '2026-08-15'),
    ('Data Science Intern', 'Meta', 'Data Science', 'Remote', 'Summer (3 months)', 'Analyze massive datasets to derive actionable insights.', 'Python, SQL, Machine Learning, Statistics', 1, '$7,500/mo', 189, 'analytics', '#A855F7', '2026-08-18'),
    ('Product Management Intern', 'Amazon', 'Product Management', 'New York', 'Co-op (6 months)', 'Drive product strategy for marketplace features.', 'Communication, Analytics, Strategy, Agile', 1, '$6,800/mo', 312, 'dashboard', '#F59E0B', '2026-08-20'),
    ('UX/UI Design Intern', 'Apple', 'UX/UI Design', 'San Francisco', 'Summer (3 months)', 'Design intuitive interfaces for Apple products.', 'Figma, Sketch, Prototyping, User Research', 1, '$7,200/mo', 156, 'palette', '#EF4444', '2026-08-22'),
    ('Backend Engineering Intern', 'Microsoft', 'Software Engineering', 'Remote', 'Co-op (6 months)', 'Build cloud services on Azure platform.', 'C#, .NET, Azure, SQL', 1, '$7,000/mo', 278, 'code', '#06B6D4', '2026-08-25'),
    ('Machine Learning Intern', 'OpenAI', 'Data Science', 'San Francisco', 'Summer (3 months)', 'Research and implement cutting-edge ML models.', 'Python, PyTorch, Deep Learning, NLP', 1, '$9,000/mo', 421, 'analytics', '#22C55E', '2026-08-26'),
    ('Frontend Engineering Intern', 'Netflix', 'Software Engineering', 'Remote', 'Summer (3 months)', 'Build the streaming interface used by subscribers.', 'React, TypeScript, CSS, JavaScript', 1, '$8,200/mo', 198, 'code', '#EC4899', '2026-08-27'),
    ('Product Design Intern', 'Spotify', 'UX/UI Design', 'New York', 'Co-op (6 months)', 'Design audio experiences for millions of listeners.', 'Figma, Design Systems, Motion, Accessibility', 1, '$6,500/mo', 134, 'palette', '#22C55E', '2026-08-28'),
    ('Data Engineering Intern', 'Uber', 'Data Science', 'India', 'Summer (3 months)', 'Build data pipelines for real-time pricing and routing.', 'Python, Spark, Kafka, Airflow', 1, '$5,500/mo', 167, 'analytics', '#3B82F6', '2026-08-29'),
    ('Software Engineering Intern', 'Stripe', 'Software Engineering', 'Remote', 'Summer (3 months)', 'Build financial infrastructure for the internet.', 'Ruby, Go, API Design, Distributed Systems', 1, '$8,500/mo', 223, 'code', '#A855F7', '2026-08-30'),
    ('Community Intern', 'Local Non-Profit', 'Product Management', 'India', 'Co-op (6 months)', 'Help manage community outreach programs.', 'Communication, Organization, Social Media', 0, NULL, 45, 'dashboard', '#F59E0B', '2026-08-30'),
    ('Research Intern', 'MIT Lab', 'Data Science', 'Remote', 'Summer (3 months)', 'Conduct research in computational biology.', 'Python, R, Bioinformatics, Statistics', 0, NULL, 89, 'analytics', '#06B6D4', '2026-08-31');
