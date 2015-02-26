#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include <dirent.h> 
#include <sys/types.h>
#include <sys/stat.h>
#include <stdint.h>
#include <grp.h>

//--------------------------------------------
// NAME: Victor Slavov
// CLASS: 11 b
// NUMBER: 7
// PROBLEM: #4
// FILE NAME: ls.c
// FILE PURPOSE:
//  Realising an analog of the 'ls' command in unix
//	based OS like Linux
//---------------------------------------------

struct separated_arguments
{
	char* opts;
	char** objects;
	int length;
};
typedef struct separated_arguments sep_args;

struct directory
{
	char** files;
	char* name;
	int files_length;
};
typedef struct directory directory;

//--------------------------------------------
// FUNCTION: list_dir
//  Lists the files in a directory
// PARAMETERS:
//	path => the path to the directory
//  many_dirs_flag => show that many dirs/files are to be listed
//  a => existance of 'a' arg
//  l => existance of 'l' arg
//  R => existance of 'R' arg
//----------------------------------------------
int list_dir(char* path, int many_dirs_flag, int a, int l, int R);

//--------------------------------------------
// FUNCTION: cycle_args
//  Separate arguments from options
// PARAMETERS:
//	argc => number of arguments
//  argv => arguments
//----------------------------------------------
sep_args cycle_args(int argc, char* argv[]);

//--------------------------------------------
// FUNCTION: remove_substring
//  Remove a substring from a given string
// PARAMETERS:
//	s => target string
//  toremove => substring
//----------------------------------------------
void remove_substring(char* s, const char* toremove);

//--------------------------------------------
// FUNCTION: list_args
//  Lists files and folders from arguments
// PARAMETERS:
//	args => separated arguments
//----------------------------------------------
int list_args(sep_args args);

//--------------------------------------------
// FUNCTION: dir_struct
//  Shows directory structure recursively
// PARAMETERS:
//  stated => file properties
//----------------------------------------------
void dir_struct(struct stat stated);

//--------------------------------------------
// FUNCTION: get_files
//  Get all files from a directory
// PARAMETERS:
//	path => the path to the directory
//----------------------------------------------
directory get_files(char* path);

//--------------------------------------------
// FUNCTION: convert_time
//  Convert Unix Epoch timestamp to needed format
// PARAMETERS:
//	timestamp => unix timestamp
//----------------------------------------------
char* convert_time(__time_t timestamp);

//--------------------------------------------
// FUNCTION: long_print
//  Printing of extra descriptive attributes
// PARAMETERS:
//	s => file stats structure
//  file_name => name of targeted file
//----------------------------------------------
void long_print(struct stat s, char* file_name);

//--------------------------------------------
// FUNCTION: check_type
//  Returns the file type
// PARAMETERS:
//	s => file stats structure
//----------------------------------------------
char check_type(struct stat s);

//--------------------------------------------
// FUNCTION: handle_single_file
// 	Deals with files != directories
// PARAMETERS:
//	s => file stats structure
//  path => path tp the file
//  l => l argument existance
//  a => a argument existance
//----------------------------------------------
int handle_single_file(char* path, struct stat *s, int l, int a);

//--------------------------------------------
// FUNCTION: handle_al_args_print
// 	Handles options 'a' and 'l'
// PARAMETERS:
//	s => file stats structure
//  path => path tp the file
//  l => l argument existance
//  a => a argument existance
//----------------------------------------------
void handle_al_args_print(char* file, struct stat s, int a, int l);

//--------------------------------------------
// FUNCTION: stat_file
// 	Stats a file
// PARAMETERS:
//	s => file stats structure
//  file => path tp the file
//----------------------------------------------
int stat_file(char* file, struct stat *s);

//--------------------------------------------
// FUNCTION: safe_cat
// 	Concatenates two strings, without changing them (providing a 3rd one)
// PARAMETERS:
//	file1 => string 1
//  file2 => string 2
//----------------------------------------------
char* safe_cat(char* file1, char* file2);

//--------------------------------------------
// FUNCTION: stat_all
// 	Stats all files in a directory
// PARAMETERS:
//	path => path to directory
//  dir => structure with directory information
//  s => pointer to an array of stat structures
//----------------------------------------------
void stat_all(char* path, directory dir, struct stat* s);


