
# Building a CRUD Management System #





## 1. What is this repository for? ##

* This is the final verison of an Employee-Department Create-Read-Update-Delete (CRUD), developed using the Groovy Language.
* The application is dedicated in Creating/Updating/Reading/Deleting entries of both departments and employees. 
* The applicatio was developed on Grails, using InteliJ as IDE, Groovy as programming language and a MySQL as RDBMS.
* This is the final version ofor the Employee-Department CRUD Panels and User Login/Logout features.
* Project Version : `3.0`
* IDE Version : `InteliJ IDEA 2017.1.1`
* Grails Version : `2.5.6`
* JDK Version : `1.7.0_11`
* SQL Version : `MySQL RDBMS`
* ConnectorJ Version : `mysql-connector-java-5.1.43`
* CSS Version : `Twitter Bootstrap 3.3.7`

## 2. How is the project structured? ##

* Upon launching the `Project Application`, we are re-directed to the `Login Page` of the site. 

* We do not have permissions to access anything on the site unless we login.

* Since this is a Company Management Site, the `Login Page` **DOES NOT OFFER** a `Register` option.

	> Why? If any random person could quickly create an account, he would have instant access to our database!!!

* For the `Login Confirmation`, no external plugin was used.

	> A linear search is executed in the `database` and a message is returned upon success or failure.
        
* When we finally login to the site, we are redirected to the `Home Page`, where a welcome message is shown, notifying the user about the contents of the site. 

* To access the `Employee` and `Department` Tables, the `Navigation Bar` on top of the site must be used.





## 3. A few things about managing the site... ##

* For the `Employee` Table, you can :
	- Add a new `employee`
    - Update an existing `employee`
    - Delete an existing `employee`
    - Sort the Table with `Ascending` or `Descending` Order

* For the `Department` Table, you can :
	- Add a new `department`
    - Update an existing `department`
    - Delete an existing `department`
    - Sort the Table with `Ascending` or `Descending` Order

* Both Tables are sortable thanks to the `Tablesorter Plugin ` by Christian Bach.

	> Plugin's Documentation : http://tablesorter.com/docs/

	> Plugin's Project Path : `web-app/js/Tablesorter`

* To make Table Management easier, a `Scrollbar` has been added to both tables.

	> Why? To make our lives easier when we have a large amount of data to manage!!!

* Every `input` field in the site has `autocomplete = OFF` to avoid input data being completed by its own.

	> Why? If `autocomplete = ON` for the login form, it would be very easy for anyone to login, knowing just the first letter a random `username`, since the `password` would be autocompleted!!!

    



## 4. How to setup a Connection between MySQL and the Project? ##

* An `Apache Web Server Distribution` is required to set up a `localhost` server.

	> For the purposes of this project, a `XAMPP` Web Development Environment was used.

	> Alternatively, you may use `WampServer` as a Web Development Environment.

* Alternatively, you can use any `MySQL RDBMS` available. 

* After you finish setting up the server, the quickest method to create a connection is using IDEA's `Database Tool Window`.

	> HOW TO : https://www.jetbrains.com/help/idea/database-tool-window.html 

* Alternatively, you can use any `MySQL RDBMS` available. 

* Inside the project's main folder, there is a .sql script named `database.sql`, needed to create the `database` and populate them with some default data. 

	> For the population of the `Users` Table, executing the script is **absolutelly necessary** (otherwise, how will we ever log in???).

	> For the population of the `Department` and `Employee` Tables, executing the script is **completely optional** and exists only as a quick demo.

* At the `development` enviroment, the `database` used is `devdb`.

* At the `testing` enviroment, the `database` used is `testdb`.

* At the `production` enviroment, the `database` used is `proddb`.





## 5. How are the Tables structured? ##

### `Users` ###

* Table details : 
	
	> `username` : unique, 3 characters at least

	> `password` : 3 characters at least

### `Department` ###

