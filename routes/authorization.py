from flask import Blueprint, render_template, request, redirect, url_for, session
from werkzeug.security import generate_password_hash, check_password_hash
import config

auth_bp = Blueprint('auth', __name__)
db = config.database

@auth_bp.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        role = request.form.get('role')
        corresponding_id = request.form.get('input_id') 
        username = request.form.get('username')
        password = generate_password_hash(request.form.get('password'))
        cursor = db.cursor()
         
        try:
            cursor.execute("INSERT INTO accounts (username, password_hash, role) VALUES (%s, %s, %s)", (username, password, role))
            new_account_id = cursor.lastrowid # get the last auto-incremented ID to save in other accounts tables

            if role == 'student':
                cursor.execute("INSERT INTO student_accounts (account_id, student_id) VALUES (%s, %s)", (new_account_id, corresponding_id))
            elif role == 'instructor':
                cursor.execute("INSERT INTO instructor_accounts (account_id, instructor_id) VALUES (%s, %s)", (new_account_id, corresponding_id))
            db.commit()
            return redirect(url_for('.login'))
        except:
            pass
        finally:
            cursor.close() # close cursor rehardless 

    return render_template('authorization/signup.html')

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        cursor = db.cursor()

        sql = """
            SELECT accounts.account_id, accounts.username, accounts.password_hash, accounts.role, 
                   student_accounts.student_id, instructor_accounts.instructor_id
            FROM accounts
            LEFT JOIN student_accounts ON accounts.account_id = student_accounts.account_id
            LEFT JOIN instructor_accounts ON accounts.account_id = instructor_accounts.account_id
            WHERE accounts.username = %s
        """
        cursor.execute(sql, [username])
        account = cursor.fetchone()
        cursor.close()

        if account and check_password_hash(account[2], password):
            session.update({
                'loggedin': True,
                'id': account[0],
                'username': account[1],
                'role': account[3],
                'student_id': account[4],
                'instructor_id': account[5]
            })

            if session['role'] == 'admin':
                return redirect(url_for('admin.dash'))
            elif session['role'] == 'instructor':
                return redirect(url_for('instructor.dash'))
            else:
                return redirect(url_for('student.dash'))
        else:
            pass
    return render_template('authorization/login.html')

@auth_bp.route("/logout")
def logout():
    session.clear()
    return redirect(url_for('.login'))