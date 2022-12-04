* Docs https://redis.io/docs
  * Streams tutorial was too long: https://redis.io/docs/data-types/streams-tutorial/
  * Distributed locks are interesting read: https://redis.io/docs/manual/patterns/distributed-locks/
* Commands list: https://redis.io/commands/
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

## It had a Gopher protocol implementation

> Redis contains an implementation of the Gopher protocol, as specified in the RFC 1436.
> Note: Support for Gopher was removed in Redis 7.0
> https://redis.io/docs/reference/gopher/

# Setup seems to need some tweaking from the kernel

as provided here: https://redis.io/docs/management/admin/

1. Set the Linux kernel overcommit memory setting to 1. Add vm.overcommit_memory = 1 to /etc/sysctl.conf. Then, reboot or run the command sysctl vm.overcommit_memory=1 to activate the setting.
2. To ensure the Linux kernel feature Transparent Huge Pages does not impact Redis memory usage and latency, use this command: `echo never > /sys/kernel/mm/transparent_hugepage/enabled`
3. Same page has many other good tips about deployment on AWS EC2 and what kind of machines to use


# Marketing speak

in the [Sentinel page](https://redis.io/docs/management/sentinel/) I started to smell marketing speak bullshit: 

> You need at least three Sentinel instances for a robust deployment

What does **robust deployment** even mean? 

# Internals

As usual the best pages are the pages talking about the internals. such as the events library or string internals. it's outdated (since 2010) but it speaks true of what the software is and what happens inside it. reminds me of the Varnish architecture document.