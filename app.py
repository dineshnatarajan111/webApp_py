from flask import Flask, jsonify
import requests

app = Flask(__name__)

def get_public_ip():
    """Fetch public IP address from an external service."""
    try:
        response = requests.get('https://api.ipify.org?format=json')
        response.raise_for_status()
        return response.json().get('ip')
    except requests.RequestException as e:
        app.logger.error("Error fetching public IP: %s", e)
        return None

@app.route('/', methods=['GET'])
def public_ip():
    """Endpoint to return the public IP address."""
    ip = get_public_ip()
    if ip:
        return jsonify({"public_ip": ip}), 200
    else:
        return jsonify({"error": "Unable to fetch public IP"}), 500

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"}), 200


if __name__ == '__main__':
    app.run(debug=True)
