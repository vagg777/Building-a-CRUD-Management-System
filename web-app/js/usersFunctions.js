/**
 *  Airbnb Code Stylings that could not implemented and why
 *
 * 	-	var returnedValue = true; --> let returnedValue = true;
 *	Error : 'let' definitions are not supported by current Javascript version
 *
 *	-	document.getElementById(variable + '_errors') --> document.getElementById(`${variable}_errors?`)
 *	Error : String Templates are not supported by current Javascript version
 */

const loginValidation = function validate(
  username,
  password
){
    const isLoginUsernameValid = loginUsernameValidation(username);
    const isLoginPasswordValid = loginPasswordValidation(password);
    // If true, form submitted, else form still has errors
    if (isLoginUsernameValid && isLoginPasswordValid) return true;
    else return false;
}

const loginUsernameValidation = function validateUsername(username) {
  var returnedValue = true;
  const loginUsername = document.getElementById(username).value;
  if (loginUsername.length <= 2) {
    document.getElementById(username).style.borderColor = '#ff0000';
    document.getElementById(username + '_errors').style.color = '#ff0000';
    document.getElementById(username + '_errors').innerHTML = 'Username is way too small!!!';
    if (loginUsername === '')  document.getElementById(username + '_errors').innerHTML = 'Please enter a Username!!!';
    returnedValue = false;
    } else {
      document.getElementById(username).style.borderColor  = '#008000';
      document.getElementById(username + '_errors').style.color  = '#008000';
      document.getElementById(username + '_errors').innerHTML = 'Username is: VALID';
    }

  return returnedValue;
}

const loginPasswordValidation = function validatePassword(password) {
  var returnedValue = true;
  var loginPassword = document.getElementById(password).value;
  if (loginPassword.length <= 2) {
    document.getElementById(password).style.borderColor = '#ff0000';
    document.getElementById(password + '_errors').style.color = '#ff0000';
    document.getElementById(password + '_errors').innerHTML = 'Password is way too small!!!';
    if (loginPassword === '')  document.getElementById(password + '_errors').innerHTML = 'Please enter a Password!!!';
    returnedValue = false;
    } else {
      document.getElementById(password).style.borderColor = '#008000';
      document.getElementById(password + '_errors').style.color = '#008000';
      document.getElementById(password + '_errors').innerHTML = 'Password is: VALID';
    }

  return returnedValue;
}