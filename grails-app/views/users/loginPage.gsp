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
    <g:javascript src="usersFunctions.js"/>
</head>

<body>
<g:set var="counter" value="${true}"/>
<g:if test="${session.user}">
    <div class="modal fade in errorModal" id="memberModal" tabindex="-1" role="dialog" aria-labelledby="memberModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="memberModalLabel">An error has occured!!</h4>
                </div>
                <div class="modal-body">
                    <p class="errorMessageParagraph">You are have already logged in as : ${session.user}<p>
                    <p class="errorHyperlinkParagraph"><g:link controller="users" action="index">REDIRECT ME TO THE MAIN SITE</g:link></p>
                </div>
            </div>
        </div>
    </div>
</g:if>
<g:else>
    <div class="container">
        <div class="col-md-6 col-md-offset-3">
            <div class="jumbotron" id="login_jumbotron">
                <g:if test="${flash.message}">
                    <g:if test="${flash.message != 'Login Successful'}">
                        <g:if test="${counter != "true"}">
                            <div class="alert alert-danger fade in">
                                <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                                ${flash.message}
                            </div>
                        </g:if>
                    </g:if>
                </g:if>
                <g:set var="counter" value="${false}"/>
                <div class="text-center">
                    <g:img uri="../images/logo.png"/>
                    <h3>Login to your Account</h3>
                </div><br>
                <g:form controller="users" action="login" method="post" onsubmit="return loginValidation('userName','password');">
                    <div class="form-group">
                        <div class="input-group">
                            <span class="input-group-addon transparent"><span class="glyphicon glyphicon-user"></span></span>
                            <input type="text" class="form-control" placeholder="Enter Username" autocomplete="off" id="userName" name="userName" onkeyup="loginUsernameValidation('userName');"/>
                        </div>
                        <div class="error-messages" id="userName_errors"></div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <span class="input-group-addon transparent"><span class="glyphicon glyphicon-lock"></span></span>
                            <input type="password" class="form-control" placeholder="Enter Password" autocomplete="off" id="password" name="password" onkeyup="loginPasswordValidation('password');"/>
                        </div>
                        <div class="error-messages" id="password_errors"></div>
                    </div><br>
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="text-center">
                                <button type="submit" class="btn btn-lg btn-primary" value="login">Login to Site</button>
                            </div>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>
    </div>
</g:else>
</body>

</html>