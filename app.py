from __future__ import annotations

from flask import Flask, jsonify, render_template, request

from volume_controller import VolumeController

app = Flask(__name__)
controller = VolumeController()


@app.get("/")
def index():
    return render_template("index.html")


@app.get("/api/status")
def status():
    data = controller.get_status()
    return jsonify(data)


@app.post("/api/volume")
def set_volume():
    payload = request.get_json(silent=True) or {}
    value = payload.get("value")

    if value is None:
        return jsonify({"error": "缺少 value 参数"}), 400

    try:
        value = int(value)
    except (TypeError, ValueError):
        return jsonify({"error": "value 必须是整数"}), 400

    data = controller.set_volume(value)
    return jsonify(data)


@app.post("/api/step")
def step_volume():
    payload = request.get_json(silent=True) or {}
    delta = payload.get("delta")

    if delta is None:
        return jsonify({"error": "缺少 delta 参数"}), 400

    try:
        delta = int(delta)
    except (TypeError, ValueError):
        return jsonify({"error": "delta 必须是整数"}), 400

    data = controller.step(delta)
    return jsonify(data)


@app.post("/api/toggle-mute")
def toggle_mute():
    data = controller.toggle_mute()
    return jsonify(data)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
