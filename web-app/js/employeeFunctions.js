/**
 *  Airbnb Code Stylings that could not implemented and why
 *
 * 	-	var returnedValue = true; --> let returnedValue = true;
 *	Error : 'let' definitions are not supported by current Javascript version
 *
 *	-	document.getElementById(variable + '_errors') --> document.getElementById(`${variable}_errors?`)
 *	Error : String Templates are not supported by current Javascript version
 */

// If Update button pressed, get table data for current row and display it in Update Form
const getTableData = function fetchData(element)
{
  const $employeeId = $(element).closest('tr').find('.table_id').text();
  const $employeeFirstname = $(element).closest('tr').find('.table_firstName').text();
  const $employeeLastname = $(element).closest('tr').find('.table_lastName').text();
  const $employeeBirthYear = $(element).closest('tr').find('.table_born').text();
  const $employeeEmail = $(element).closest('tr').find('.table_email').text();
  const $employeeCountry = $(element).closest('tr').find('.table_country').text();
  const $employeeDepartmentId = $(element).closest('tr').find('.table_departmentId').text();
  $('.modal-body #id1').val($employeeId);
  $('.modal-body #first_name1').val($employeeFirstname);
  $('.modal-body #last_name1').val($employeeLastname);
  $('.modal-body #born1').val($employeeBirthYear);
  $('.modal-body #email1').val($employeeEmail);
  $('.modal-body #country1').val($employeeCountry);
  $('.modal-body #department_id1').val($employeeDepartmentId);
}

const employeeValidation = function validate(
  firstName,
  lastName,
  email,
  born,
  country,
  departmentId
) {
    const isEmployeeFirstnameValid = employeeFirstnameValidation(firstName);
    const isEmployeeLastnameValid = employeeLastnameValidation(lastName);
    const isEmployeeEmailValid = employeeEmailValidation(email);
    const isEmployeeBirthYearValid = employeeBornValidation(born);
    const isEmployeeCountryValid = employeeCountryValidation(country);
    const isEmployeeDepartmentIdValid = employeeDepartmentIdValidation(departmentId);
    // If true, form submitted, else form still has errors
    if (isEmployeeFirstnameValid && isEmployeeLastnameValid && isEmployeeEmailValid && isEmployeeBirthYearValid && isEmployeeCountryValid && isEmployeeDepartmentIdValid) return true;
    else return false;
}

const employeeFirstnameValidation = function validateFirstname(firstName) {
  var returnedValue = true;
  const empFirstname = document.getElementById(firstName).value;
  if (empFirstname.length <=2) {
    document.getElementById(firstName).style.borderColor = '#ff0000';
    document.getElementById(firstName + '_errors').style.color = '#ff0000';
    document.getElementById(firstName +'_errors').innerHTML = 'First Name is way too short!!!';
    if (empFirstname === '') document.getElementById(firstName + '_errors').innerHTML = 'Please enter a First Name!!!';
    returnedValue = false;
  } else {
    document.getElementById(firstName).style.borderColor = '#008000';
    document.getElementById(firstName + '_errors').style.color = '#008000';
    document.getElementById(firstName + '_errors').innerHTML = 'First Name is: VALID';
  }
  if (document.getElementById(firstName).value.match( /(1|2|3|4|5|6|7|8|9|0)/ ) ) {
    document.getElementById(firstName).style.borderColor = '#ff0000';
    document.getElementById(firstName + '_errors').style.color = '#ff0000';
    document.getElementById(firstName + '_errors').innerHTML = 'First Name must NOT contain numbers!!!';
    returnedValue = false;
  }

  return returnedValue;
}

const employeeLastnameValidation = function validateLastname(lastName) {
  var returnedValue = true;
  const empLastname = document.getElementById(lastName).value;
  if (empLastname.length <=2) {
    document.getElementById(lastName).style.borderColor = '#ff0000';
    document.getElementById(lastName + '_errors').style.color = '#ff0000';
    document.getElementById(lastName + '_errors').innerHTML = 'Last Name is way too short!!!';
    if (empLastname === '') document.getElementById(lastName + '_errors').innerHTML = 'Please enter a Last Name!!!';
    returnedValue = false;
  } else {
    document.getElementById(lastName).style.borderColor = '#008000';
    document.getElementById(lastName + '_errors').style.color = '#008000';
    document.getElementById(lastName + '_errors').innerHTML = 'Last Name is: VALID';
  }
  if (document.getElementById(lastName).value.match( /(1|2|3|4|5|6|7|8|9|0)/ ) ) {
    document.getElementById(lastName).style.borderColor = '#ff0000';
    document.getElementById(lastName + '_errors').style.color = '#ff0000';
    document.getElementById(lastName + '_errors').innerHTML = 'Last Name must NOT contain numbers!!!';
    returnedValue = false;
  }

  return returnedValue;
}

