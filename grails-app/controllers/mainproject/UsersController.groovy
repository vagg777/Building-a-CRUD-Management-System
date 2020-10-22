package mainproject

class UsersController {

    def UsersService

    def index = {}      // if requested, load users/index.gsp

    def loginPage = {} // if requested, load users/loginPage.gsp

    def login = {
        flash.message = UsersService.searchLoginInput(params.userName,params.password)  // get the message the service returned and show it at the .gsp page
        if (flash.message == "Login Successful")   {
            session.user = params.userName  // get user that logged in
            redirect(action: 'index')       // since logged-in, redirect to Home Page
        }else{
            redirect(action: 'loginPage')   // if not logged-in, redirect to Login Page
        }
    }

    def logout = {
        session.user = null
        flash.message = null
        redirect(action: 'loginPage')   // if not logged-in, redirect to Login Page
    }


    def permissionsMissingLogin = {
        flash.message = null
        redirect(action: 'loginPage')   // if anyone tries to access the site panels without having logged it, redirect to Login Page
    }
}
