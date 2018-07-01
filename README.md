# simplehashtest
A hash table implementation I made to use somewhere else

I made this for two reasons
* I wanted a hash table implementation to use somewhere else.
* I wanted to figure out how hash tables work by making one.

Long story short: I didn't want to learn how to use someone else's work if I'm only going to use it once, especially since I'm probably going to use it in a personal project (prototype) where it doesn't matter how good it is. So, I figured I might as well make it myself so I can at least learn from it.

### Test Program Usage

Compile with `make`.

Run `./a.out x y z` to make a hash table with x buckets, y entries, and then access each entry z times (for timing purposes).

Only the retrieval phase is timed.

Run without arguments to manually test it, using the following commands:

Command      | Action
---          | ---
`hash_key s` | Print the hash key of "s"
`insert s n` | Set "s" to "n", adding the entry if undefined
`lookup s`   | Get the value of the entry for "s"
`expunge s`  | Destroy data for "s"

On my machine, the retrieval phase of `./a.out 1000 10000 100` takes 0.3 seconds.

### Library Usage

I'm writing this mostly as a reminder to myself when I use it later.

Values are stored and returned as `void *`, but with typecasting you can store anything of the same width.

Function                     | Notes
---                          | ---
`new_table(size,destructor)` | "Size" represents number of bucket locations. "Destructor" is a function pointer used to destroy stored values.
`insert(table,string,value)` | Adds an entry for string. If an entry for string is already present, it will destroy the old value and assign the new one.
`lookup(table,string)`       | Returns the value of the entry for string, or null if no entry is found.
`expunge(table,string)`      | If an entry for string is found, destroys its value and removes the entry.
`free_table(table)`          | Destroys the table's memory and all stored values.

The table will not check for null values before destroying.

For an example of storing `long`s as values instead of malloc'd blocks, see test.c past `NOT_ENOUGH_ARGS`.

As for storing pointers to multiple types, it's easy enough to implement your own variable type system with `enum` and `union`; I won't explain it here.
