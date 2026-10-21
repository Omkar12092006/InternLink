# InternLink — Current Project Status and Updated Roadmap

**Status date:** September 28, 2026  
**Project:** Internship and placement portal  
**Purpose:** Replace the earlier development notes with a status checked against the current source tree.

## 1. Current Status

| Area | Current status |
|---|---|
| Student registration and login | Implemented; session-based authentication |
| Internship discovery | Implemented; keyword search, filters, and paginated AJAX results |
| Bookmarks | Implemented; students can add and remove saved internships |
| Internship applications | Implemented; application submission prevents duplicate applications |
| Student dashboard | Implemented; displays the signed-in student's real application history, statuses, counts, profile details, and saved internships |
| Company registration and login | Implemented |
| Company dashboard | Implemented; displays company posting/application metrics and company-owned internship postings |
| Company profile | Implemented; company can view and update its profile |
| Internship management | Implemented; companies can create, edit, and delete their own postings |
| Application review | Implemented; companies can review applicants and update application statuses |
| Company candidates page | Implemented; shows applicants for the signed-in company's internships |
| Login return paths and logout | Implemented; supported destinations are validated and logout invalidates the session |
| Admin features | Not implemented beyond the admin login placeholder page |
| Student profile editing | Not implemented; dashboard profile details are currently read-only |
| Resume upload | Not implemented |
| Interview scheduling | Not implemented |
| Automated test suite | 12 Maven/JUnit tests pass; several DAO tests use the configured MySQL database |
| Overall completion | Core student and company workflows are working; admin and advanced student features remain |

## 2. Implemented Features

### Student

- Register and sign in; successful sign-in opens the student dashboard.
- Browse internships with AJAX-backed search, category/location/duration/stipend filters, and pagination.
- Open internship details and submit an application while signed in.
- Prevent duplicate applications to the same internship.
- Save and unsave internships.
- View submitted applications, current statuses, real dashboard metrics, and saved internships on the dashboard.
- Search internships from the dashboard and navigate to the browse results.
- Sign out and invalidate the current session.

### Company

- Register, sign in, and sign out.
- View a dashboard with posting, application, and pending-review counts.
- Create, edit, and delete company-owned internship postings.
- View and update company profile information.
- Review applications submitted to the company's postings and update application statuses (pending, shortlisted, rejected, or selected).
- View real applicants in the candidates section.
- Reach company pages through authenticated routes; unauthenticated users are redirected to sign-in.

### Shared and project foundation

- Maven WAR application using Java, JSP, Jakarta Servlets, JDBC, and MySQL.
- Database schema includes students, companies, internships, applications, admins, and bookmarks.
- JSON endpoints power internship search, bookmarking, and application submission.
- Common login return destinations are allowlisted to prevent redirects to arbitrary external sites.
- Local Tomcat setup and start scripts are provided under `.vscode`.

## 3. Work Completed Against the Earlier Plan

The original plan's first foundation, student-backend, and internship-browsing milestones are implemented. The planned company-authentication, company-dashboard/profile, internship-management, and application-review milestones are also implemented.

The earlier plan identified the student dashboard as static and the company pages as UI-only. Those statements are now out of date: both areas have working server-side flows and use project data. The student dashboard now loads real applications and bookmarks. Company registration/login, profile management, postings, applicant review, and candidate listing are connected to DAOs and servlets.

## 4. Remaining Feature Checklist

### Admin portal — not implemented

- Functional admin authentication and session handling.
- Admin dashboard metrics.
- Student account management.
- Company account management and company verification/rejection workflow.
- Internship moderation and application oversight.
- Reports and placement statistics.
- Admin model/DAO and corresponding servlets and JSP pages.

The schema contains an `admins` table, but the presence of the table does not mean the admin workflow is implemented. `admin/login.jsp` is currently only a placeholder; no functional admin dashboard or management workflow was found.

### Student features — not implemented

- Edit student profile.
- Upload, store, and manage resumes.
- Interview schedule and interview history.

### Additional project work

- Add focused automated tests for the new dashboard servlets, authorization rules, and bookmark-removal flow.
- Continue end-to-end checks of student and company workflows, including invalid input and database failures.
- Review error handling and validation across all forms and AJAX endpoints.
- Review any remaining static or placeholder content outside the working student and company dashboards.

## 5. Updated Development Roadmap

The original roadmap is retained as a guide, but completed student/company milestones should not be repeated.

### Next: Admin authentication and overview

- Implement admin authentication and session protection.
- Add an admin dashboard backed by real counts for students, companies, internships, and applications.
- Add admin model/DAO methods and tests.

**Deliverable:** An authenticated admin can view a real system overview.

### Then: Admin account management

- List and manage students.
- List companies and implement verification/rejection actions.
- Enforce admin authorization on every management operation.

**Deliverable:** Admins can manage student and company accounts.

### Then: Admin content management and reports

- Moderate internship postings.
- Inspect applications.
- Produce accurate system/placement reports from database data.

**Deliverable:** Admins can moderate portal content and review system-level statistics.

### Then: Student profile and resume

- Add student profile editing and persistence.
- Add validated resume upload and a defined storage/retention approach.
- Add tests for profile updates and file handling.

**Deliverable:** Students can maintain their profile and resume.

### Then: Interview scheduling

- Add an interview model, schema, DAO, and role-authorized scheduling flow.
- Let companies schedule or update interviews and students view their interviews.
- Define how interview records relate to applications and statuses.

**Deliverable:** Companies can schedule interviews and students can view them.

### Final verification and polish

- Run end-to-end checks across student and company flows and, once implemented, admin flows.
- Test authorization, invalid forms, redirects, and AJAX error paths.
- Confirm responsive layouts and remove remaining placeholder data.
- Re-run the complete Maven test suite and verify deployment through the local Tomcat scripts.

**Deliverable:** A verified portal whose implemented features match the project synopsis.

## 6. Current Technology Stack

| Layer | Current implementation |
|---|---|
| Language | Java 25 configured as Maven compiler source/target |
| Web layer | JSP and Jakarta Servlets; Jakarta EE API dependency `11.0.0-M1` |
| Local servlet container | Apache Tomcat 10.1.43, configured by the repository's Tomcat setup script |
| Database | MySQL; the checked-in schema targets MySQL 8 or later |
| Database access | JDBC with prepared statements and project DAO classes |
| Front end | JSP, HTML, CSS, and vanilla JavaScript; Tailwind is loaded from a CDN on pages that use it |
| JSON | Gson 2.11.0 |
| Build and packaging | Maven 3.9.x; WAR packaging |
| Tests | JUnit Jupiter 5.10.2 |

## 7. Verification Notes

- The full Maven test suite completed successfully with **12 tests, 0 failures, and 0 errors** during the latest dashboard work.
- Live local checks exercised student registration/login, student dashboard rendering, bookmarking/removal, company candidate rendering, logout, and protected-page redirects.
- The local application was available at `http://localhost:8081/InternLink/` and returned HTTP 200 during verification.
- Database-backed checks rely on the local MySQL service and its current `internlink` database.

