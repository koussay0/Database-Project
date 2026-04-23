from flask import Blueprint, render_template, request, redirect, url_for, session, flash
import config

admin_bp = Blueprint("admin", __name__, url_prefix="/admin")
db = config.database

@admin_bp.route("/classroom", methods=['GET', 'POST'])
def classroom():
    cursor = db.cursor()
    edit_id = request.args.get('edit_id')

    if request.method == 'POST':
        try:
            if 'update_classroom' in request.form:
                cursor.callproc('update_classroom', [
                    request.form.get('classroom_id'), request.form.get('building_id'),
                    request.form.get('room_number'), request.form.get('capacity')
                ])
                db.commit()
                return redirect(url_for('admin.classroom'))
            
            elif 'add_classroom' in request.form:
                cursor.callproc('create_classroom', [
                    request.form.get('building_id'), request.form.get('room_number'),
                    request.form.get('capacity')
                ])
                db.commit()
            
            elif 'remove_classroom' in request.form:
                cursor.callproc('delete_classroom', [request.form.get('remove_classroom')])
                db.commit()
        except Exception:
            db.rollback()
            flash("Cannot delete: This classroom is assigned to a course section.")

    cursor.callproc('read_classroom')
    rooms = cursor.fetchall()
    cursor.execute("SELECT building_id, name FROM buildings")
    buildings = cursor.fetchall()
    cursor.close()
    return render_template("admin/classroom.html", classrooms=rooms, buildings=buildings, edit_id=edit_id)

@admin_bp.route("/dept", methods=['GET', 'POST'])
def dept():
    cursor = db.cursor()
    edit_id = request.args.get('edit_id')

    if request.method == 'POST':
        try:
            if 'update_department' in request.form:
                cursor.callproc('update_department', [
                    request.form.get('dept_id'), request.form.get('name'),
                    request.form.get('budget'), request.form.get('building_id')
                ])
                db.commit()
                return redirect(url_for('admin.dept'))
            
            elif 'add_department' in request.form:
                cursor.callproc('create_department', [
                    request.form.get('name'), request.form.get('budget'),
                    request.form.get('building_id')
                ])
                db.commit()
            
            elif 'remove_department' in request.form:
                cursor.callproc('delete_department', [request.form.get('remove_department')])
                db.commit()
        except Exception:
            db.rollback()
            flash("Cannot delete: This department has instructors, students, or courses assigned to it.")

    cursor.callproc('read_department')
    departments = cursor.fetchall()
    cursor.execute("SELECT building_id, name FROM buildings")
    buildings = cursor.fetchall()
    cursor.close()
    return render_template("admin/dept.html", departments=departments, buildings=buildings, edit_id=edit_id)

@admin_bp.route("/instructor", methods=['GET', 'POST'])
def instructor():
    cursor = db.cursor()
    edit_id = request.args.get('edit_id')

    if request.method == 'POST':
        try:
            if 'update_instructor' in request.form:
                cursor.callproc('update_instructor', [
                    request.form.get('instructor_id'), request.form.get('first_name'),
                    request.form.get('last_name'), request.form.get('email'),
                    request.form.get('salary'), request.form.get('dept_id')
                ])
                db.commit()
                return redirect(url_for('admin.instructor'))
            
            elif 'add_instructor' in request.form:
                cursor.callproc('create_instructor', [
                    request.form.get('first_name'), request.form.get('last_name'),
                    request.form.get('email'), request.form.get('salary'),
                    request.form.get('dept_id')
                ])
                db.commit()
            
            elif 'remove_instructor' in request.form:
                cursor.callproc('delete_instructor', [request.form.get('remove_instructor')])
                db.commit()
        except Exception:
            db.rollback()
            flash("Cannot delete: This instructor is assigned as an advisor or currently teaches a section.")

    cursor.callproc('read_instructors')
    instructors = cursor.fetchall()
    cursor.execute("SELECT dept_id, name FROM departments")
    depts = cursor.fetchall()
    cursor.close()
    return render_template("admin/instructor.html", instructors=instructors, depts=depts, edit_id=edit_id)

