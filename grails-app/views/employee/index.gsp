<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" type="text/css">
	<link rel="stylesheet" href="${resource(dir: 'css', file: 'myStylesheet.css')}" type="text/css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<g:javascript src="Tablesorter/docs/js/jquery-latest.min.js"/>
	<g:javascript src="Tablesorter/js/jquery.tablesorter.min.js"/>
	<g:javascript src="Tablesorter/js/tableSorter.js"/>
	<g:javascript src="employeeFunctions.js"/>
</head>

<body>
<!-- If user has logged in -->
<g:if test="${session.user}">
	<!-- Navigation Bar -->
	<nav class="navbar navbar-inverse">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<img id="navbar-logo" src="../images/logo.png">
			</div>
			<div class="collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav">
					<li><g:link controller="users" action="index">Home</g:link></li>
					<li class="active"><g:link controller="employee" action="index">Manage Employees</g:link></li>
					<li><g:link controller="department" action="index">Manage Departments</g:link></li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li><img id="navbar-user" src="../images/user_icon.png"></li>
					<li><a>Welcome ${session.user}</a></li>
					<li><g:link controller="users" action="logout">Logout</g:link></li>
				</ul>
			</div>
		</div>
	</nav>

	<!-- Employees Table -->
	<div class="container">
		<div class="jumbotron">
			<h2>Employees</h2>
			<div class="row">
				<div class="col-md-12">
					<div class="pull-right">
						<button class="btn btn-primary" data-toggle="modal" data-target="#add_new_record_modal" onclick="resetEmployeeForm('first_name','last_name','email','born','country','department_id');">Add New Employee</button>
					</div>
				</div>
			</div><br>
			<div class="tableScrollBar">
				<table id="employees-table" class="tablesorter table table-hover table-responsive">
				<thead>
					<tr>
						<th>Id</th>
						<th>Firstname</th>
						<th>Lastname</th>
						<th>Email Address</th>
						<th>Born</th>
						<th>Country</th>
						<th>Department</th>
						<th class="text-center non-sortable">Update Employee</th>
						<th class="text-center non-sortable">Delete Employee</th>
					</tr>
				</thead>
				<tbody>
					<g:each in="${returnedList}" var="celldata">
						<tr>
							<td class="table_id">${celldata.get('id')}</td>
							<td class="table_firstName">${celldata.get('first_name')}</td>
							<td class="table_lastName">${celldata.get('last_name')}</td>
							<td class="table_email">${celldata.get('email')}</td>
							<td class="table_born">${celldata.get('born')}</td>
							<td class="table_country">${celldata.get('country')}</td>
							<td class="table_departmentId">${celldata.get('department_id')}</td>
							<td class="text-center">
								<button onclick="resetEmployeeForm('first_name1','last_name1','email1','born1','country1','department_id1'); return getTableData(this);" class="btn btn-warning" data-toggle="modal" data-target="#update_employee_modal">Update</button>
							</td>
							<td class="text-center">
								<g:link controller="employee" action="deleteRecord" params="${[id: celldata.get('id')]}">
									<button class="btn btn-danger" onclick="return confirm('Are you sure???')">Delete</button>
								</g:link>
							</td>
						</tr>
					</g:each>
				</tbody>
			</table>
			</div>
		</div>
	</div>

	<!-- Modal - Add New Record -->
	<div class="modal fade" id="add_new_record_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<g:form controller="employee" action="addRecord" id="addRecordForm" method="post" onsubmit="return employeeValidation('first_name','last_name','email','born','country','department_id');">
				<div class="modal-content">
					<div class="modal-header">
						<button class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						<h4 class="modal-title" id="myModalLabel">Add New Employee</h4>
					</div>
					<div class="modal-body">
						<p><span class="required">* required field</span></p>
						<div class="form-group">
							<label for="first_name">First Name</label>
							<span class="required">*</span>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-user"></span></span>
								<input type="text" id="first_name" placeholder="Enter First Name" autocomplete="off" name="first_name" class="form-control" onkeyup="return employeeFirstnameValidation('first_name');"/>
							</div>
							<div class="error-messages" id="first_name_errors"></div>
						</div>
						<div class="form-group">
							<label for="last_name">Last Name</label>
							<span class="required">*</span>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-user"></span></span>
								<input type="text" id="last_name" placeholder="Enter Last Name" autocomplete="off" name="last_name" class="form-control" onkeyup="return employeeLastnameValidation('last_name');"/>
							</div>
							<div class="error-messages" id="last_name_errors"></div>
						</div>
						<div class="form-group">
							<label for="email">E-mail</label>
							<span class="required">*</span>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-envelope"></span></span>
								<input type="text" id="email" placeholder="Enter E-mail" autocomplete="off" name="email" class="form-control" onkeyup="return employeeEmailValidation('email');"/>
							</div>
							<div class="error-messages" id="email_errors"></div>
						</div>
						<div class="form-group">
							<label for="born">Birth Year</label>
							<span class="required">*</span>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-home"></span></span>
								<input type="text" id="born" placeholder="Enter Birth Year" autocomplete="off" name="born" class="form-control" onkeyup="return employeeBornValidation('born');"/>
							</div>
							<div class="error-messages" id="born_errors"></div>
						</div>
						<div class="form-group">
							<label for="country">Country</label>
							<span class="required">*</span>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-globe"></span></span>
								<select class="form-control" id="country" name="country" title="Enter Department Country" onchange="return employeeCountryValidation('country');">
									<option value="" disabled="disabled" selected="selected">Enter Department Country</option>
									<g:each in="${countriesList}" var="celldata">
										<option value="${celldata}">${celldata}</option>
									</g:each>
								</select>
							</div>
							<div class="error-messages" id="country_errors"></div>
						</div>
						<div class="form-group">
							<label for="department_id">Department Name</label>
							<span class="required">*</span>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-briefcase"></span></span>
								<select class="form-control" id="department_id" name="department_id" title="Enter Department Name" onchange="return employeeDepartmentIdValidation('department_id');">
									<option value="" disabled="disabled" selected="selected">Enter Department Name</option>
									<g:each in="${departmentsList}" var="celldata">
										<option>${celldata.get('department_id')}</option>
									</g:each>
								</select>
							</div>
							<div class="error-messages" id="department_id_errors"></div>
						</div>
					</div>
					<div class="modal-footer">
						<button class="btn btn-danger" data-dismiss="modal">Cancel</button>
						<button type="submit" class="btn btn-primary" value="addRecord">Add Employee</button>
					</div>
				</div>
			</g:form>
		</div>
	</div>

	<!-- Modal - Update Record -->
	<div class="modal fade" id="update_employee_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel1" aria-hidden="true">
		<div class="modal-dialog">
			<g:form controller="employee" action="updateRecord" method="post"  onsubmit="return employeeValidation('first_name1','last_name1','email1','born1','country1','department_id1');">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						<h4 class="modal-title" id="myModalLabel1">Employee Details</h4>
					</div>
					<div class="modal-body">
						<div class="form-group">
							<label for="id1">Id</label>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-pencil"></span></span>
								<input type="text" id="id1" name="id1" value="" class="form-control" readonly="readonly"/>
							</div>
						</div>
						<div class="form-group">
							<label for="first_name1">First Name</label>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-user"></span></span>
								<input type="text" id="first_name1" value="" autocomplete="off" name="first_name1" class="form-control" onkeyup="return employeeFirstnameValidation('first_name1');"/>
							</div>
							<div class="error-messages" id="first_name1_errors"></div>
						</div>
						<div class="form-group">
							<label for="last_name1">Last Name</label>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-user"></span></span>
							<input type="text" id="last_name1" value="" name="last_name1" autocomplete="off" class="form-control" onkeyup="return employeeLastnameValidation('last_name1');"/>
							</div>
							<div class="error-messages" id="last_name1_errors"></div>
						</div>
						<div class="form-group">
							<label for="email1">Email</label>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-envelope"></span></span>
								<input type="text" id="email1" value="" name="email1" autocomplete="off" class="form-control" onkeyup="return employeeEmailValidation('email1');"/>
							</div>
							<div class="error-messages" id="email1_errors"></div>
						</div>
						<div class="form-group">
							<label for="born1">Birth Year</label>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-home"></span></span>
								<input type="text" id="born1" value="" name="born1" autocomplete="off" class="form-control" onkeyup="return employeeBornValidation('born1');"/>
							</div>
							<div class="error-messages" id="born1_errors"></div>
						</div>
						<div class="form-group">
							<label for="country1">Country</label>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-globe"></span></span>
								<select class="form-control" id="country1" name="country1" onchange="return employeeCountryValidation('country1');">
									<g:each in="${countriesList}" var="celldata">
										<option value="${celldata}">${celldata}</option>
									</g:each>
								</select>
							</div>
							<div class="error-messages" id="country1_errors"></div>
						</div>
						<div class="form-group">
							<label for="department_id1">Department Name</label>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-briefcase"></span></span>
								<select class="form-control" id="department_id1" name="department_id1" onchange="return employeeDepartmentIdValidation('department_id1');">
									<g:each in="${departmentsList}" var="celldata">
										<option value="${celldata.get('department_id')}">${celldata.get('department_id')}</option>
									</g:each>
								</select>
							</div>
							<div class="error-messages" id="department_id1_errors"></div>
						</div>
					</div>
					<div class="modal-footer">
						<button class="btn btn-danger" data-dismiss="modal">Cancel</button>
						<button type="submit" class="btn btn-primary" value="updateRecord">Save Changes</button>
					</div>
				</div>
			</g:form>
		</div>
	</div>
</g:if>
<g:else>
	<div class="modal fade in errorModal" id="memberModal" tabindex="-1" role="dialog" aria-labelledby="memberModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="memberModalLabel">An error has occured!!</h4>
				</div>
				<div class="modal-body">
					<p class="errorMessageParagraph">You do not have permissions to access this site yet unless you login!<p>
					<p class="errorHyperlinkParagraph"><g:link controller="users" action="permissionsMissingLogin">REDIRECT ME TO THE LOGIN PAGE</g:link></p>
				</div>
			</div>
		</div>
	</div>
</g:else>
</body>

</html>