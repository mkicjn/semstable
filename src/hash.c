#include "hash.h"
unsigned long hash_key(char *str)
{
	unsigned long key=0;
	for (char *c=str;*c;c++) {
		key+=*c;
		key*=*c;
		key<<=8;
		key/=*c;
	}
	return key;
}
bucket_t *new_bucket(unsigned long key,void *val)
{
	bucket_t *b=malloc(sizeof(bucket_t));
	b->key=key;
	b->val=val;
	b->cdr=NULL;
	return b;
}
void free_location(bucket_t *b,void (*d)(void *))
{
	bucket_t *t;
	while (b) {
		t=b->cdr;
		if (d)
			d(b->val);
		free(b);
		b=t;
	}
}
table_t *new_table(int size,void (*d)(void *))
{
	table_t *table=malloc(sizeof(table_t));
	table->pool=calloc(size,sizeof(bucket_t *));
	table->size=size;
	table->destructor=d;
	return table;
}
void free_table(table_t *table)
{
	for (int i=0;i<table->size;i++) // Check all locations
		if (table->pool[i])
			free_location(table->pool[i],table->destructor);
	free(table->pool);
	free(table);
}
void insert(table_t *table,char *str,void *val)
{
	unsigned long key=hash_key(str);
	bucket_t *entry=new_bucket(key,val);
	bucket_t **loc=&table->pool[key%table->size]; // : Bucket location in pool
	if (*loc) { // Bucket(s) already in location
		bucket_t *b=*loc;
		while (b->cdr&&b->key!=key) // Look for identical bucket or end
			b=b->cdr;
		if (b->key==key) { // Found identical bucket
			if (table->destructor)
				table->destructor(b->val);
			b->val=entry->val;
			free(entry);
		} else // Found end
			b->cdr=entry;
	} else // No buckets at location
		*loc=entry;
}
void *lookup(table_t *table,char *str)
{
	unsigned long key=hash_key(str);
	bucket_t *b=table->pool[key%table->size]; // : Bucket in pool
	while (b&&b->key!=key) // Look for identical bucket or end
		b=b->cdr;
	if (!b) // Found end
		return NULL;
	return b->val;
}
void expunge(table_t *table,char *str)
{
	unsigned long key=hash_key(str);
	bucket_t *p=NULL,*b=table->pool[key%table->size];
	while (b&&b->key!=key) { // Look for entry
		p=b; // Remember previous node
		b=b->cdr;
	}
	if (!b) // Entry not found
		return;
	if (!p) // No previous node
		table->pool[key%table->size]=NULL;
	else
		p->cdr=b->cdr;
	if (table->destructor)
		table->destructor(b->val);
	free(b);
}
