from flask import Blueprint, render_template, request, redirect, url_for, session
import config

student_bp = Blueprint("student", __name__, url_prefix="/student")
db = config.database

@student_bp.route('/courses')
def courses():
    return render_template("student/courses.html")

@student_bp.route('/dash')
def dash():
    return render_template("student/dash.html")

@student_bp.route('/section')
def section():
    return render_template("student/section.html")

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
            JOIN advisors ON advisors.student_id = students.student_id
            JOIN instructors ON advisors.instructor_id = instructors.instructor_id
            WHERE accounts.account_id = %s
        """
        cursor.execute(query, (account_id,))
        data = cursor.fetchone()

        return render_template("student/personal.html", data=data)
    finally:
        cursor.close()
