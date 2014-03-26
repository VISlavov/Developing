#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <pthread.h>

//--------------------------------------------
// NAME: Victor Slavov
// CLASS: 11 b
// NUMBER: 7
// PROBLEM: #3
// FILE NAME: wc3.c
// FILE PURPOSE:
//  Realise a mine-worker system like the one in Warcraft 3.
//  As i know you can not assimilate that thought very easy
// 	here is where you can read about it:
//  http://us.blizzard.com/en-us/games/war3/
//---------------------------------------------

struct wc3things
{
	float* workers;
	float* mines;
	int mines_count;
	int workers_count;
	float gold;
	int end_reached;
};
typedef struct wc3things wc3things;

struct pack
{
	wc3things* things;
	int worker;
};
typedef struct pack pack;

//--------------------------------------------
// FUNCTION: init
//  Initializes the workers and the mines
// PARAMETERS:
//	argc - arguments count
//  argv[] - arguments
//  things - contains main objects
//----------------------------------------------
void init(wc3things* things, int argc, char* argv[]);

//--------------------------------------------
// FUNCTION: collect_gold
//  Makes a worker take gold from a certain mine
// PARAMETERS:
//  the_pack - contains main objects struct + id of the current worker
//----------------------------------------------
int collect_gold(void* the_pack);

//--------------------------------------------
// FUNCTION: check_gold_status
//  Checks if the gold in all mines is equal to zero.
// PARAMETERS:
//  things - contains main objects
//----------------------------------------------
int check_gold_status(wc3things* things);

//--------------------------------------------
// FUNCTION: check_gold_status
//  Makes all of the work of the miners for the mines to get empty.
// PARAMETERS:
//  things - contains main objects
//----------------------------------------------
int working_process(wc3things* things);


pthread_mutex_t lock;
pthread_t* threads;


int main(int argc, char* argv[])
{
	int i = 0;
	wc3things things = {
		calloc(2, sizeof(int) * 2),
		calloc(1, sizeof(float)),
		1,
		2,
		atof(argv[1]),
		0
	};
	
	threads = (pthread_t*)calloc(2, sizeof(pthread_t));
	
	init(&things, argc, argv);
	
	if(working_process(&things) == 13)
	{
		pthread_mutex_destroy(&lock);
		free(threads);
		free(things.mines);
		free(things.workers);
		return 0;
	}
}

void init(wc3things* things, int argc, char* argv[])
{
	int i = 0;
	
	if(argc == 3 || argc == 4)
	{
		things->workers = realloc(things->workers, sizeof(int) * (things->workers_count = atoi(argv[2])));
		
		threads = realloc(threads, sizeof(pthread_t) * things->workers_count);
		
		if(argc == 4)
			things->mines = realloc(things->mines, sizeof(float) * (things->mines_count = atoi(argv[3])));
	}
	
	while(i < things->mines_count)
	{
		things->mines[i] = things->gold / things->mines_count;
		i = i + 1;
	}
}

int collect_gold(void* the_pack)
{
	pack* package = (pack*)the_pack;
	wc3things* things = package->things;
	float portion = 0;
	int non_empty_mine = 0;
	int worker = package->worker;
	
	while(1)
	{
		pthread_mutex_lock(&lock);
		
		if((non_empty_mine = check_gold_status(things)) == -42)
		{
			pthread_mutex_unlock(&lock);
			return 1337;
		}
		else
		{
			if(things->mines[non_empty_mine] < 10)
				portion = things->mines[non_empty_mine];
			else
				portion = 10;
				
			printf("worker %d entered mine %d\n", worker + 1, non_empty_mine + 1);
			things->workers[worker] = things->workers[worker] + portion;
			sleep(1);
			things->mines[non_empty_mine] = things->mines[non_empty_mine] - portion;
			sleep(1);
			printf("worker %d exited mine %d \n", worker + 1, non_empty_mine + 1);
		}
	
		pthread_mutex_unlock(&lock);
	}
}

int check_gold_status(wc3things* things)
{
	int i = 0;
	float collected = 0;
	
	while(i < things->mines_count)
	{
		if(things->mines[i] > 0)
			return i;
			
		i = i + 1;
	}
	
	if(things->end_reached == 0)
	{
		i = 0;
		
		while(i < things->workers_count)
		{
			collected = collected + things->workers[i];
			i = i + 1;
		}
		
		printf("overall gold: %f, gold collected: %f \n", things->gold, collected);
		things->end_reached = 1;
	}
	
	return -42;
}

int working_process(wc3things* things)
{	
	int i = 0,
		i1 = 0,
		err = 0,
		retval = 0;
		
	pack the_pack = {
		things,
		0
	};
		
	pack packs[things->workers_count];
		
	if (pthread_mutex_init(&lock, NULL) != 0)
    {
        printf("\n mutex init failed \n");
        return 13;
    }
	
	while(i1 < things->workers_count)
	{
		the_pack.worker = i1;
		packs[i1] = the_pack;
		
		if((err = pthread_create(&threads[i1], NULL, (void *) &collect_gold, &packs[i1])) != 0)
		{
			printf("\ncan't create thread :[%s]\n", strerror(err));
			return 13;
		}
		
		i1 = i1 + 1;
	}
	
	i1 = 0;
	
	while(i1 < things->workers_count)
	{
		if(pthread_join(threads[i1], (void **)&retval) != 0)
		{
			printf("\n join failed :[%s]", strerror(err));
			return 13;
		}
		
		i1 = i1 + 1;
	}
	
	if(retval == 1337)
		return 13;
	
	return 0;
}

