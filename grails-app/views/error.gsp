<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<title>
		<g:if env="development">
			Grails Runtime Exception
		</g:if>
		<g:else>
			Error
		</g:else>
	</title>
	<g:if env="development">
		<asset:stylesheet src="errors.css"/>
	</g:if>
	<link rel="stylesheet" href="${resource(dir: 'css', file: 'myStylesheet.css')}" type="text/css">
</head>

<body>
	<div class="container">
		<div class="jumbotron" id="errors_jumbotron">
			<div class="errorScrollBar">
				<g:if env="development">
					<g:renderException exception="${exception}" />
				</g:if>
				<g:else>
					<ul class="errors">
						<li>An error has occurred</li>
					</ul>
				</g:else>
			</div>
		</div>
	</div>
</body>

</html>
