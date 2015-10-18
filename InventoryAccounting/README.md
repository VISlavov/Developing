Requirements:

	- Internet connection

	- JDK 1.8+

	- Gradle 2.7+

	- MySQL server

	- Tomcat 8 # optional - if you want to deploy a war file
	
Example:

	sudo systemctl start mysqld # start your MySQL database server

	mysql -u root -p < database_setup.sql # setup the database structure demanded for the app

	gradle build

	gradle jasmineRun # optional - runs jasmine tests

	To deploy to Tomcat:
		sudo cp build/libs/InventoryAccounting.war /var/lib/tomcat8/webapps # copy war file to your webapps dir

		sudo systemctl start tomcat8 # start your tomcat web server

	firefox http://localhost:8080/InventoryAccounting/ &

Notes:

	If you already have a database or user named like the ones in /src/main/resources/application.properties
	you should consider that they will be deleted when you setup the database from this application.
