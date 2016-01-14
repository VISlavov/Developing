This script solves the first three task from a database exam. You can generate yourself an exam from the script here:
	https://github.com/thebravoman/elsys-db-practices

You must delete all data in the task file above the first excercise before you run the script.

Requirements:

	- ruby version 2.1.0

	- DerbyDB version 10.11.1.1
	
Template:

	cd source
	
	ruby first3.rb [path to the task file] [database name] [parsing method] [solution file name] [path to derby binary files folder] [path to folder which will contain the final files]

Example:


	ruby first3.rb ../your_name/task exam31 2 solution ../../db-derby-10.11.1.1-bin/bin/ ../your_name/
