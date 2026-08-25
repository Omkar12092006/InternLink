-- InternLink Database Schema
-- Run this SQL in MySQL to create the required tables

USE internlink;

-- Internships table
CREATE TABLE IF NOT EXISTS internships (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    company VARCHAR(255) NOT NULL,
    paid BOOLEAN NOT NULL DEFAULT TRUE,
    location VARCHAR(100) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT,
    skills VARCHAR(500),
    applicants INT DEFAULT 0,
    posted_date DATE NOT NULL,
    stipend VARCHAR(100),
    emoji VARCHAR(10),
    color VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Applications table
CREATE TABLE IF NOT EXISTS applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    internship_id INT NOT NULL,
    applicant_name VARCHAR(255) NOT NULL,
    applicant_email VARCHAR(255) NOT NULL,
    university VARCHAR(255) NOT NULL,
    cover_letter TEXT,
    resume_link VARCHAR(500),
    status VARCHAR(50) DEFAULT 'Under Review',
    applied_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (internship_id) REFERENCES internships(id)
);

-- Seed data for internships
INSERT INTO internships (title, company, paid, location, duration, category, description, skills, applicants, posted_date, stipend, emoji, color) VALUES
('Frontend Developer Intern', 'TechNova Solutions', TRUE, 'Remote', '3 months', 'Software Engineering', 'Join our core engineering team to build scalable frontend applications using React and TypeScript.', 'React,TYPEscript,Tailwind CSS', 45, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '₹25,000/mo', '🚀', 'bg-green-600'),
('Data Analyst Intern', 'Global Market Insights', TRUE, 'New York', '6 months', 'Data Science', 'Analyze financial market data and create insights using Python and SQL.', 'Python,SQL,Tableau', 128, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '$2,500/mo', '📊', 'bg-blue-600'),
('UX/UI Designer Intern', 'Creative Studio Inc', TRUE, 'Remote', '3 months', 'UX/UI Design', 'Design beautiful and intuitive user interfaces for our mobile and web applications.', 'Figma,Adobe XD,Prototyping', 67, DATE_SUB(CURDATE(), INTERVAL 7 DAY), '₹20,000/mo', '🎨', 'bg-purple-600'),
('Backend Developer Intern', 'CloudScale Technologies', TRUE, 'India', '3 months', 'Software Engineering', 'Build robust backend systems and APIs using Java/Python.', 'Java,Docker,AWS', 89, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '₹30,000/mo', '⚙️', 'bg-yellow-600'),
('Product Management Intern', 'InnovateTech', TRUE, 'San Francisco', '6 months', 'Product Management', 'Work with cross-functional teams to define product roadmap and features.', 'Agile,JIRA,Analytics', 56, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '$3,000/mo', '📋', 'bg-indigo-600'),
('Mobile App Developer Intern', 'AppWorks Studio', TRUE, 'Remote', '3 months', 'Software Engineering', 'Develop cross-platform mobile applications using React Native and Flutter.', 'React Native,Flutter,Firebase', 72, DATE_SUB(CURDATE(), INTERVAL 4 DAY), '₹22,000/mo', '📱', 'bg-teal-600'),
('Machine Learning Intern', 'AI Research Lab', TRUE, 'New York', '6 months', 'Data Science', 'Research and implement ML models for natural language processing tasks.', 'Python,TensorFlow,PyTorch', 210, DATE_SUB(CURDATE(), INTERVAL 6 DAY), '$3,500/mo', '🤖', 'bg-pink-600'),
('Marketing Analytics Intern', 'GrowthHub', FALSE, 'Remote', '3 months', 'Product Management', 'Analyze marketing campaigns and provide data-driven insights for growth.', 'Google Analytics,Excel,SQL', 34, DATE_SUB(CURDATE(), INTERVAL 7 DAY), NULL, '📈', 'bg-orange-600'),
('Content Writing Intern', 'MediaFlow Agency', FALSE, 'India', '3 months', 'Product Management', 'Create engaging content for blogs, social media, and marketing campaigns.', 'Copywriting,SEO,WordPress', 91, DATE_SUB(CURDATE(), INTERVAL 14 DAY), NULL, '✍️', 'bg-cyan-600'),
('Graphic Design Intern', 'DesignCraft', FALSE, 'India', '3 months', 'UX/UI Design', 'Create visual assets for digital and print media.', 'Photoshop,Illustrator,Canva', 115, DATE_SUB(CURDATE(), INTERVAL 3 DAY), NULL, '🎭', 'bg-rose-600'),
('Social Media Intern', 'BrandBoost', FALSE, 'Remote', '3 months', 'Product Management', 'Manage social media accounts and create engaging posts.', 'Instagram,Twitter,Analytics', 143, DATE_SUB(CURDATE(), INTERVAL 5 DAY), NULL, '📣', 'bg-violet-600'),
('Research Assistant Intern', 'EduResearch Foundation', FALSE, 'New York', '6 months', 'Data Science', 'Assist in academic research projects and data collection.', 'Research,SPSS,Academic Writing', 28, DATE_SUB(CURDATE(), INTERVAL 7 DAY), NULL, '🔬', 'bg-emerald-600');
