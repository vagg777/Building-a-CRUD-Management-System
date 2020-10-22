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
	<g:javascript src="departmentFunctions.js"/>
</head>

<body>
<!-- If user has logged in -->
<g:if test="${session.user}">
	<!-- Navigation Bar -->
	<nav class="navbar navbar-inverse">
		<div class="container-fluid">
			<div class="navbar-header">
				<button class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<img id="navbar-logo" src="../images/logo.png">
			</div>
			<div class="collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav">
					<li><g:link controller="users" action="index">Home</g:link></li>
					<li><g:link controller="employee" action="index">Manage Employees</g:link></li>
					<li class="active"><g:link controller="department" action="index">Manage Departments</g:link></li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li><img id="navbar-user" src="../images/user_icon.png"></li>
					<li><a>Welcome ${session.user}</a></li>
					<li><g:link controller="users" action="logout">Logout</g:link></li>
				</ul>
			</div>
		</div>
	</nav>

	<!-- Department Table -->
	<div class="container">
		<div class="jumbotron">
			<h2>Departments</h2>
			<div class="row">
				<div class="col-md-12">
					<div class="pull-right">
						<button class="btn btn-primary" onclick="resetDepartmentForm('department_name','department_street');" data-toggle="modal" data-target="#add_new_record_modal">Add New Department</button>
					</div>
				</div>
			</div>
			<br>
			<div class="tableScrollBar">
				<table id="departments-table" class="tablesorter table table-hover table-responsive">
					<thead>
						<tr>
							<th>Id</th>
							<th>Name</th>
							<th>Street</th>
							<th class="text-center">Number of Employees</th>
							<th class="text-center non-sortable">Update Department</th>
							<th class="text-center non-sortable">Delete Department</th>
						</tr>
					</thead>
					<tbody>
						<g:each in="${returnedList}" var="celldata">
							<tr>
								<td class="table_id">${celldata.get('id')}</td>
								<td class="table_departmentName">${celldata.get('name')}</td>
								<td class="table_street">${celldata.get('street')}</td>
								<td class="table_employees text-center">${celldata.get('employees_count')}</td>
								<td class="text-center">
									<button type="button" onclick="resetDepartmentForm('department_name1','department_street1'); return getTableData(this);" class="btn btn-warning" data-toggle="modal" data-target="#update_departments_modal">Update</button>
								</td>
								<td class="text-center">
									<g:link controller="department" action="deleteRecord" params="${[id: celldata.get('id')]}">
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
			<g:form controller="department" action="addRecord" id="addRecordForm" role="form" method="post" onsubmit="return departmentValidation('department_name','department_street');">
				<div class="modal-content">
					<div class="modal-header">
						<button class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						<h4 class="modal-title" id="myModalLabel">Add New Department</h4>
					</div>
					<div class="modal-body">
						<p><span class="required">* required field</span></p>
						<div class="form-group">
							<label for="department_name">Department Name</label>
							<span class="required">*</span>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-briefcase"></span></span>
							<input type="text" id="department_name" placeholder="Enter Department Name" autocomplete="off" name="department_name" class="form-control" onkeyup='departmentNameValidation("department_name");'/>
							</div>
							<div class="error-messages" id="department_name_errors"></div>
						</div>
						<div class="form-group">
							<label for="department_street">Department Street</label>
							<span class="required">*</span>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-briefcase"></span></span>
							<input type="text" id="department_street" placeholder="Enter Department Street" autocomplete="off" name="department_street" class="form-control" onkeyup="departmentStreetValidation('department_street');"/>
							</div>
							<div class="error-messages" id="department_street_errors"></div>
						</div>
					</div>
					<div class="modal-footer">
						<button class="btn btn-danger" data-dismiss="modal">Cancel</button>
						<button type="submit" class="btn btn-primary" value="addRecord">Add Department</button>
					</div>
				</div>
			</g:form>
		</div>
	</div>

	<!-- Modal - Update Record -->
	<div class="modal fade" id="update_departments_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel1" aria-hidden="true">
		<div class="modal-dialog">
			<g:form controller="department" action="updateRecord" method="post" onsubmit="return departmentValidation('department_name1','department_street1');">
				<div class="modal-content">
					<div class="modal-header">
						<button class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						<h4 class="modal-title" id="myModalLabel1">Department Details</h4>
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
							<label for="department_name1">Department Name</label>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-briefcase"></span></span>
							<input type="text" id="department_name1" value="" autocomplete="off" name="department_name1" class="form-control" onkeyup="return departmentNameValidation('department_name1');"/>
							</div>
							<div class="error-messages" id="department_name1_errors"></div>
						</div>
						<div class="form-group">
							<label for="department_street1">Department Street</label>
							<div class="input-group">
								<span class="input-group-addon transparent"><span class="glyphicon glyphicon-briefcase"></span></span>
							<input type="text" id="department_street1" value="" autocomplete="off" name="department_street1" class="form-control" onkeyup="return departmentStreetValidation('department_street1');"/>
							</div>
							<div class="error-messages" id="department_street1_errors"></div>
						</div>
					</div>
					<div class="modal-footer">
						<button class="btn btn-danger" data-dismiss="modal">Cancel</button>
						<button type="submit" class="btn btn-primary" value="updateRecord">Save Changes</button>
					</div>
				</div>
			</g:form>
		</div>

	</di
	v>
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