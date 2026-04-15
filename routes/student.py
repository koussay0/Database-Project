from flask import Blueprint, render_template, request, redirect, url_for, session
import config

student_bp = Blueprint("student", __name__, url_prefix="/student")
db = config.database

@student_bp.route('/courses')
def courses():
    return render_template("student/courses.html")

@student_bp.route('/section')
def section():
    account_id = session.get('id')
    semester = request.args.get('semester', 'all')
    year_in = request.args.get('year', 'all')
    
    # Accounts for 'all' input for year
    year = int(year_in) if year_in.isdigit() else None
    
    all_sections = []
    years = []
    cursor = db.cursor()

    try:
        cursor.execute("SELECT student_id FROM student_accounts WHERE account_id = %s", [account_id])
        student = cursor.fetchone()
        student_id = student[0]

        # Dropdown years
        cursor.execute("SELECT DISTINCT year FROM sections ORDER BY year DESC")
        years = [row[0] for row in cursor.fetchall()]

        cursor.callproc('get_student_courses', (student_id, semester, year))
        all_sections = cursor.fetchall() 
    except:
        pass
    finally:
        cursor.close()

    return render_template("student/section.html", 
                           sections=all_sections, 
                           years=years, 
                           selected_semester=semester, 
                           selected_year=year_in)

@student_bp.route('/personal', methods = ['GET', 'POST'])
def personal():
    account_id = session.get('id') 
    cursor = db.cursor() 
    
    try:
        if request.method == 'POST':
            username = request.form.get('username')
            first_name = request.form.get('first_name')
            last_name = request.form.get('last_name')
            email = request.form.get('email')

            try:
                cursor.callproc('modify_student_info', [account_id, username, first_name, last_name, email])
                db.commit()
            except:
                pass
            return redirect(url_for('student.personal'))

        query = """
            SELECT student_accounts.student_id, accounts.username, students.first_name, students.last_name, students.email, instructors.first_name, instructors.last_name
            FROM accounts
            JOIN student_accounts ON accounts.account_id = student_accounts.account_id
            JOIN students ON student_accounts.student_id = students.student_id
            LEFT JOIN advisors ON advisors.student_id = students.student_id
            LEFT JOIN instructors ON advisors.instructor_id = instructors.instructor_id
            WHERE accounts.account_id = %s
        """
        cursor.execute(query, (account_id,))
        data = cursor.fetchone()

        return render_template("student/personal.html", data=data)
    finally:
        cursor.close()

@student_bp.route('/dash')
def dash():
    return render_template("student/dash.html")