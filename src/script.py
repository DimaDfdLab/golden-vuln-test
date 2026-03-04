# ============================================================================
# INTENTIONALLY VULNERABLE PYTHON FILE - FOR SECURITY SCANNER TESTING ONLY
# This file contains deliberate security issues to trigger Bandit findings.
# DO NOT use this code in production.
# ============================================================================

import os
import sys
import hashlib
import pickle
import random
import subprocess
import sqlite3
import tempfile
from http.server import HTTPServer, SimpleHTTPRequestHandler

# B105: Hardcoded password
PASSWORD = "SuperSecretPassword123!"
DB_PASSWORD = "admin123"
API_KEY = "sk-1234567890abcdef"
SECRET_KEY = "my-secret-jwt-key-do-not-share"

# B303: Use of weak hash - MD5
def hash_password_md5(password):
    return hashlib.md5(password.encode()).hexdigest()

# B303: Use of weak hash - SHA1
def hash_password_sha1(password):
    return hashlib.sha1(password.encode()).hexdigest()

# B307: Use of eval()
def evaluate_expression(expr):
    result = eval(expr)
    return result

# B102: Use of exec()
def execute_code(code_string):
    exec(code_string)

# B602: subprocess with shell=True
def run_command(user_input):
    output = subprocess.call(user_input, shell=True)
    return output

# B603: subprocess without shell but with user input
def run_process(cmd):
    result = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    return result.communicate()

# B301: Use of pickle.loads (deserialization vulnerability)
def load_data(serialized_data):
    data = pickle.loads(serialized_data)
    return data

# B608: SQL injection via string formatting
def get_user(username):
    conn = sqlite3.connect("users.db")
    cursor = conn.cursor()
    query = "SELECT * FROM users WHERE username = '%s'" % username
    cursor.execute(query)
    return cursor.fetchone()

# B608: SQL injection via f-string
def delete_user(user_id):
    conn = sqlite3.connect("users.db")
    cursor = conn.cursor()
    cursor.execute(f"DELETE FROM users WHERE id = {user_id}")
    conn.commit()

# B104: Binding to all interfaces
def start_server():
    server = HTTPServer(("0.0.0.0", 8080), SimpleHTTPRequestHandler)
    server.serve_forever()

# B311: Use of random for security/cryptographic purposes (weak RNG)
def generate_token():
    token = "".join([chr(random.randint(65, 90)) for _ in range(32)])
    return token

def generate_otp():
    return random.randint(100000, 999999)

# B110: Try/except/pass (bare except that silently swallows errors)
def unsafe_operation():
    try:
        result = eval("os.system('whoami')")
        return result
    except:
        pass

# B101: Use of assert for security checks
def check_admin(user):
    assert user.is_admin, "User must be admin"
    return True

def validate_token(token):
    assert len(token) > 0, "Token must not be empty"
    assert token.startswith("Bearer "), "Invalid token format"
    return True

# B108: Hardcoded temp directory
def write_temp_file(data):
    filepath = "/tmp/sensitive_data.txt"
    with open(filepath, "w") as f:
        f.write(data)
    return filepath

# B501: requests with verify=False
def fetch_url(url):
    import requests
    response = requests.get(url, verify=False)
    return response.text

# B320: Use of lxml without defusing
def parse_xml(xml_string):
    from lxml import etree
    root = etree.fromstring(xml_string)
    return root

# B506: Use of yaml.load without SafeLoader
def load_yaml(yaml_string):
    import yaml
    data = yaml.load(yaml_string)
    return data

# Main entry point with multiple issues
if __name__ == "__main__":
    print("Starting vulnerable application...")

    # Hardcoded credentials used directly
    db_conn_string = f"postgresql://admin:{DB_PASSWORD}@localhost:5432/mydb"

    # Eval user input
    user_expr = input("Enter expression: ")
    print(evaluate_expression(user_expr))

    # Run arbitrary commands
    cmd = input("Enter command: ")
    run_command(cmd)

    # Weak hashing
    hashed = hash_password_md5(PASSWORD)
    print(f"MD5 hash: {hashed}")

    # Insecure token generation
    token = generate_token()
    print(f"Token: {token}")
