---
title: "Bind Remote Server Port to Local Machine With SSH"
---

I have a VPS server that serves an application and a set of customer facing services like images server, analytics server
and search server besides the main web server, but also I have some administrative services services like a database performace
monitoring server called PgHero.

that particular server is not visible to the outside world, it's there listening on port 8003 but the firewall doesn't allow connecting to
that port from the outside world.

I just want me to be the only one to see it, so I bind that server port to my local machine with SSH and I can open http://localhost:8003
to see the service as if it was working on my local machine with that command

```bash
ssh -L 8003:localhost:8003 user@serverip
```
