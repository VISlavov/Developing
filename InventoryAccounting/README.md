Requirements:

	- Internet connection

	- JDK 1.8+

	- Gradle 2.7+

	- MySQL server

	- Tomcat 8 # optional - if you want to deploy a war file
	
Example:

	systemctl start mysql # start your MySQL database server

	mysql -u root -p < database_setup.sql # setup the database structure demanded for the app

	gradle build

	gradle jasmineRun # optional - runs jasmine tests

	To run directly:
		java -jar build/libs/InventoryAccounting.jar

	To deploy to Tomcat:
		sudo cp /build/libs/InventoryAccounting.war /var/libs/webapps # copy war file to your webapps dir

		systemctl start tomcat8 # start your tomcat web server

	firefox http://localhost:8080/InventoryAccounting/
