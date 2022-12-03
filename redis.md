* Docs https://redis.io/docs
  * Streams tutorial was too long: https://redis.io/docs/data-types/streams-tutorial/
  * Distributed locks are interesting read: https://redis.io/docs/manual/patterns/distributed-locks/
* They have extra courses https://university.redis.com/

# To monitor all commands executed on server

```shell
$ redis-cli MONITOR
```

# Client-side caching

one of the modes is to subscribe to key prefix and the server send updates when it receives it.

# Bulk loading data 

```shell
cat data.txt | redis-cli --pipe
```

# Interesting Quotes

## Light on the true nature of redis

> However since Redis is a data structures server, its capabilities can be used for indexing
> https://redis.io/docs/manual/patterns/indexes/