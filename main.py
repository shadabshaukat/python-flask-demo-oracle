import os
import flask
from flask import Flask, jsonify, request
from flask import render_template
from flask_cors import CORS
from flask import session, redirect, url_for, request, Response
import oracledb as cx_Oracle

app = Flask(__name__, template_folder='/home/opc/python-flask-demo-oracle')
CORS(app)

# List of API User and Auth Token
VALID_USERS = {'user1': 'password1', 'user2': 'password2'}

# Connect to the Oracle database
con = cx_Oracle.connect(user='admin', password='RAbbithole1234#_',dsn= '(description= (retry_count=20)(retry_delay=3)(address=(protocol=tcps)(port=1521)(host=adb.ap-melbourne-1.oraclecloud.com))(connect_data=(service_name=g9b8049aad9c64c_y16fuv7vqq9428l5_high.adb.oraclecloud.com))(security=(ssl_server_dn_match=yes)))')

@app.route('/api/employees', methods=['GET'])
def get_employees():
    # Fetch all employees from the database
    cur = con.cursor()
    cur.execute('SELECT * FROM employees')
    employees = cur.fetchall()

    # Convert the results to a list of dictionaries
    employees_list = []
    for employee in employees:
        employees_list.append({
            'id': employee[0],
            'name': employee[1],
            'email': employee[2],
            'department': employee[3]
        })

    # Return the list of employees in JSON format
    return jsonify(employees_list)

@app.route('/api/employees/<int:id>', methods=['GET'])
def get_employee(id):
    # Check if the employee with the specified ID exists
    cur = con.cursor()
    cur.execute("SELECT * FROM employees WHERE id = :id", {'id': id})
    employee = cur.fetchone()
    if employee is None:
        return jsonify({'message': 'Employee not found'}), 404

    # Extract the employee data from the database
    name = employee[1]
    email = employee[2]
    department = employee[3]

    # Return the employee data
    return jsonify({'id': id, 'name': name, 'email': email, 'department': department}), 200

@app.route('/api/employees/search/<string:email>', methods=['GET'])
def search_employee(email):
    # Search the employee by email in the database
    cur = con.cursor()
    cur.execute("SELECT * FROM employees WHERE email = :email", {'email': email})
    employee = cur.fetchone()
    if employee is None:
        return jsonify({'message': 'Employee not found'}), 404

    # Extract the employee data from the database
    id = employee[0]
    name = employee[1]
    department = employee[3]

    # Return the employee data
    return jsonify({'id': id, 'name': name, 'email': email, 'department': department}), 200

# HTML Form Method to Create a New Employee
@app.route('/api/add_employee', methods=['GET', 'POST'])
def add_employee_form():
    # Require authentication for all requests
    auth = request.authorization
    if not auth or not check_auth(auth.username, auth.password):
        return authenticate()

    if request.method == 'POST':
        # Extract the employee data from the form
        name = request.form['name']
        email = request.form['email']
        department = request.form['department']

        # Insert the employee into the database
        cur = con.cursor()
        cur.execute("INSERT INTO employees (name, email, department) VALUES (:name, :email, :department)",
                    {'name': name, 'email': email, 'department': department})
        con.commit()

        # Return the ID of the new employee
        return jsonify({'id': cur.lastrowid}), 201
    else:
        return render_template('add_employee.html')


# HTML Method to Get a List of All Employees
@app.route('/api/getall')
def get_all():
    # Require authentication for all requests
    auth = request.authorization
    if not auth or not check_auth(auth.username, auth.password):
        return authenticate()

    cur = con.cursor()
    cur.execute("SELECT * FROM employees")
    rows = cur.fetchall()
    employees = []
    for row in rows:
        employee = {'id': row[0], 'name': row[1], 'email': row[2], 'department': row[3]}
        employees.append(employee)
    return render_template('get_employees.html', employees=employees)

def check_auth(username, password):
    """Check if a username/password combination is valid."""
    return username in VALID_USERS and password == VALID_USERS[username]

def authenticate():
    """Send a 401 Unauthorized response that prompts the user to authenticate."""
    return Response('Could not verify your access level for that URL.\n'
                    'You have to login with proper credentials', 401,
                    {'WWW-Authenticate': 'Basic realm="Login Required"'})


@app.route('/api/employees', methods=['POST'])
def add_employee():
    # Extract the employee data from the request
    data = request.get_json()
    name = data['name']
    email = data['email']
    department = data['department']

    # Check if the employee with the same ID already exists
    cur = con.cursor()
    cur.execute("SELECT * FROM employees WHERE email = :email", {'email': email})
    employee = cur.fetchone()
    if employee is not None:
        return jsonify({'message': 'Employee with same email already exists'}), 400

    # Insert the employee into the database
    cur.execute("INSERT INTO employees (name, email, department) VALUES (:name, :email, :department)",
                {'name': name, 'email': email, 'department': department})
    con.commit()

@app.route('/api/employees/<int:id>', methods=['PUT'])
def update_employee(id):
    # Check if the employee with the specified ID exists
    cur = con.cursor()
    cur.execute("SELECT * FROM employees WHERE id = :id", {'id': id})
    employee = cur.fetchone()
    if employee is None:
        return jsonify({'message': 'Employee not found'}), 404

    # Extract the employee data from the request
    data = request.get_json()
    name = data['name']
    email = data['email']
    department = data['department']

    # Update the employee in the database
    cur.execute("UPDATE employees SET name = :name, email = :email, department = :department WHERE id = :id",
                {'name': name, 'email': email, 'department': department, 'id': id})
    con.commit()

    return jsonify({'message': 'Employee updated successfully'}), 200


@app.route('/api/employees/<int:id>', methods=['DELETE'])
def delete_employee(id):
    # Check if the employee with the specified ID exists
    cur = con.cursor()
    cur.execute("SELECT * FROM employees WHERE id = :id", {'id': id})
    employee = cur.fetchone()
    if employee is None:
        return jsonify({'message': 'Employee not found'}), 404

    # Delete the employee from the database
    cur.execute("DELETE FROM employees WHERE id = :id", {'id': id})
    con.commit()

    return jsonify({'message': 'Employee deleted successfully'}), 200


if __name__ == '__main__':
    # Start the HTTPS server
    app.run(host='0.0.0.0', port=4443, ssl_context=('/home/opc/ssl-certs/cert.pem', '/home/opc/ssl-certs/key.pem'))
