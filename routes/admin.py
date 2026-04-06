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

@admin_bp.route('/personal')
def personal():
    return render_template("admin/personal.html")

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