* Table details : 

	> `id` : primary key for this table
	
	> `name` : unique, 3 characters at least

	> `street` : default value `NULL`

	> `number of employees` : get the number of employees that work for that current department using `MySQL COUNT()` function

### `Employee` ###

* Table details : 
	
	> `id` : primary key for this table
	
	> `first name` :  3 characters at least

	> `last name` : 3 characters at least

	> `email` : unique

	> `birth year` : Year employee was born, 4 characters only

	> `country` : Country where he was born

	> `department name` : name of `department` where he works





## 6. How are the Tables connected and validated? ##

* The `Employee` Table holds a `foreign key`, connecting the `department name` inside Employees Table with `name` inside `Departments` Table.

	> Upon Adding, Updating, or Deleting an `employee`, the `number of employees` column value in `Department` Table gets updated accordingly.

	> Upon Deleting a `department`, the `department name` column value in `Employee` Table gets a `NULL` value (`employee` is just unemployed now, no reason to delete him).


* The `Employee` Table holds a `unique index`, connecting the `first name`, `last name` and  the `email` for the current `employee`.

    > The `unique index` checks at every `INSERT` query if there is a new `employee` with the **SAME EXACT** combination of `first name`, `last name` and  `email`.

    > If yes, then do not add this current `employee`, because it is absolutely certain that, since this current `employee` has the same `first name`, `last name` and `email` with some other `employee` on our Table, then he will definetely be the same `employee`!!!

	> We do not need to check all the other columns, like `year of birth` or `country`, because a `first name` - `last name` combination may appear more than once for some `employees` , but every `employee` has a **UNIQUE** email.


* The `Department` Table holds a `unique index`, connecting the `name` and  `street` for the current `department`.

 	> If we attempt to `INSERT` a new `department` with same `name` and `street` with some other existing `department`, then is it certain that this new `department` is the
 	same with the existing one and must not be inserted to the Table.


* The `Employee` Table has a `trigger`, checking if, for each `employee`, his `first name` and `last name` are at least 3 characters long and his `birth year` is 4 characters long.

	> If not, throw `ERROR` and don't `INSERT`.

	> Else, `INSERT` row to Table.


* The `Department` Table has a `trigger`, checking if, for each `department`, the `name` and `street` are at least 3 characters long.

	> If not, throw `ERROR` and don't `INSERT`.

	> Else, `INSERT` row to Table.


* The `Users` Table has a `trigger`, checking if, for each `user`, his `username` and `password` are at least 3 characters long.

	> If not, throw `ERROR` and don't `INSERT`.

	> Else, `INSERT` row to Table.

## 7. The outcome ##

![enter image description here](https://i.ibb.co/7vRnmfT/new1.png)

Image 1: The login page

![enter image description here](https://i.ibb.co/j3qLCz5/new2.png)

Image 2: Validation in the login page

![enter image description here](https://i.ibb.co/18jXmg5/new3.png)

Image 3: Validation in the login page

![enter image description here](https://i.ibb.co/nfzhg6z/new4.png)

Image 4: Validation in the login page

![enter image description here](https://i.ibb.co/y6qPgvz/new5.png)

Image 5: The Home page

![enter image description here](https://i.ibb.co/M54MQ5G/new6.png)

Image 6: Managing the employees

![enter image description here](https://i.ibb.co/bmJGNJw/new9.png)

Image 7: Updating the employees

![enter image description here](https://i.ibb.co/BV0vj8y/Picture7.png)

Image 8: The`employees` table

![enter image description here](https://i.ibb.co/WvncPYK/Picture10.png)

Image 9: Inserting an employee and instant validation

![enter image description here](https://i.ibb.co/4wyQf2z/Picture14.png)

Image 10:  Adding a department and instant validation

![enter image description here](https://i.ibb.co/G2GCyQg/Picture15.png)

Image 11: Updating a department

![enter image description here](https://i.ibb.co/YdCx8wg/Picture17.png)

Image 12: Error Handling