const employeeEmailValidation = function validateEmail(email) {
  var returnedValue = true;
  const empEmail = document.getElementById(email).value;
  const atpos = empEmail.indexOf("@");
  const dotpos = empEmail.lastIndexOf(".");
  if (atpos<1 || dotpos<atpos+2 || dotpos+2>=empEmail.length) {
    document.getElementById(email).style.borderColor = '#ff0000';
    document.getElementById(email + '_errors').style.color = '#ff0000';
    document.getElementById(email + '_errors').innerHTML = 'Email Address is not valid!!!';
    returnedValue = false;
  } else {
    document.getElementById(email).style.borderColor = '#008000';
    document.getElementById(email + '_errors').style.color = '#008000';
    document.getElementById(email + '_errors').innerHTML = 'Email Address is: VALID';
  }
  if (empEmail === ''){
    document.getElementById(email).style.borderColor = '#ff0000';
    document.getElementById(email + '_errors').innerHTML = 'Please enter an email address!!!';
    returnedValue = false;
  }

  return returnedValue;
}

const employeeBornValidation = function validateBirthYear(born) {
  var returnedValue = true;
  const empBorn = document.getElementById(born).value;
  if (empBorn.length !==4) {
    document.getElementById(born).style.borderColor = '#ff0000';
    document.getElementById(born + '_errors').style.color = '#ff0000';
    document.getElementById(born + '_errors').innerHTML = 'Birth Year is always a 4-digit number!!!';
    if (empBorn === '') document.getElementById(born + '_errors').innerHTML = 'Please enter a Birth Year!!!';
    if (isNaN(empBorn)) {
      if (empBorn !== '') document.getElementById(born + '_errors').innerHTML = 'Birth Year must ONLY contain digits!!!';
    }
    returnedValue = false;
  } else {
    if (isNaN(empBorn)) {
      if (empBorn !== ''){
        document.getElementById(born).style.borderColor = '#ff0000';
        document.getElementById(born + 'born_errors').innerHTML = 'Birth Year must ONLY contain digits!!!';
        returnedValue = false;
      }
    } else {
      document.getElementById(born).style.borderColor = '#008000';
      document.getElementById(born + '_errors').style.color = '#008000';
      document.getElementById(born + '_errors').innerHTML = 'Birth Year is: VALID';
    }
  }

  return returnedValue;
}

const employeeCountryValidation = function validateCountry(country) {
  var returnedValue = true;
  const empCountry = document.getElementById(country).value;
  if (empCountry === ''){
    document.getElementById(country).style.borderColor = '#ff0000';
    document.getElementById(country + '_errors').style.color = '#ff0000';
    document.getElementById(country + '_errors').innerHTML = 'Please select a Country!!!';
    returnedValue = false;
  } else {
    document.getElementById(country).style.borderColor = '#008000';
    document.getElementById(country + '_errors').style.color = '#008000';
    document.getElementById(country + '_errors').innerHTML = 'Country is: VALID';
  }

  return returnedValue;
}

const employeeDepartmentIdValidation = function validateDepartmentId(departmentId) {
  var returnedValue = true;
  const empDepartId = document.getElementById(departmentId).value;
  if (empDepartId === '') {
    document.getElementById(departmentId).style.borderColor = '#ff0000';
    document.getElementById(departmentId + '_errors').style.color = '#ff0000';
    document.getElementById(departmentId + '_errors').innerHTML = 'Please select a Department!!!';
    returnedValue = false;
  } else {
    document.getElementById(departmentId).style.borderColor = '#008000';
    document.getElementById(departmentId + '_errors').style.color = '#008000';
    document.getElementById(departmentId + '_errors').innerHTML = 'Department Name is: VALID';
  }

  return returnedValue;
}

const resetEmployeeForm = function reset(
  firstName,
  lastName,
  email,
  born,
  country,
  departmentId
) {
    document.getElementById(firstName).style.borderColor = '#cccccc';
    document.getElementById(lastName).style.borderColor = '#cccccc';
    document.getElementById(email).style.borderColor = '#cccccc';
    document.getElementById(born).style.borderColor = '#cccccc';
    document.getElementById(country).style.borderColor = '#cccccc';
    document.getElementById(departmentId).style.borderColor = '#cccccc';
    document.getElementById(firstName + '_errors').style.color = '#555555';
    document.getElementById(lastName + '_errors').style.color = '#555555';
    document.getElementById(email + '_errors').style.color = '#555555';
    document.getElementById(born + '_errors').style.color = '#555555';
    document.getElementById(country + '_errors').style.color = '#555555';
    document.getElementById(departmentId + '_errors').style.color = '#555555';
    document.getElementById(firstName).value = '';
    document.getElementById(lastName).value = '';
    document.getElementById(email).value = '';
    document.getElementById(born).value = '';
    document.getElementById(country).value = '';
    document.getElementById(departmentId).value = '';
    document.getElementById(firstName + '_errors').innerHTML = '';
    document.getElementById(lastName + '_errors').innerHTML = '';
    document.getElementById(email + '_errors').innerHTML = '';
    document.getElementById(born + '_errors').innerHTML = '';
    document.getElementById(country + '_errors').innerHTML = '';
    document.getElementById(departmentId + '_errors').innerHTML = '';
}