@admin_bp.route("/section", methods=['GET', 'POST'])
def section():
    cursor = db.cursor()
    edit_id = request.args.get('edit_id')

    if request.method == 'POST':
        try:
            if 'update_section' in request.form:
                args = [
                    request.form.get('section_id'), request.form.get('course_id'),
                    request.form.get('classroom_id'), request.form.get('timeslot_id'),
                    request.form.get('semester'), request.form.get('year'), 
                    request.form.get('capacity')
                ]
                cursor.callproc('update_section', args)
                db.commit()
                return redirect(url_for('admin.section'))
            
            elif 'add_section' in request.form:
                args = [
                    request.form.get('course_id'), request.form.get('classroom_id'),
                    request.form.get('timeslot_id'), request.form.get('semester'),
                    request.form.get('year'), request.form.get('capacity')
                ]
                cursor.callproc('create_section', args)
                db.commit()
                
            elif 'remove_section' in request.form:
                cursor.callproc('delete_section', [request.form.get('remove_section')])
                db.commit()
        except Exception:
            db.rollback()
            flash("Cannot delete: This section has students enrolled.")

    cursor.callproc('read_sections')
    sections = cursor.fetchall() 
    cursor.execute("SELECT course_id, course_number FROM courses")
    all_courses = cursor.fetchall()
    cursor.execute("""
        SELECT classrooms.classroom_id, buildings.name, classrooms.room_number 
        FROM classrooms 
        JOIN buildings ON classrooms.building_id = buildings.building_id
    """)
    all_rooms = cursor.fetchall()
    cursor.execute("SELECT timeslot_id, day, start_time, end_time FROM timeslots")
    all_timeslots = cursor.fetchall()
    cursor.close()
    return render_template("admin/section.html", sections=sections, all_courses=all_courses, all_rooms=all_rooms, all_timeslots=all_timeslots, edit_id=edit_id)

@admin_bp.route("/student", methods=['GET', 'POST'])
def student():
    cursor = db.cursor()
    edit_id = request.args.get('edit_id')

    if request.method == 'POST':
        try:
            if 'update_student' in request.form:
                cursor.callproc('update_student', [
                    request.form.get('student_id'), request.form.get('first_name'),
                    request.form.get('last_name'), request.form.get('email'), request.form.get('dept_id')
                ])
                db.commit()
                return redirect(url_for('admin.student')) 
            elif 'add_student' in request.form:
                cursor.callproc('create_student', [
                    request.form.get('first_name'), request.form.get('last_name'),
                    request.form.get('email'), request.form.get('dept_id')
                ])
                db.commit()
            elif 'remove_student' in request.form:
                cursor.callproc('delete_student', [request.form.get('remove_student')])
                db.commit()
        except Exception:
            db.rollback()
            flash("Cannot delete: This student has an associated account.")

    cursor.callproc('read_students')
    students = cursor.fetchall() 
    cursor.execute("SELECT dept_id, name FROM departments")
    depts = cursor.fetchall()
    cursor.close()
    return render_template("admin/student.html", students=students, depts=depts, edit_id=edit_id)

@admin_bp.route("/timeslot", methods=['GET', 'POST'])
def timeslot():
    cursor = db.cursor()
    edit_id = request.args.get('edit_id')

    if request.method == 'POST':
        try:
            if 'update_timeslot' in request.form:
                cursor.callproc('update_timeslot', [
                    request.form.get('timeslot_id'), request.form.get('day'),
                    request.form.get('start_time'), request.form.get('end_time')
                ])
                db.commit()
                return redirect(url_for('admin.timeslot'))
            elif 'add_timeslot' in request.form:
                cursor.callproc('create_timeslot', [
                    request.form.get('day'), request.form.get('start_time'), request.form.get('end_time')
                ])
                db.commit()
            elif 'remove_timeslot' in request.form:
                cursor.callproc('delete_timeslot', [request.form.get('remove_timeslot')])
                db.commit()
        except Exception:
            db.rollback()
            flash("Cannot delete: This timeslot is used by sections.")

    cursor.callproc('read_timeslot')
    timeslots = cursor.fetchall()
    cursor.close()
    return render_template("admin/timeslot.html", timeslots=timeslots, edit_id=edit_id)

