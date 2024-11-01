from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/')
def get_public_ip():
    user_ip = request.remote_addr  # This fetches the IP address of the requester
    return jsonify({"public_ip": user_ip})

if __name__ == '__main__':
    app.run(debug=True)
