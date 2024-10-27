#sideprojects 

I recently bought a lenovo laptop with LTE modem. 
I think it's possible to convert it to an LTE router similar to what [Huawei B618s-22d LTE Modem Router Cat11 600Mbit B618](https://www.amazon.de/-/en/gp/product/B074L91MGJ/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&th=1) which I use as home router. 

# Setup 

* I installed nixos on it with Gnome interface.
* Turn on IP forwarding `boot.kernel.sysctl."net.ipv4.ip_forward" = 1;`
* [ ] install DHCP server
* [ ] setup a wifi network
* [ ] setup DNS cache server and reslove to cloudflare and google servers
* [ ] make sure wire networking also works
