from flask import Blueprint, render_template, request, redirect, url_for, session
import config

instructor_bp = Blueprint("instructor", __name__, url_prefix="/instructor")
db = config.database

@instructor_bp.route('/additional', methods=['GET', 'POST'])
def additional():
    cursor = db.cursor()
    query = None
    inputs = {}
    result= None

    # Dropdowns for dept, courses, years
    cursor.execute("SELECT dept_id, name FROM departments")
    depts = cursor.fetchall()
    cursor.execute("SELECT course_id, course_number FROM courses")
    courses = cursor.fetchall()
    cursor.execute("SELECT DISTINCT year FROM sections ORDER BY year DESC")
    years = [row[0] for row in cursor.fetchall()]

    if request.method == 'POST':
        query = request.form.get('query')
        inputs = request.form
        
        if query == 'dept_avg':
            cursor.callproc('average_grade_by_department', [request.form.get('dept_id')])
            result = cursor.fetchone()

        elif query == 'course_avg':
            cursor.callproc('avg_course_grade', [
                request.form.get('course_id'),
                request.form.get('start_semester'), request.form.get('start_year'),
                request.form.get('end_semester'), request.form.get('end_year')
            ])
            result = cursor.fetchone()

        elif query == 'performance':
            performance_choice = request.form.get('performance_choice')
            proc = 'get_best_class' if performance_choice == 'best' else 'get_worst_class'
            cursor.callproc(proc, [request.form.get('semester'), request.form.get('year')])
            result = cursor.fetchone()

        elif query == 'total_dept':
            cursor.callproc('total_students_dept', [request.form.get('dept_id')])
            result = cursor.fetchone()

        elif query == 'current_dept':
            cursor.callproc('current_students_dept', [request.form.get('dept_id')])
            result = cursor.fetchone()

    cursor.close()
    return render_template("instructor/additional.html", 
                           depts=depts, courses=courses, years=years, 
                           result=result, query=query, inputs=inputs)


@instructor_bp.route('/roster', methods=["GET", "POST"])
def roster():
    students = []
    section_id = request.form.get("section_id") or request.args.get("section_id")
    course_name = request.args.get("course_name") or request.form.get("course_name")
    edit_id = request.args.get("edit_id")
        
    cursor = db.cursor()

    try:
        if request.method == "POST":
            if "new_grade" in request.form:
                student_id = request.form.get("student_id")
                new_grade = request.form.get("new_grade")
                cursor.callproc("change_grade", (int(section_id), int(student_id), new_grade))
                db.commit()
                return redirect(url_for('instructor.roster', section_id=section_id, course_name =course_name ))

            elif "remove_student_id" in request.form:
                student_to_remove = request.form.get("remove_student_id")
                cursor.callproc("remove_student_from_section", (int(student_to_remove), int(section_id)))
                db.commit()
                return redirect(url_for('instructor.roster', section_id=section_id, course_name =course_name))

        if section_id:
            cursor.callproc("check_section_roster", (int(section_id),))
            students = cursor.fetchall()
                
    except Exception as e:
        pass
    finally:
        cursor.close()         

    return render_template("instructor/roster.html", students=students, section_id=section_id, course_name=course_name, edit_id=edit_id)

@instructor_bp.route('/section')
def section():
    account_id = session.get('id')
    semester = request.args.get('semester', 'all')
    year_in = request.args.get('year', 'all')
    
    # Accounts for 'all' input for year
    year = int(year_in) if year_in.isdigit() else None
    
    all_sections = []
    cursor = db.cursor()

    try:
        cursor.execute("SELECT instructor_id FROM instructor_accounts WHERE account_id = %s", [account_id])
        instructor = cursor.fetchone()
        instructor_id = instructor[0]

        # Dropdown years
        cursor.execute("SELECT DISTINCT year FROM sections ORDER BY year DESC")
        years = [row[0] for row in cursor.fetchall()]

        cursor.callproc('check_sections_teaching', (instructor_id, semester, year))
        all_sections = cursor.fetchall() 
    except:
        pass
    finally:
        cursor.close()

    return render_template("instructor/section.html", 
                           sections=all_sections, 
                           years=years, 
                           selected_semester=semester, 
                           selected_year=year_in)


