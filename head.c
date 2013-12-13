#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>

//--------------------------------------------
// NAME: Victor Slavov
// CLASS: 11 b
// NUMBER: 7
// PROBLEM: #1
// FILE NAME: head.c
// FILE PURPOSE:
//  In general this is a program that imitates the behaviour of the unix command "head".
//  As i know you are dangerously illiterate, here is a place where you can read more about the command:
//  http://www.computerhope.com/unix/uhead.htm
//---------------------------------------------


//--------------------------------------------
// FUNCTION: opener
//  Opens the desired file, set as an argument on the command line.
// PARAMETERS:
//  char* file_name - The name of the file which is about to be opened.
//----------------------------------------------
int opener(char* file_name);

//--------------------------------------------
// FUNCTION: read_and_output
//  Reads the first 10 lines of a desired file or all of the file's lines if the file is shorter, 
//  and prints them in the standart output.
// PARAMETERS:
// int file - Handle which is associated with the file, which is to be opened.
//----------------------------------------------
int read_and_output(int file);

//--------------------------------------------
// FUNCTION: std_input
//  Reads the first 10 lines of the standart input, 
//  and prints them in the standart output.
// PARAMETERS:
// 
//----------------------------------------------
int std_input();

//--------------------------------------------
// FUNCTION: divider
//  Prints the names of the files before the actual
//  printing of their lines (e.g. ==> haha.txt <==)
//  if there are more than 1 arguments.
// PARAMETERS:
//  int argc - Count of command line arguments
//	char* argv[] - Command line arguments
//----------------------------------------------
int divider(int arg_count, char* current_arg);

//--------------------------------------------
// FUNCTION: prewritten_write
//  Has the same functionality as the function "write"
//  with addition - repeating until the data is really written
//  in the desired file.
// PARAMETERS:
//  int file - Place of the the file in the Kernel table;
//	char* buff - Buffer where the data, which will be written is contained
//  int size - Bytes of data which will be written in the file
//----------------------------------------------
int prewritten_write(int file, char* buff, int size);


int main(int argc, char* argv[])
{
	int i = 1;
	int file = 0;
	if(argc == 1)
	{
		std_input();
	}
	else
	{
		while(argc > i) 
		{
			if(argc >= 3)
			{
				if((divider(argc, argv[i])) < 0)
				{
					return -1;
				}
			}
			if ((argv[i])[0] == 45 && strlen(argv[i]) == 1)  // Checking if the argument is a "-"
			{
				std_input();
			}
			else
			{
				if ((file = opener(argv[i])) >= 0)
				{
					read_and_output(file);
				}
			}
			i = i + 1;
		}
	}
	
	return 0;
}

int opener(char* file_name)
{
	int file = open(file_name, O_RDONLY);
	if(file < 0)                         // Error checking
	{
		//Output error message
		fprintf(stderr, "head: cannot open '%s' for reading:  %s \n\n", file_name, strerror(errno));
		return -1;
	}
	else
	{
		return file;
	}
}

int read_and_output(int file)
{
	int line_counter = 0;
	char c;
	int read_result;
	char new_line;
	new_line = 10;
	while (1)
	{
		read_result = read(file, &c, 1);
		if (read_result == 0)
		{
			break;
		}
		else
		{
			if (read_result < 0)  // Error checking  +  reading
			{
				perror("read: ");
				return -1;
			}
			else
			{
				if (prewritten_write(STDOUT_FILENO, &c, 1) < 0)
				{
					return -1;
				}
				if (c == 10)
				{
					line_counter = line_counter + 1;
					if (line_counter == 10)
					{
						break;
					}
				}
			}
		}
	}
	
	if (prewritten_write(STDOUT_FILENO, &new_line, 1) < 0)
	{
		return -1;
	}
	if(close(file) < 0)    // Error checking + closing
	{
		perror("close: ");
		return -1;
	}
	
	return 0;
}

int std_input()
{
	char c;
	int line_counter = 0;
	int read_result = 0;
	char new_line;
	new_line = 10;
	while((read_result = read(STDIN_FILENO, &c, 1)) != 0)
	{
		if (read_result < 0)     // Error checking  +  reading
		{
			perror("read: ");
			return -1;
		}
		else
		{
			if (prewritten_write(STDOUT_FILENO, &c, 1) < 0)
			{
				return -1;
			}
			if(c == 10)
			{
				line_counter = line_counter + 1;
			}
			if (line_counter == 10)
			{
				if (prewritten_write(STDOUT_FILENO, &new_line, 1) < 0)
				{
					return -1;
				}
				break;
			}
		}
	}
	
	
	return 0;
}

int divider(int arg_count, char* current_arg)
{
	char* cat_header = (char*)calloc(4, 1);
	cat_header[0] = '=';
	cat_header[1] = '=';
	cat_header[2] = '>';
	cat_header[3] = ' ';
	char* cat_tail = (char*)calloc(4, 1); 
	cat_tail[0] = ' ';
	cat_tail[1] = '<';
	cat_tail[2] = '=';
	cat_tail[3] = '=';
	cat_tail[4] = '\n';
	
	if (arg_count > 2)
	{
		if(current_arg[0] == 45 && strlen(current_arg) == 1) // Checking if the argument is a "-"
		{
			current_arg = "standart input";
		}
		if (prewritten_write(STDOUT_FILENO, cat_header, 4) < 0)
		{
			return -1;
		}
		if (prewritten_write(STDOUT_FILENO, current_arg, strlen(current_arg)) < 0)
		{
			return -1;
		}
		if (prewritten_write(STDOUT_FILENO, cat_tail, 5) < 0)
		{
			return -1;
		}
	}
	
	free(cat_tail);
	free(cat_header);
	
	return 0;
}

int prewritten_write(int file, char* buff, int size)
{
	int write_result = 0;
	char* remaining_buff = (char*)calloc(size, sizeof(char));
	int i = 0;
	
	if ((write_result = write(file, buff, size)) < 0)  // Error checking  +  writing
	{
		perror("write: ");
		return -1;
	}
	else
	{
		while(write_result != size)
		{
			while(write_result < size)
			{
				remaining_buff[i] = buff[write_result];
				write_result = write_result + 1;
				i = i + 1;
			}
			
			size = i;
			i = 0;
			
			if ((write_result = write(file, remaining_buff, size)) < 0)   // Error checking  +  writing
			{
				perror("write: ");
				return -1;
			}
			
			remaining_buff = (char*)realloc(remaining_buff, 0);
		}
	}
	
	free(remaining_buff);

	return 0;
}
















