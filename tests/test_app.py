import unittest
from app import app
import re

class TestPublicIP(unittest.TestCase):

    def setUp(self):
        # Setup the Flask test client
        self.app = app.test_client()
        self.app.testing = True

    def test_get_public_ip(self):
        # Send a GET request to the root endpoint
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)

        # Verify the response contains a valid IP address format
        ip_data = response.get_json()
        ip_address = ip_data.get("public_ip", "")

        # Regular expression for validating IPv4 addresses
        ip_pattern = re.compile(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$')
        self.assertTrue(ip_pattern.match(ip_address), "Invalid IP address format")

if __name__ == '__main__':
    unittest.main()