int main(int argc, char* argv[])
{
	list_args(cycle_args(argc, argv));

	return 0;
}

int list_dir(char* path, int many_dirs_flag, int a, int l, int R)
{
	int i = 0,
		i1 = 0;
	char type;
	directory dir = get_files(path);
	struct stat s,
		s_all[dir.files_length];
	int* dirs = (int *)calloc(1, dir.files_length * sizeof(int) + 1);
	
	if(R || many_dirs_flag)
		printf("%s:\n", path);
	
	if(l)
	{
		long long blocks = 0;
		stat_all(path, dir, s_all);
		
		while (i < dir.files_length)
		{
			if(a)
				blocks = blocks + s_all[i].st_blocks;
			else
				if(dir.files[i][0] != '.')
					blocks = blocks + s_all[i].st_blocks;
			
			i = i + 1;
		}
		
		printf("total %lld\n", blocks / 2);
		i = 0;
	}
	
	while (i < dir.files_length)
	{
		if(R)
		{
			if(!((strlen(dir.files[i]) == 2 && dir.files[i][0] == '.' && dir.files[i][1] == '.') || (strlen(dir.files[i]) == 1 && dir.files[i][0] == '.')))
			{
				
				if(!l)
				{
					stat_file(safe_cat(path, dir.files[i]), &s);
					type = check_type(s);
				}
				else
					type = check_type(s_all[i]);
					
				if(type == 'd')
				{
					if(i == 0)
						i = -1;
						
					dirs[i1] = i;
					i1 = i1 + 1;
					
					if(i == -1)
						i = 0;
				}
			}
		}
		
		handle_al_args_print(dir.files[i], s_all[i], a, l);
		
		i = i + 1;
	}
	
	if(R || !l || many_dirs_flag)
	{
		printf("\n");
		
		if(R)
		{
			printf("\n");
			many_dirs_flag = (dirs[0] != 0);
			i1 = i1 - 1;
			
			if(dirs[0] == -1)
				dirs[0] = 0;
			
			while(i1 >= 0)
			{	
				list_dir(safe_cat(path, dir.files[dirs[i1]]), many_dirs_flag, a, l, R);
				
				i1 = i1 - 1;
			}
		}
	}
	
	i = i - 1;
	while(i >= 0)
	{
		free(dir.files[i]);
		i = i - 1;
	}
	free(dir.files);
	free(dirs);
	
	return 0;
}

sep_args cycle_args(int argc, char* argv[])
{
	int i = 1,
	i1 = 0;
	char** objects = (char **)calloc(1, sizeof(char *));
	char* opts = (char *)calloc(1, sizeof(char));
	
	while(i < argc)
	{
		if(argv[i][0] == '-')
			strcat(opts, argv[i]);
		else
		{
			objects[i1] = (char *)calloc(1, sizeof(char) * strlen(argv[i]) + 1);
			objects = (char **)realloc(objects, sizeof(char *) * (i1 + 2));
			strcpy(objects[i1], argv[i]);
			i1 = i1 + 1;
		}
			
		i = i + 1;
	}
	
	remove_substring(opts, "-");
	
	sep_args args = {
		opts,
		objects,
		i1
	};
	
	return args;
}

int list_args(sep_args args)
{
	int i = 0,
		i1 = 0,
		i2 = 0,
		a = (strstr(args.opts, "a") != NULL),
		l = (strstr(args.opts, "l") != NULL),
		R = (strstr(args.opts, "R") != NULL);
	struct stat s;
	int* files = (int *)calloc(1, sizeof(int) * args.length);
	
	if(args.length == 0)
	{
		args.length = 1;
		args.objects[0] = "./";
	}
	else
	{
		while(i < args.length)
		{
			if(handle_single_file(args.objects[i], &s, l, a))
			{
				files[i1] = i;
				i1 = i1 + 1;
			}
			
			i = i + 1;
		}
		
		if(i1)
		{
			printf("\n");
			
			if(i1 < args.length)
				printf("\n");
		}
		
		
		i = 0;
	}
	
	while(i < args.length)
	{
		while(i2 < i1)
		{
			if(i == files[i2])
			{
				break;
			}
			
			i2 = i2 + 1;
		}
		
		if(i2 == i1)
			i2 = i2 - 1;
		
		if(i != files[i2])
		{
			list_dir(args.objects[i], args.length - 1, a, l, R);
			
			if(i1 < args.length && i1 && i1 != args.length)
				printf("\n");
		}
			
		i2 = 0;
		i = i + 1;
	}
	
	free(args.opts);
	free(args.objects);
	free(files);
	
	return 0;
}

