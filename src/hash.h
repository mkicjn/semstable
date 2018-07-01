#ifndef HASH_H
#define HASH_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct bucket_s { // Linked list
	unsigned long key;
	void *val;
	struct bucket_s *cdr; // Next node
} bucket_t;
typedef struct {
	int size; // Number of bucket locations
	bucket_t **pool;
	void (*destructor)(void *);
} table_t;

table_t *new_table(int,void (*)(void *));
void free_table(table_t *);
void insert(table_t *,char *,void *);
void *lookup(table_t *,char *);
void expunge(table_t *,char *);
#endif
