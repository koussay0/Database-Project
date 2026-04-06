from flask import Blueprint, render_template, request, redirect, url_for, session
import config

instructor_bp = Blueprint("instructor", __name__, url_prefix="/instructor")
db = config.database

@instructor_bp.route('/additional')
def additional():
    return render_template("instructor/additional.html")

@instructor_bp.route('/advising')
def advising():
    return render_template("instructor/advising.html")

@instructor_bp.route('/dash')
def dash():
    return render_template("instructor/dash.html")

@instructor_bp.route('/personal')
def personal():
    return render_template("instructor/personal.html")

@instructor_bp.route('/prerequisites')
def prerequisites():
    return render_template("instructor/prerequisites.html")

@instructor_bp.route('/section')
def section():
    return render_template("instructor/section.html")

@instructor_bp.route('/roster')
def roster():
    return render_template("instructor/roster.html")
