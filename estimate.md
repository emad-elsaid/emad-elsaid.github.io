* I'm using [Planning Poker online](https://planningpokeronline.com/) at work for estimation
* After a couple of sessions it asks for a subscription
* I would like to self host a free solution
* I already had a project called [estimate](https://github.com/emad-elsaid/estimate) which is written in Ruby
* I deployed this project on Heroku when they had a free-tier
* I would like to host it on my VPS for personal use
* This is a good opportunity to rewrite it in C and learn how to write a simple web application in C

# Findings
* There is a GNU project that offers an HTTP library: [Libmicrohttpd](https://www.gnu.org/software/libmicrohttpd/)
* an echo version is working with static linking to libmicrohttpd and gnu make. [here](https://github.com/emad-elsaid/estimate/blob/73b229afdd4f7a177bc8918f58cee05791c7e5ae/estimate.c)
* During implementation I needed a hashmap which is not part of C standard library.
  * If GNU had a library I prefer to use it over another source. but I can't find a GNU C library for hashmap
  * Glib has a [hashtable](https://docs.gtk.org/glib/struct.HashTable.html). I have a perception that Glib is a core library for Gnome project and implements basic functionality like stdlib for gnome. hence I'll use it 


# Questions
* Any error will crash the program, what kind of countermeasures the program should take to localize errors?