@admin_bp.route("/course", methods = ['GET', 'POST'])
def course():
    cursor = db.cursor()
    edit_id = request.args.get('edit_id')

    if request.method == 'POST':
        try:
            if 'update_course' in request.form:
                cursor.callproc('update_course', [
                    request.form.get('course_id'), request.form.get('dept_id'),
                    request.form.get('course_number'), request.form.get('title'), request.form.get('credit')
                ])
                db.commit()
                return redirect(url_for('admin.course')) 
            elif 'add_course' in request.form:
                cursor.callproc('create_course', [
                    request.form.get('dept_id'), request.form.get('course_number'),
                    request.form.get('title'), request.form.get('credit')
                ])
                db.commit()
            elif 'remove_course' in request.form:
                cursor.callproc('delete_course', [request.form.get('remove_course')])
                db.commit()
        except Exception:
            db.rollback()
            flash("Cannot delete: This course has sections with enrollments.")

    cursor.callproc('read_courses', ())
    courses = cursor.fetchall() 
    cursor.execute("SELECT dept_id, name FROM departments")
    depts = cursor.fetchall()
    cursor.close()
    return render_template("admin/course.html", courses=courses, depts=depts, edit_id = edit_id)

@admin_bp.route('/teaching', methods=['GET', 'POST'])
def teaching():
    cursor = db.cursor()
    if request.method == 'POST':
        instructor_id = request.form.get('instructor_id')
        section_id = request.form.get('section_id')
        try:
            if 'add' in request.form:
                cursor.callproc('assign_instructor_to_section', [instructor_id, section_id])
                db.commit()
            elif 'remove' in request.form:
                cursor.callproc('remove_instructor_from_section', [instructor_id, section_id])
                db.commit()
        except Exception:
            db.rollback()

    cursor.execute("SELECT instructor_id, first_name, last_name FROM instructors")
    instructors = cursor.fetchall()
    cursor.execute("""
        SELECT teaches.instructor_id, teaches.section_id, courses.course_number, sections.semester, sections.year
        FROM teaches 
        JOIN sections ON teaches.section_id = sections.section_id
        JOIN courses ON sections.course_id = courses.course_id
    """)
    teaching_map = {}
    for inst_id, sec_id, c_num, sem, yr in cursor.fetchall():
        if inst_id not in teaching_map: teaching_map[inst_id] = []
        teaching_map[inst_id].append((sec_id, f"{c_num} ({sem} {yr})"))
    
    cursor.execute("""
        SELECT s.section_id, c.course_number, s.semester, s.year, b.name, r.room_number, t.day, t.start_time, t.end_time
        FROM sections s
        JOIN courses c ON s.course_id = c.course_id
        LEFT JOIN classrooms r ON s.classroom_id = r.classroom_id
        LEFT JOIN buildings b ON r.building_id = b.building_id
        LEFT JOIN timeslots t ON s.timeslot_id = t.timeslot_id
        ORDER BY s.year DESC, s.semester, c.course_number
    """)
    all_sections = cursor.fetchall()
    cursor.close()
    return render_template("admin/teaching.html", instructors=instructors, teaching_map=teaching_map, all_sections=all_sections)

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
            except Exception:
                db.rollback()
            return redirect(url_for('admin.personal'))
        query = "SELECT username FROM accounts WHERE account_id = %s"
        cursor.execute(query, (account_id,))
        data = cursor.fetchone()
        return render_template("admin/personal.html", data=data)
    finally:
        cursor.close()

@admin_bp.route('/dash', methods=["GET", "POST"])
def dash():
    return render_template("admin/dash.html")