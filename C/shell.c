#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>

//--------------------------------------------
// NAME: Victor Slavov
// CLASS: 11 b
// NUMBER: 7
// PROBLEM: #2
// FILE NAME: shell.c
// FILE PURPOSE:
//  In general this is a program that imitates the behaviour of simple command shell.
//  As i know your level of knowledge is unimaginably poor,
// 	here is where you can read about it:
//  http://technet.microsoft.com/en-us/library/cc737438%28v=ws.10%29.aspx
//---------------------------------------------

//--------------------------------------------
// FUNCTION: cmdline_parser
//  Takes input from the user and splits it into separate strings, forming an array.
// PARAMETERS:
//
//----------------------------------------------
char** cmdline_parser();


int custom_argc = -1;


int main()
{
	pid_t child_id, pid;
	int status = 0, i = 0;
	
	while(1)
	{
		char** parsed = cmdline_parser();
		
		if((strlen(parsed[0]) != 0)) 
			if ((child_id = fork()) == -1)
				perror("fork error");
			else if (child_id == 0) 
			{
				execv(parsed[0], parsed);
				fprintf(stderr, "'%s' :  %s \n", parsed[0], strerror(errno));
			}
			else
				while(1)	// wait child process to finish
					if ((pid = waitpid(child_id, &status, 1)) == -1)
					{
						perror("waitpid error");
						break;
					}
					else if (pid == 0) 
						sleep(1);
					else if (pid == child_id) 
						break;
		else
		{
			free(parsed[0]);
			return 0;
		}

		while(i <= custom_argc)
			free(parsed[(i = i + 1) - 1]);			
		
		i = 0;
		free(parsed);
	}
	
	return 0;
}

char** cmdline_parser()
{
	char** parts = (char **)calloc(1, sizeof(char *));
	char c;
	int i1 = 0;
	custom_argc = -1;
	parts[custom_argc + 1] = (char *)calloc(1, sizeof(char) * 2);
	
	while((c=getchar()) != 10 && c != EOF && c != -1)
		if(c == 32)
		{
			custom_argc = custom_argc + 1;
			parts = (char **)realloc(parts, sizeof(parts) + sizeof(char *));
			parts[custom_argc + 1] = (char *)calloc(1, sizeof(char) * 2);
			i1 = 0;
		}
		else
		{
			if(i1 > 0)
				parts[custom_argc + 1] = (char *)realloc(parts[custom_argc + 1], sizeof(parts[custom_argc + 1]) + sizeof(char) * 3);
			parts[custom_argc + 1][(i1 = i1 + 1) - 1] = c;
		}
	
	if(c == -1)
		if(kill(0, SIGKILL) < 0)
			perror("kill error");

	return parts;
}
