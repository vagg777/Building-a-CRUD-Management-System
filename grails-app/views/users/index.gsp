<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="${resource(dir: 'css', file: 'myStylesheet.css')}" type="text/css">
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
					<li class="active"><g:link controller="users" action="index">Home</g:link></li>
					<li><g:link controller="employee" action="index">Manage Employees</g:link></li>
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

	<div class="container">
		<div class="jumbotron" id="users_jumbotron">
			<img src="../images/logo.png" class="center-block"/><br>
			<div class="text-center">
				<h3><strong>Welcome ${session.user}</strong></h3>
			</div>
			<br><br/>
			<p>This is a simple CRUD Page Panel using Grails Framework 2.5.6, in addition with Java Development Kit 1.7</p>
			<p>You can Create, Read, Delete or Update everything you want by using the options in the Navigation Bar above.
			For the purposes of the Web Application, a local SQL Server must be running at all times.</p>
			<p>The Database consists of 3 tables, one for the users that can have access to this administration panel, one for the Employees of the company and one for the Departments
			the company owns.</p>
			<p>Feel free to edit whatever you like!!!</p>
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