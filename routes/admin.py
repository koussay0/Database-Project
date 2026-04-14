from flask import Blueprint, render_template, request, redirect, url_for, session
import config

admin_bp = Blueprint("admin", __name__, url_prefix="/admin")
db = config.database

@admin_bp.route('/classroom', methods=["GET", "POST"])
def classroom():
    return render_template("admin/classroom.html")

@admin_bp.route('/dash', methods=["GET", "POST"])
def dash():
    return render_template("admin/dash.html")

@admin_bp.route('/dept', methods=["GET", "POST"])
def dept():
    return render_template("admin/dept.html")

@admin_bp.route("/instructor", methods=["GET", "POST"])
def instructor():
    return render_template("admin/instructor.html")

@admin_bp.route("/section", methods=["GET", "POST"])
def section():
    return render_template("admin/section.html")

@admin_bp.route('/student', methods=["GET", "POST"])
def student():
    return render_template("admin/student.html")

@admin_bp.route("/teaching", methods=["GET", "POST"])
def teaching():
    return render_template("admin/teaching.html")

@admin_bp.route('/timeslot', methods=["GET", "POST"])
def timeslot():
    return render_template("admin/timeslot.html")

@admin_bp.route("/course", methods = ['GET', 'POST'])
def course():
    cursor = db.cursor()
    edit_id = request.args.get('edit_id')

    if request.method == 'POST':
        if 'update_course' in request.form:
            course_id = request.form.get('course_id')
            dept_id = request.form.get('dept_id')
            course_num = request.form.get('course_number')
            title = request.form.get('title')
            credit = request.form.get('credit')
            cursor.callproc('update_course', [course_id, dept_id, course_num, title, credit])
            db.commit()
            return redirect(url_for('admin.course')) 
        elif 'add_course' in request.form:
            dept_id = request.form.get('dept_id')
            course_number = request.form.get('course_number')
            title = request.form.get('title')
            credit = request.form.get('credit')
            cursor.callproc('create_course', [dept_id, course_number, title, credit])
            db.commit()
        elif 'remove_course' in request.form:
            course = request.form.get('remove_course')
            cursor.callproc('delete_course', [course])
            db.commit()

    cursor.callproc('read_courses', ())
    courses = cursor.fetchall() 

    # dropdown for dept_id
    cursor.execute("SELECT dept_id, name FROM departments")
    depts = cursor.fetchall()
    
    cursor.close()
    return render_template("admin/course.html", courses=courses, depts=depts, edit_id = edit_id)

@admin_bp.route('/personal', methods = ['GET', 'POST'])
def personal():
    account_id = session.get('id')
    cursor = db.cursor()

    try: 
        if request.method == 'POST':
            username = request.form.get('username')
            try:
                sql = "UPDATE accounts SET username = %s WHERE account_id = %s"
                cursor.execute(sql, (username, account_id))
                db.commit()
            except:
                pass
            return redirect(url_for('admin.personal'))
        query = "SELECT username FROM accounts WHERE account_id = %s"
        cursor.execute(query, (account_id,))
        data = cursor.fetchone()
        return render_template("admin/personal.html", data=data)
    finally:
        cursor.close()