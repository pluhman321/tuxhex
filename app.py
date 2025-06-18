from flask import Flask, render_template
import os

app = Flask(__name__)

@app.route("/")
def index():
    return "<h1>🚀 TuxHex is live!</h1><p>This is your web dashboard.</p>"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
