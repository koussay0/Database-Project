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

@student_bp.route('/personal')
def personal():
    return render_template("student/personal.html")

@student_bp.route('/section')
def section():
    return render_template("student/section.html")