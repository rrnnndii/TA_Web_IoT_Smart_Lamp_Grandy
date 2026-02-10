from flask import Flask, render_template, request, redirect, url_for, session, flash
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash
from config import Config
from functools import wraps
from flask import abort


app = Flask(__name__)
app.config.from_object(Config)


def get_db_connection():
    return mysql.connector.connect(
        host=app.config["DB_HOST"],
        user=app.config["DB_USER"],
        password=app.config["DB_PASSWORD"],
        database=app.config["DB_NAME"],

        port=app.config["DB_PORT"],
        use_pure=app.config["DB_USE_PURE"],
        ssl_disabled=app.config["DB_SSL_DISABLED"],
        connection_timeout=app.config["DB_CONNECTION_TIMEOUT"]
    )

def log_activity(user_id, lamp_id, action, description=None, ip_address=None):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO activity_logs (user_id, lamp_id, action, description, ip_address)
        VALUES (%s, %s, %s, %s, %s)
    """, (user_id, lamp_id, action, description, ip_address))

    conn.commit()
    cursor.close()
    conn.close()

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "user_id" not in session:
            return redirect(url_for("login"))
        return f(*args, **kwargs)
    return decorated_function


def role_required(*roles):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if "user_id" not in session:
                return redirect(url_for("login"))

            user_role = session.get("role")

            if user_role not in roles:
                abort(403)  # forbidden
            return f(*args, **kwargs)
        return decorated_function
    return decorator


@app.route("/")
def home():
    return redirect(url_for("login"))

@app.route("/register", methods=["GET", "POST"])
def register():
    # kalau sudah login, jangan register lagi
    if "user_id" in session:
        return redirect(url_for("dashboard"))

    if request.method == "POST":
        name = request.form["name"]
        username = request.form["username"]
        password = request.form["password"]

        password_hash = generate_password_hash(password)

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # cek username sudah ada belum
        cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
        existing = cursor.fetchone()

        if existing:
            flash("Username sudah digunakan!", "danger")
            cursor.close()
            conn.close()
            return redirect(url_for("register"))

        # cek apakah ini user pertama (kalau iya jadi ADMIN)
        cursor.execute("SELECT COUNT(*) AS total FROM users")
        total_users = cursor.fetchone()["total"]

        role = "ADMIN" if total_users == 0 else "USER"

        # insert user baru
        cursor.execute("""
            INSERT INTO users (name, username, password_hash, role)
            VALUES (%s, %s, %s, %s)
        """, (name, username, password_hash, role))

        conn.commit()

        # ambil id user baru
        cursor.execute("SELECT user_id FROM users WHERE username = %s", (username,))
        new_user = cursor.fetchone()
        new_user_id = new_user["user_id"]

        cursor.close()
        conn.close()

        # log activity
        log_activity(
            user_id=new_user_id,
            lamp_id=None,
            action="REGISTER",
            description=f"User {username} mendaftar sebagai {role}",
            ip_address=request.remote_addr
        )

        flash(f"Register berhasil! Role kamu: {role}", "success")
        return redirect(url_for("login"))

    return render_template("auth/register.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
        user = cursor.fetchone()

        cursor.close()
        conn.close()

        if user and check_password_hash(user["password_hash"], password):
            session["user_id"] = user["user_id"]
            session["username"] = user["username"]
            session["role"] = user["role"]

            log_activity(
        user_id=user["user_id"],
        lamp_id=None,
        action="LOGIN",
        description=f"User {user['username']} login",
        ip_address=request.remote_addr
    )

            flash("Login berhasil!", "success")
            return redirect(url_for("dashboard"))
        else:
            flash("Username atau password salah!", "danger")

    return render_template("auth/login.html")

@app.route("/guest")
def guest_login():
    session.clear()

    session["user_id"] = 0
    session["username"] = "guest"
    session["role"] = "GUEST"

    flash("Masuk sebagai Guest (hanya bisa melihat status).", "info")
    return redirect(url_for("dashboard"))


# --- DASHBOARD ---
@app.route("/dashboard")
@login_required
def dashboard():
    if "user_id" not in session:
        return redirect(url_for("login"))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM lamps ORDER BY lamp_id ASC")
    lamps = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("dashboard.html", user=session, lamps=lamps)

@app.route("/lamp/<int:lamp_id>/set-mode", methods=["POST"])
@role_required("ADMIN", "USER")
def set_mode(lamp_id):
    if "user_id" not in session:
        return redirect(url_for("login"))

    new_mode = request.form.get("mode")

    if new_mode not in ["AUTO", "MANUAL"]:
        flash("Mode tidak valid!", "danger")
        return redirect(url_for("dashboard"))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM lamps WHERE lamp_id = %s", (lamp_id,))
    lamp = cursor.fetchone()

    if not lamp:
        cursor.close()
        conn.close()
        flash("Lampu tidak ditemukan!", "danger")
        return redirect(url_for("dashboard"))

    old_mode = lamp["mode"]

    cursor.execute("""
        UPDATE lamps
        SET mode = %s, updated_at = NOW()
        WHERE lamp_id = %s
    """, (new_mode, lamp_id))

    conn.commit()
    cursor.close()
    conn.close()

    # log
    log_activity(
        user_id=session["user_id"],
        lamp_id=lamp_id,
        action="MODE_CHANGE",
        description=f"Mode lampu {lamp_id} dari {old_mode} ke {new_mode}",
        ip_address=request.remote_addr
    )

    flash(f"Mode Lampu {lamp_id} berhasil diubah ke {new_mode}", "success")
    return redirect(url_for("dashboard"))

@app.route("/lamp/<int:lamp_id>/manual", methods=["POST"])
@role_required("ADMIN", "USER")
def manual_control(lamp_id):
    if "user_id" not in session:
        return redirect(url_for("login"))

    command = request.form.get("command")

    if command not in ["ON", "OFF"]:
        flash("Command tidak valid!", "danger")
        return redirect(url_for("dashboard"))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM lamps WHERE lamp_id = %s", (lamp_id,))
    lamp = cursor.fetchone()

    if not lamp:
        cursor.close()
        conn.close()
        flash("Lampu tidak ditemukan!", "danger")
        return redirect(url_for("dashboard"))

    if lamp["mode"] != "MANUAL":
        cursor.close()
        conn.close()
        flash(f"Lampu {lamp_id} sedang AUTO, ubah ke MANUAL dulu!", "warning")
        return redirect(url_for("dashboard"))

    cursor.execute("""
        UPDATE lamps
        SET manual_command = %s,
            relay_state = %s,
            updated_at = NOW()
        WHERE lamp_id = %s
    """, (command, command, lamp_id))

    conn.commit()
    cursor.close()
    conn.close()

    log_activity(
        user_id=session["user_id"],
        lamp_id=lamp_id,
        action="MANUAL_COMMAND",
        description=f"Manual command lampu {lamp_id}: {command}",
        ip_address=request.remote_addr
    )

    flash(f"Lampu {lamp_id} berhasil diubah: {command}", "success")
    return redirect(url_for("dashboard"))

@app.route("/logs")
@role_required('ADMIN')
def logs():
    if "user_id" not in session:
        return redirect(url_for("login"))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT al.*, u.username, l.lamp_name
        FROM activity_logs al
        LEFT JOIN users u ON al.user_id = u.user_id
        LEFT JOIN lamps l ON al.lamp_id = l.lamp_id
        ORDER BY al.log_id DESC
        LIMIT 200
    """)
    logs = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("logs.html", logs=logs)


@app.route("/logout")
def logout():
    user_id = session.get("user_id")
    username = session.get("username")

    # hanya log jika user_id bukan 0
    if user_id and user_id != 0:
        log_activity(
            user_id=user_id,
            lamp_id=None,
            action="LOGOUT",
            description=f"User {username} logout",
            ip_address=request.remote_addr
        )

    session.clear()
    flash("Logout berhasil!", "info")
    return redirect(url_for("login"))


@app.errorhandler(403)
def forbidden(e):
    return render_template("403.html"), 403


if __name__ == "__main__":
    app.run(debug=False, use_reloader=False, threaded=False)
