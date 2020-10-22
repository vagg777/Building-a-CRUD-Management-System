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
const getTableData = function fetchData(element) {
  const $departmentId = $(element).closest('tr').find('.table_id').text();
  const $departmentName = $(element).closest('tr').find('.table_departmentName').text();
  const $departmentStreet = $(element).closest('tr').find('.table_street').text();
  $('.modal-body #id1').val($departmentId);
  $('.modal-body #department_name1').val($departmentName);
  $('.modal-body #department_street1').val($departmentStreet);
}

const departmentValidation  = function validate(
  departmentName,
  departmentStreet
) {
    const isDepartmentNameValid = departmentNameValidation(departmentName);
    const isDepartmentStreetValid = departmentStreetValidation(departmentStreet);
    // If true, form submitted, else form still has errors
    if (isDepartmentNameValid && isDepartmentStreetValid) return true;
    else return false;
}

const departmentNameValidation = function validateName(departmentName) {
  var returnedValue = true;
  const depName = document.getElementById(departmentName).value;
  if (depName.length <= 2) {
    document.getElementById(departmentName).style.borderColor = '#ff0000';
    document.getElementById(departmentName + '_errors').style.color = '#ff0000';
    document.getElementById(departmentName + '_errors').innerHTML = 'Department Name is way too short!!!';
    if (depName === '')   document.getElementById(departmentName + '_errors').innerHTML = 'Please enter a Department Name!!!';
    returnedValue = false;
  } else {
      document.getElementById(departmentName).style.borderColor = '#008000';
      document.getElementById(departmentName+ '_errors').style.color = '#008000';
      document.getElementById(departmentName + '_errors').innerHTML = 'Department Name is: VALID';
  }
  if (document.getElementById(departmentName).value.match(/(1|2|3|4|5|6|7|8|9|0)/)) {
      document.getElementById(departmentName).style.borderColor = '#ff0000';
      document.getElementById(departmentName + '_errors').style.color = '#ff0000';
      document.getElementById(departmentName + '_errors').innerHTML = 'Department Name must NOT contain numbers!!!';
      returnedValue = false;
  }

  return returnedValue;
}

const departmentStreetValidation = function validateStreet(departmentStreet) {
  var returnedValue = true;
  const depStreet = document.getElementById(departmentStreet).value;
  if (depStreet.length <= 2) {
    document.getElementById(departmentStreet).style.borderColor = '#ff0000';
    document.getElementById(departmentStreet + '_errors').style.color = '#ff0000';
    document.getElementById(departmentStreet + '_errors').innerHTML = 'Department Street is way too short!!!';
    if (depStreet === '')  document.getElementById(departmentStreet + '_errors').innerHTML = 'Please enter a Department Street!!!';
    returnedValue = false;
  } else {
    document.getElementById(departmentStreet).style.borderColor = '#008000';
    document.getElementById(departmentStreet + '_errors').style.color = '#008000';
    document.getElementById(departmentStreet + '_errors').innerHTML = 'Department Street is: VALID';
  }

  return returnedValue;
}

const resetDepartmentForm = function reset(
    departmentName,
    departmentStreet
) {
  document.getElementById(departmentName).style.borderColor = '#cccccc';
  document.getElementById(departmentStreet).style.borderColor = '#cccccc';
  document.getElementById(departmentName + '_errors').style.color = '#555555';
  document.getElementById(departmentStreet + '_errors').style.color = '#555555';
  document.getElementById(departmentName).value = '';
  document.getElementById(departmentStreet).value = '';
  document.getElementById(departmentName + '_errors').innerHTML = '';
  document.getElementById(departmentStreet + '_errors').innerHTML = '';
}