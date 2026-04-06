from flask import Flask, render_template
from routes.authorization import auth_bp
from routes.admin import admin_bp
from routes.instructor import instructor_bp
from routes.student import student_bp

def create_app():
    app = Flask(__name__)
    app.secret_key = 'your_secret_key'

    app.register_blueprint(auth_bp, url_prefix="/auth")
    app.register_blueprint(admin_bp, url_prefix="/admin")
    app.register_blueprint(instructor_bp, url_prefix="/instructor")
    app.register_blueprint(student_bp, url_prefix="/student")

    @app.route("/")
    def index():
        return render_template("authorization/login.html")
    return app

if __name__ == "__main__":
    app = create_app()
    app.run(debug=True)