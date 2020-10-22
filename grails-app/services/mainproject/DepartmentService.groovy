package mainproject

import grails.transaction.Transactional
import groovy.sql.Sql

@Transactional
class DepartmentService {

    def dataSource

    def printTable(){
        def sql = new Sql(dataSource)
        def list = []                   // define an empty list that will hold all the table data
        sql.eachRow("SELECT * FROM department") { row ->
            def tableMap = [:]          // each list row will be a map
            tableMap.'id' = row.id      // add the mysql row data to the map...
            tableMap.'name' = row.name
            tableMap.'street' = row.street
            tableMap.'employees_count' = row.employees_count
            list << tableMap            // add the specific map as a list row
        }
        return list                     // return the list to the Controller
    }

    def insertRow(String input_department_name, String input_street){
        def sql = new Sql(dataSource)
        def params = [input_department_name, input_street]  // every execute query works with Prepared Statements to avoid SQL Injections
        sql.execute 'INSERT INTO department(name, street) VALUES (?, ?)', params
        sql.execute 'UPDATE department SET employees_count = (SELECT COUNT(*) FROM employee WHERE department.name = employee.department_name)' // Update the Employees Count Column at department table
        sql.close()
    }

    def updateRow(String input_department_name, String input_street, String input_id){
        def sql = new Sql(dataSource)
        def params = [input_department_name, input_street, input_id]
        sql.execute 'UPDATE department SET name=?, street=? WHERE id=?', params
        sql.execute 'UPDATE department SET employees_count = (SELECT COUNT(*) FROM employee WHERE department.name = employee.department_name)'
        sql.close()
    }

    def deleteRow(String input_id){
        def sql = new Sql(dataSource)
        def params = [input_id]
        sql.execute 'DELETE FROM department WHERE id = ?', params
        sql.execute 'UPDATE department SET employees_count = (SELECT COUNT(*) FROM employee WHERE department.name = employee.department_name)'
        sql.close()
    }
}
