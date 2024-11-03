# Flask Public IP Web App

This is a Python Flask web application that, when accessed, returns a JSON object containing the public IP address of the server it's running on. The app includes unit tests located in `/test/test_app.py`.

---

## Table of Contents
- [Setup](#setup)
  - [Installing Python 3](#installing-python-3)
    - [macOS](#macos)
    - [Windows](#windows)
  - [Installing Dependencies](#installing-dependencies)
- [Running the Application](#running-the-application)
- [Testing](#testing)
  - [Running Tests on macOS](#running-tests-on-macos)
  - [Running Tests on Windows](#running-tests-on-windows)
- [Accessing the Public IP JSON](#accessing-the-public-ip-json)
- [CI/CD and Deployment](#ci-cd-and-deployment)
  - [Jenkins](#jenkins)
  - [Argo CD](#argo-cd)
  - [Helm](#helm)
- [Example Response](#example-response)
- [License](#license)

---

## Setup

### Installing Python 3

#### macOS
1. **Check if Python 3 is installed**:  
   ```bash
   python3 --version
   ```
2. **Install Python 3** (if not installed):
   - You can install Python 3 using [Homebrew](https://brew.sh/):
     ```bash
     brew install python
     ```
   - Or download the latest version from the [official website](https://www.python.org/downloads/).

#### Windows
1. **Check if Python 3 is installed**:  
   ```powershell
   python --version
   ```
2. **Install Python 3** (if not installed):
   - Download the latest version from the [official website](https://www.python.org/downloads/).
   - During installation, make sure to check the option to add Python to your PATH.

### Installing Dependencies
1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```
2. Set up a virtual environment (recommended):
   ```bash
   python3 -m venv venv
   ```
3. Activate the virtual environment:
   - **macOS**:
     ```bash
     source venv/bin/activate
     ```
   - **Windows**:
     ```powershell
     venv\Scripts\activate
     ```
4. Install required packages:
   ```bash
   pip3 install -r requirements.txt
   ```

---

## Running the Application

To start the Flask server, run:
```bash
python3 app.py
```
The application should start on `http://127.0.0.1:5000`.

---

## Testing

Unit tests are included in `/test/test_app.py`.

### Running Tests on macOS
1. Ensure your virtual environment is activated:
   ```bash
   source venv/bin/activate
   ```
2. Run tests using `pytest`:
   ```bash
   python -m pytest test/test_app.py
   ```

### Running Tests on Windows
1. Ensure your virtual environment is activated:
   ```powershell
   venv\Scripts\activate
   ```
2. Run tests using `pytest`:
   ```powershell
   python -m pytest test/test_app.py
   ```

---

## Accessing the Public IP JSON

Once the server is running, you can access the JSON containing the public IP address by navigating to:
```plaintext
http://127.0.0.1:5000/
```

You can also check the response by using `curl`:
```bash
curl http://127.0.0.1:5000/
```

---

## CI/CD and Deployment

### Jenkins
Continuous integration is managed through Jenkins. The Jenkins instance is localhost so Screen-Shots are pasted in image/jenkins.

### Argo CD
Deployment to the desired environment is managed by Argo CD, which provides a GitOps-based continuous deployment. The ArgoCD instance is localhost so Screen-Shots are pasted in image/Argo-CD.

### Helm
Helm is used to manage Kubernetes deployments, with values and configurations stored in the Helm repositories below:
- **Helm Chart Repository**: [https://github.com/dineshnatarajan111/webapp-helm-chart.git](https://github.com/dineshnatarajan111/webapp-helm-chart.git)
- **Helm Values Repository** (current state documentation): [https://github.com/dineshnatarajan111/webapp-helm-values.git](https://github.com/dineshnatarajan111/webapp-helm-values.git)

---

## Example Response
```json
{
    "public_ip": "123.45.67.89"
}
```

---