package mainproject

import grails.transaction.Transactional
import groovy.sql.Sql

@Transactional
class EmployeeService {

    def dataSource

    def printTable(){
        def sql = new Sql(dataSource)
        def list = []               // define an empty list that will hold all the table data
        sql.eachRow("SELECT * FROM employee") { row ->
            def tableMap = [:]      // each list row will be a map
            tableMap.'id' = row.id  // add the mysql row data to the map...
            tableMap.'first_name' = row.first_name
            tableMap.'last_name' = row.last_name
            tableMap.'email' = row.email
            tableMap.'born' = row.born
            tableMap.'country' = row.country
            tableMap.'department_id' = row.department_name
            list << tableMap         // add the specific map as a list row
        }
        return list                  // return the list to the Controller
    }

    def getDepartments(){
        def sql = new Sql(dataSource)
        def list = []
        sql.eachRow("SELECT name FROM department") { row ->
            def tableMap = [:]
            tableMap.'department_id' = row.name
            list << tableMap
        }
        return list
    }

    def getCountries(){
        def country_list = ["Afghanistan","Albania","Algeria","Andorra","Angola","Antigua and Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan",
                            "Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Brazil","Brunei","Bulgaria","Burkina Faso","Burmna","Burundi",
                            "Cambodia","Cameroon","Canada","Capo Verde","Central African Republic","Chad","Chile","China","Colombia","Comoros","Congo","Costa Rica","Cote d'Ivoire","Croatia","Cuba","Curacao","Cyprus","Czech Republic",
                            "Denmark","Djibouti","Dominica","Dominican Republic",
                            "East Timor","Ecuador","Egypt","El Salvador","England","Equatorial Guinea","Eritrea","Estonia","Ethiopia",
                            "Fiji","Finland","France",
                            "Gabon","Gambia","Georgia","Germany","Ghana","Greece","Grenada","Guatemala","Guinea","Guyana",
                            "Haiti","Holy See","Honduras","Hong Kong","Hungary",
                            "Iceland","India","Indonesia","Iran","Iraq","Ireland","Iceland","Israel","Italy",
                            "Jamaican","Japan","Jordan",
                            "Kazakhstan","Kenya","Kiribati","Kosovo","Kuwait","Kyrgyzstan",
                            "Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithouania","Luxembourg",
                            "Macau","Macedonia","Madagascar","Malawi","Malaysia","Malvides","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mexico","Micronesia","Moldova","Monaco","Mongolia","Montenegro","Morocco","Mozambique",
                            "Namibia","Nauru","Nepal","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","North Korea","Norway",
                            "Oman",
                            "Pakistan","Palau","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal",
                            "Qatar",
                            "Romania","Russia","Rwanda",
                            "Saint Kitts and Nevis","Saint Lucia","Saint Vincent and the Grenadines","Samoa","San Marino","Sao Tome and Principe","Saudi Arabia","Scotland","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Sint Maarten","Slovakia","Slovenia","Solomono Islands","Somalia","South Africa","South Korea","Spain","Sri Lanka","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria",
                            "Taiwan","Tajikistan","Tanzania","Timor-Leste","Togo","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Tuvalu",
                            "Uganda","Ukraine","United Arab Emirates","United States","Uruguay","Uzbekistan",
                            "Vanuatu","Venezuela","Vietnam",
                            "Yemen",
                            "Zambia","Zimbabwe"]
        return country_list
    }

    def insertRow(String input_first_name, String input_last_name, String input_email, String input_born, String input_country, String input_department_name){
        def sql = new Sql(dataSource)
        def params = [input_first_name, input_last_name, input_email, input_born, input_country, input_department_name]
        sql.execute 'INSERT INTO employee(first_name,last_name,email,born,country,department_name) VALUES (?, ?, ?, ?, ?, ?)', params
        sql.execute('UPDATE department SET employees_count = (SELECT COUNT(*) FROM employee WHERE department.name = employee.department_name);')
        sql.close()
    }

    def updateRow(String input_first_name, String input_last_name, String input_email, String input_born, String input_country, String input_department_name, String input_id){
        def sql = new Sql(dataSource)
        def params = [input_first_name, input_last_name, input_email, input_born, input_country, input_department_name, input_id] // every execute query works with Prepared Statements to avoid SQL Injections
        sql.execute 'UPDATE employee SET first_name=?, last_name=?, email=?, born=?, country=?, department_name=? WHERE id=?', params
        sql.execute('UPDATE department SET employees_count = (SELECT COUNT(*) FROM employee WHERE department.name = employee.department_name);') // Update the Employees Count Column at department table
        sql.close()
    }

    def deleteRow(String input_id){
        def sql = new Sql(dataSource)
        def params = [input_id]
        sql.execute 'DELETE FROM employee WHERE id = ?', params
        sql.execute('UPDATE department SET employees_count = (SELECT COUNT(*) FROM employee WHERE department.name = employee.department_name);')
        sql.close()
    }
}