directory get_files(char* path)
{
	int i = 0;
	DIR	*d = opendir(path);
	struct dirent *dir;
	char** files_list = (char **)calloc(1, sizeof(char *));
		
	if(d)
	{
		while ((dir = readdir(d)) != NULL)
		{
			files_list[i] = (char *)calloc(1, strlen(dir->d_name) * sizeof(char) + 1);
			files_list = (char **)realloc(files_list, sizeof(char *) * (i + 2));
			strcpy(files_list[i], dir->d_name);
			i = i + 1;
		}
		closedir(d);
	}
	else
		fprintf(stderr, "ls: cannot access '%s':  %s \n", path, strerror(errno));

	if(path[strlen(path) - 1] != '/')
		strcat(path, "/");

	directory the_dir = {
		files_list,
		path,
		i
	};
	
	return the_dir;
}

int handle_single_file(char* path, struct stat *s, int l, int a)
{
	if(!stat_file(path, s))
	{		
		char type = check_type(*s);

		if(type == '-')
			handle_al_args_print(path, *s, a, l);
		else
			if(type == 'd')
				return 0;
	}
	
	return 1337;
}

void handle_al_args_print(char* file, struct stat s, int a, int l)
{
	if(a)
		if(l)
			long_print(s, file);
		else
			printf("%s ", file);
	else
		if(file[0] != '.')
			if(l)
				long_print(s, file);
			else
				printf("%s ", file);
}

void remove_substring(char* s, const char* toremove)
{
	while(s = strstr(s, toremove))
		memmove(s, s + strlen(toremove), 1 + strlen(s + strlen(toremove)));
}

char* convert_time(__time_t timestamp)
{
	time_t rawtime = timestamp;
	struct tm* timeinfo;
	char* timestr;
	
	timeinfo = localtime(&rawtime);
	timestr = asctime(timeinfo);
	timestr = timestr + 4;
	timestr[strlen(timestr) - 9] = 0;
	
	return timestr;
}

void long_print(struct stat s, char* file_name)
{
	struct group* grp;
	char* accesses[8] = {"---", "--x", "-w-", "-wx", "r--", "r-x", "rw-", "rwx"};
	ushort mode = s.st_mode;
	int i = 0;
	
	printf("%c", check_type(s));
	
	for(i = 6; i >= 0; i -=3)
		printf("%s", accesses[(mode >> i) & 7]);
		
	printf(" %d ", s.st_nlink);
	grp = getgrgid(s.st_uid);
	printf("%s ", grp->gr_name);
	grp = getgrgid(s.st_gid);
	printf("%s ", grp->gr_name);
	printf("%jd ", (intmax_t)s.st_size);
	printf("%s ", convert_time(s.st_mtime));
	printf("%s\n", file_name);
}

char check_type(struct stat s)
{
	char type = 's';
	
	if(s.st_mode & S_IFDIR)
		type = 'd';
	else
		if(s.st_mode & S_IFREG)
			type = '-';
		else
			if(s.st_mode & S_IFLNK)
				type = 'l';
				
	return type;
}

int stat_file(char* file, struct stat *s)
{
	if(stat(file, s) == -1)
	{
		fprintf(stderr, "ls: cannot access '%s':  %s \n", file, strerror(errno));
		return 1337;
	}
	
	return 0;
}

char* safe_cat(char* file1, char* file2)
{
	char* buff = (char *)calloc(1, (strlen(file1) + strlen(file2)) * sizeof(char) + 3);
	strcpy(buff, file1);
	strcat(buff, file2);
	
	return buff;
}

void stat_all(char* path, directory dir, struct stat* s)
{
	int i = 0;
	while (i < dir.files_length)
	{
		stat_file(safe_cat(path, dir.files[i]), &s[i]);
		i = i + 1;
	}
}
