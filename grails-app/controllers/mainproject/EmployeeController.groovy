package mainproject

class EmployeeController {

    def EmployeeService

    def index = {
        def returnedList = EmployeeService.printTable()         // get table data from employees table
        def departmentsList = EmployeeService.getDepartments()  // get a list of the available departments
        def countriesList = EmployeeService.getCountries()      // get a list of all the countries that exists
        [returnedList:returnedList, departmentsList:departmentsList, countriesList:countriesList]   // return those lists to the GSP
    }

    def addRecord = {
        EmployeeService.insertRow(params.first_name, params.last_name, params.email, params.born, params.country, params.department_id)
        redirect(action: 'index')
    }

    def updateRecord = {
        EmployeeService.updateRow(params.first_name1, params.last_name1, params.email1, params.born1, params.country1, params.department_id1, params.id1)
        redirect(action: 'index')
    }

    def deleteRecord = {
        EmployeeService.deleteRow(params.id)
        redirect(action: 'index')
    }

}