@instructor_bp.route('/prerequisites', methods=['GET', 'POST'])
def prerequisites():
    account_id = session.get('id')
    cursor = db.cursor()
    
    if request.method == 'POST':
        course_id = request.form.get('course_id')
        prereq_id = request.form.get('prereq_id')
        
        if 'add' in request.form:
            try:
                cursor.callproc('add_course_prerequisite', [course_id, prereq_id])
                db.commit()
            except:
                pass
        elif 'remove' in request.form:
            cursor.callproc('remove_course_prerequisite', [course_id, prereq_id])
            db.commit()

    # Gets courses for specific instructor
    cursor.execute("""
        SELECT courses.course_id, courses.course_number, courses.title 
        FROM courses 
        JOIN instructors ON courses.dept_id = instructors.dept_id
        JOIN instructor_accounts  ON instructors.instructor_id = instructor_accounts.instructor_id
        WHERE instructor_accounts.account_id = %s
    """, [account_id])
    my_courses = cursor.fetchall()

    # Gets prereqs for courses
    cursor.execute("""
        SELECT prerequisites.course_id, prerequisites.prereq_id, courses.course_number 
        FROM prerequisites 
        JOIN courses ON prerequisites.prereq_id = courses.course_id
    """)

    # Store prereqs in a map 
    prereq_map = {}
    for course_id, prereq_id, course_name in cursor.fetchall():
        if course_id not in prereq_map: prereq_map[course_id] = []
        prereq_map[course_id].append((prereq_id, course_name))
    
    # Dropdown for courses
    cursor.execute("SELECT course_id, course_number FROM courses")
    all_courses = cursor.fetchall()
    
    cursor.close()
    return render_template("instructor/prerequisites.html", 
                           courses=my_courses, 
                           prereq_map=prereq_map, 
                           all_courses=all_courses)


@instructor_bp.route('/advising', methods=['GET', 'POST'])
def advising():
    account_id = session.get('id')
    cursor = db.cursor()
    
    cursor.execute("SELECT instructor_id FROM instructor_accounts WHERE account_id = %s", [account_id])
    instructor_id = cursor.fetchone()

    if request.method == 'POST':
        if 'add_student_id' in request.form:
            student_id = request.form.get('add_student_id')
            cursor.callproc('add_advisee', [student_id, instructor_id])
        elif 'remove_student_id' in request.form:
            student_id = request.form.get('remove_student_id')
            cursor.callproc('remove_advisee', [student_id, instructor_id])
        db.commit()

    cursor.callproc('view_advisees', [instructor_id])
    advisees = cursor.fetchall() 

    # dropdown for students
    cursor.execute("SELECT student_id, first_name, last_name FROM students")
    all_students = cursor.fetchall()
    
    cursor.close()
    return render_template("instructor/advising.html", advisees=advisees, all_students=all_students)


@instructor_bp.route('/personal', methods=['GET', 'POST'])
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
                cursor.callproc('modify_instructor_info', [
                    account_id, username, first_name, last_name, email
                ])
                db.commit()
            except:
                pass
            return redirect(url_for('instructor.personal'))

        query = """
            SELECT instructor_accounts.instructor_id, accounts.username, instructors.first_name, instructors.last_name, instructors.email 
            FROM accounts
            JOIN instructor_accounts ON accounts.account_id = instructor_accounts.account_id
            JOIN instructors ON instructor_accounts.instructor_id = instructors.instructor_id
            WHERE accounts.account_id = %s
        """
        cursor.execute(query, (account_id,))
        data = cursor.fetchone()
        
        return render_template("instructor/personal.html", data=data)
    finally:
        cursor.close()

@instructor_bp.route('/dash')
def dash():
    return render_template("instructor/dash.html")