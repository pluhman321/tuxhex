from flask import Flask, render_template, request
import os
import socket

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/scan", methods=["POST"])
def scan():
    target = request.form["target"]
    open_ports = []
    for port in range(20, 1025):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(0.5)
            result = s.connect_ex((target, port))
            if result == 0:
                open_ports.append(port)
    return f"<h1>Open ports on {target}:</h1><p>{', '.join(str(p) for p in open_ports)}</p>"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
