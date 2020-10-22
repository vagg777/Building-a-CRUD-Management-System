package mainproject

class DepartmentController {

    def DepartmentService

    def index = {
        def returnedList = DepartmentService.printTable()   // get all the data from the department table
        [returnedList:returnedList]                         // pass the list to the GSP
    }

    def addRecord = {
        DepartmentService.insertRow(params.department_name, params.department_street)
        redirect(action: 'index')
    }

    def updateRecord = {
        DepartmentService.updateRow(params.department_name1, params.department_street1, params.id1)
        redirect(action: 'index')
    }

    def deleteRecord = {
        DepartmentService.deleteRow(params.id)
        redirect(action: 'index')
    }
}
