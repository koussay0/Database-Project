from flask import Blueprint, render_template, request, redirect, url_for, session
import config

admin_bp = Blueprint("admin", __name__, url_prefix="/admin")
db = config.database

@admin_bp.route('/classroom')
def classroom():
    return render_template("admin/classroom.html")

@admin_bp.route("/course")
def course():
    return render_template("admin/course.html")

@admin_bp.route('/dash')
def dash():
    return render_template("admin/dash.html")

@admin_bp.route('/dept')
def dept():
    return render_template("admin/dept.html")

@admin_bp.route("/instructor")
def instructor():
    return render_template("admin/instructor.html")

@admin_bp.route("/section")
def section():
    return render_template("admin/section.html")

@admin_bp.route('/student')
def student():
    return render_template("admin/student.html")

@admin_bp.route("/teaching")
def teaching():
    return render_template("admin/teaching.html")

@admin_bp.route('/timeslot')
def timeslot():
    return render_template("admin/timeslot.html")

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