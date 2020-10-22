package mainproject

import grails.transaction.Transactional
import groovy.sql.Sql

@Transactional
class UsersService {

    def dataSource

    def searchLoginInput(String input_user, String input_pass) {
        def sql = new Sql(dataSource)
        String message = "";        // message to be returned to the controller
        Boolean found = false;      // flag to check if given username/password combination was found at table
        sql.eachRow("SELECT * FROM users") { row ->
            if (row.userName == input_user && row.password == input_pass) found = true  // linear search in users table to find if given username/password combination exists
        }
        sql.close()
        if (!found)    message = "Username or Password are Incorrect. Please Try Again!!!"
        else         message = "Login Successful"
        return message
    }


}