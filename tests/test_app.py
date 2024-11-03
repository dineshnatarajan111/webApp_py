import sys
import os

# Add the root directory of the project to the Python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import requests
import pytest
from app import app, get_public_ip
from unittest.mock import patch

@pytest.fixture
def client():
    """Create a test client for the app."""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_get_public_ip_success():
    """Test that get_public_ip() successfully retrieves an IP address."""
    with patch('requests.get') as mock_get:
        mock_get.return_value.json.return_value = {'ip': '123.123.123.123'}
        mock_get.return_value.status_code = 200
        ip = get_public_ip()
        assert ip == '123.123.123.123'

def test_get_public_ip_failure():
    """Test get_public_ip() returns None when request fails."""
    with patch('requests.get') as mock_get:
        mock_get.side_effect = requests.RequestException
        ip = get_public_ip()
        assert ip is None

def test_public_ip_endpoint_success(client):
    """Test the / endpoint returns the correct public IP."""
    with patch('app.get_public_ip', return_value='123.123.123.123'):
        response = client.get('/')
        assert response.status_code == 200
        assert response.json == {"public_ip": "123.123.123.123"}

def test_public_ip_endpoint_failure(client):
    """Test the / endpoint returns an error if IP fetching fails."""
    with patch('app.get_public_ip', return_value=None):
        response = client.get('/')
        assert response.status_code == 500
        assert response.json == {"error": "Unable to fetch public IP"}
