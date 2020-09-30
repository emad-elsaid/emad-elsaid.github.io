Technology is moving fast. This is true for the tools we developers are using to
build web applications. You wake up everyday on news about new library or
framework or a new feature in the language you're already using. Tools are
getting more complex and layers of abstractions are added over each other faster
than I can keep up with. Marketing are getting stronger everyday. Reading
documentation for a framework/program recently triggers me with a lot of
marketing sentences that doesn't deliver any concrete proof to their claims,
just shiny buzz words that should excite me to use this new tool.

With that I think it's more sane for me to understand the existing software that
I have on my system before I add anything to it. I'm using Linux on all of my
work machines and servers. That means I should gain a deeper understanding to
the userland applications that comes with my work machine distribution
(Archlinux) and the one I use on my servers (Ubuntu). With a better
understanding to what the system can already do I would gain a more stable
knowledge that has a further expiration date than say a new components
JavaScript library.

This following will be my attempt to aggregate the knowledge I gained to build
an organized Linux system that can host multiple Web services for a small
company. I'll try to use the system features as much as possible before adding
more software. Software choices will favor boring old software than new and
shiny ones. I'll try to keep it simple. That doesn't mean it'll be an easy task
but a simpler one with less abstraction layers to understand and maintain. I'll
try to keep what I do relevant to two Linux distributions (Archlinux and
Ubuntu).

At the end of this page we should have a Linux system that's ready to
host several web applications with all it needs from HTTP servers, database
servers, caching server, logs and monitoring..etc.

## A New Linux server, Where should I start?

You can get a good VPS server for cheap price from many providers, Digital ocean
and Linode are famous choices, My favorite provider is Hetzner their prices are
way better and they are very reliable I'm have been a customer for 5 years now
with no issues.

## Allow SSH key login and disable password login

The default login to your VPS server uses a username and password so lets
make that better.

We'll create an RSA key pair for you, on your machine execute this command:
```
ssh-keygen
```

Then copy the generated public key to your server
```
ssh-copy-id -i ~/.ssh/id_rsa.pub root@your-server-ip
```

Now SSHing to your server should work without a password, make sure of that
before disabling the password login.

Disable the password login in your server SSH by editing `/etc/ssh/sshd_config`
and set `ChallengeResponseAuthentication` and `PasswordAuthentication` to `no`.

After editing the file changes won't apply to the current SSH server until you
reload it. SSH is running as systemd service, to reload it

```
systemctl reload ssh
```

Here is a bonus, If you already have systemd running on your system you can
execute the systemctl commands with `-H root@your-server-ip` to execute the
command on your server. You don't need to login to execute it. the `-H`
argument will execute the command on the remote server.

For the previous couple commands we used the `ssh-keygen` and `ssh-copy-id` from
`openssh` package and `sshd` on the server and `systemctl` from systemd to
reload the service. I encourage you to read more about them. Try reading their
manual page on your machine with `man command-name`.

If you want to show your server SSH service logs you can use another program
from systemd package `journalctl` to do that.

```
journalctl --unit ssh
```

### Make it easier to SSH

On your local machine SSH command reads `~/.ssh/config` to know about the
servers and their IP addresses and which keys to use and which user...etc so I
do a simple configuration for my SSH server in this file as follows:

```
Host vps
     HostName server.ip.address.here
     User root
     IdentityFile ~/.ssh/id_rsa
```

This will allow you to ssh to your server with this

```
ssh vps
```

instead of this
```
ssh root@server.ip.address.here
```

The `IdentityFile` line is not necessary if you're using `~/.ssh/id_rsa` but if
you generated the VPS private key to another file use it here.

This simple configuration saved me a lot of time.

Many guides on the web recommend having SSHd listening on another port than the
default and disabling the root user login and using another user name. I fail to
see the benefit for that so far but feel free to do it if you wish.

## Update the system packages

Lets update the packages. The command will depend on your distribution.

```
Ubuntu: apt update && apt upgrade && apt autoremove
Archlinux: pacman -Syu
```

## Clean the system

I also review the installed packages and uninstall the unnecessary ones, list
your installed packages with

```
Ubuntu: apt list --installed
Archlinux: pacman -Qet
```

Then uninstall the ones you feel not useful to you.
```
Ubuntu: apt remove <package-name>
Archlinux: pacman -Rs <package-name>
```

And review the running services and stop the ones you don't need

```
systemctl list-unit-files --state=enabled
```

Also the enabled timers

```
systemctl list-timers
```

## Enable the firewall

Lets allow SSH only for now and enable the firewall, make sure you can login
with SSH after doing it

```
ufw allow ssh
ufw enable
```

## Setting up users groups

First concept we'll map from our company is Teams. Each team in the company
we'll correspond to a Linux group. Teams members will be Linux users in their
teams group. Simple and straight forward.

So for each team in the company we'll create a user and a group. Initially I was
set to create only a group for each team, but I also need projects to work under
teams not team members. So As creating a new user will also create a group for
him I decided to create a user + group for each team. This way we can use the
user home for projects and for running services (we'll get in to that later).

```
useradd -m teamname
useradd -m membername
usermod -a -G teamname membername
```

So for every team member he'll have his home directory for private files and
team home for projects and shared data.

```
chmod 770 /home/teamname
chmod g+s /home/teamname
```

Each team directory will be readable and writable for each member of the team.

## Give access to each team member

Each user should generate an SSH key and you should get their public key and add
it to their `.ssh/authorized_keys`

## Our first web service

Now we have our teams setup and team members on our system, they can login and
use the system existing software, they can download binaries and run it as they
wish.

This means if there is a program one of our teams wrote they can run it by login
and putting the project files in their team home directory and run the program
to listen on a port.

Having this application run as the team user instead of the team member user is
the first challenge we'll tackle.

## Running web service as a systemd service

This is the next concept we'll map from our real world to the system. Each
project we'll need to run on our system will be equivalent to a systemd service.

Systemd manages our system resources, background services like the http server,
database server, redis server, networking, and alot of things we'll use some of
them in time.

Systemd allow us to define our own services and run it as a user on this system
as long as we're logged into the system.

First lets define our service file. In your team home directory you need to
create file for your web service
`/home/teamname/.config/systemd/user/myservice.service` with similar content

```conf
[Unit]
Description=A useful web service
After=network.target

[Service]
ExecStart=/home/teamname/projects/myservice/program/binary
WorkingDirectory=/home/teamname/projects/myservice
User=teamname
Group=teamname
Restart=always

[Install]
WantedBy=multi-user.target
```

Now reload systemd to discover this new service file

```
systemctl daemon-reload
```

Listing systemd services with `systemctl list-unit-files` should have your new
service among them.

enabling it and starting it should run your service

```
systemctl enable myservice --user
systemctl start myservice --user
```

And when you login to the system with any this team group account the service
will start automatically. When you logout it'll be stopped.

To make the service run on boot we need to turn on the lingering for the team,
and as this is a common use case you'll need to do it for all the teams

```
loginctl enable-linger teamname
```

The only problem now is that we login as a team member and we want to run the
previous `enable` and `start` commands as this team user not our user so the
service runs for the team and any one in the team can control it. If you
executed the commands as you the service will run under the team member account
which will make it stop when he's logged out.

So we need team member to switch to the group user when they want without
password, the command responsible about that is

```
sudo -u teamname command
```

But it asks for a password, so to allow team members for `teamname` to `sudo`
without password as `teamname` user. Add the following line to `/etc/sudoers`
for each team.

```
%teamname ALL = (teamname) NOPASSWD: ALL
```

Now any team member can start/stop/enable/disable the service for the team.

```
sudo -u teamname systemctl start myservice --user
```

And it'll keep running after the team member logout, If necessary you can have a
CI user for each team that execute these commands as part of your continuous
integration steps.

So far our service will be used inside the system, so if the service listens on
port 8080 you can curl it with

```
curl http://localhost:8080
```

so lets improve this `localhost` to our actual company name `companyname`

```
hostnamectl companyname
```

And add your domain name to `/etc/hosts` to allow local services to resolve it
faster when using it to refer to other services

```
127.0.0.1    companyname.tld
```

So now you can curl your service with `curl http://companyname.tld:8080`
instead.

## Further securing your web service

Systemd provides many features to isolate your service so in the case of
misbehaving it'll do the least damage possible to the system.

Each of these features can be turned on by adding the property name in the
service file. for example `NoNewPreivileges` ensures that the service or any of
it's children CANNOT gain more privileges. `ProtectSystem=full` will mount
`/usr` and `/boot` and `/etc` as readonly for this service,
`ProtectSystem=strict` will make the whole filesystem read only for this
service. You can also whitelist paths to be writable if you made the
`ProtectSystem=strict` with `ReadWritePaths` or forbid accessing certain paths
with `InaccessiblePaths`. `PrivateTmp` will make the service see `/tmp`
directory empty for the service so services doesn't read each other `/tmp`
files.

Many of these features are listed in `man systemd.exec` especially "Sandboxing"
section.

## Special environment variables for the service

Most of the time projects read their configuration from the system environment,
with Systemd you can set `EnvironmentFile=/path/to/.envfile` to set the file
content as environment for this service.

## Checking your service logs

Journalctl will keep the service standard output and standard error to log files
you can check it with:

```
sudo -u teamname journalctl --unit myservice --user
```

journalctl will keep your logs to 10% of the filesystem or 4GB of data which
ever is reached first you can change that from `/etc/systemd/journald.conf`. You
can see all logs of the team with

```
sudo -u teamname journalctl
```

You can check logs for a service since or until a date with `--since` and
`--until` which accepts several formats like "today" "yesterday" or "2020-09-28"
then you can pipe it to `grep` to search for a specific log.


## Making the service accessible on the internet

Now we need this service to be accessible on the internet through
`www.companyname.tld`. As our system will have many web services each one of
them will listen on a port inside our system and we'll then route the traffic
from port 80 to the service based on the hostname.

so we can route `www.companyname.tld` to `127.0.0.1:8080` and
`order.companyname.tld` to `127.0.0.1:8081` and so on.

As port 80 can be only used by a service running as root it'll be the
responsibility or the `root` user to setup new services incoming traffic
routing.

The current system can't do this with existing tools. We'll need to use an
application that listens on port 80 and route traffic. I choose `haproxy` for
this.

```
Ubuntu: apt install haproxy
Archlinux: pacman -S haproxy
```

Then change the configuration file `/etc/haproxy/haproxy.cfg` to this

```config
global
  daemon
  maxconn 256

defaults
  mode http
  timeout connect 5000ms
  timeout client 50000ms
  timeout server 50000ms

frontend http
  bind *:80
  use_backend myservice if { hdr(host) -i www.companyname.tld }

backend myservice
  server myservice  127.0.0.1:8080
```

In the future if you want to add another service you'll need to duplicate the
`use_backend` line and the `backend` block.

Lets enable and start haproxy

```
systemctl enable haproxy
systemctl start haproxy
```

Now haproxy is listening on port 80, but the traffic is rejected by the
firewall. lets allow HTTP traffic.

```
ufw allow http
```

You can for sure automate these steps with some code and a CI pipeline.

Now you can add DNS A record to your DNS provider to your server that route all
traffic under `*.companyname.tld` to the server IP address.

If you used Cloudflare you can turn on their CDN feature and it'll hide the
server IP address behind their proxy network, so the DNS will resolve to their
proxy and the proxy will communicate with your server. and in this case you can
actually refuse any traffic coming to Haproxy except from cloudflare IPs.

## A note on automation

Mybe we did everything manually here but that doesn't mean it's the only way.
You can still automate every step we did so far with a bash script and `scp` it
and execute it on the host with `ssh vps /path/to/script`, it's as simple as
that. If this is too easy for you there is always more automation software to
squeez in your tech stack.

## It's never done

There is always problems to solve and improvements to the system like:

- [Limiting home directories sizes for team member
  ](https://www.digitalocean.com/community/tutorials/how-to-set-filesystem-quotas-on-ubuntu-18-04)
  as it doesn't need to be large at all.
- Get notifications when the system resources are exhausted like the disk free
  space is too low or the CPU usage is too high for some time or memory usage is
  too high
- [Limiting services memory/cpu/filesystem usage
  ](https://unix.stackexchange.com/questions/345595/how-to-set-ulimits-on-service-with-systemd)
  which is supported by systemd
- Archive old logs to remote system
- Backup the system to external machine or create filesystem screenshots if you
  choose a filesystem that supports it like ZFS

The important thing is Linux systems can be multitenent and one system can hold
a small company software, expanding the resources can go a long way before you
hit the system actual limits. Communication won't need any expensive network
requests and sharing files is the default.

The only thing that will stop in your way is inefficient software, and for that
you'll need to make abit of an extra effort to tame it.

## Read More:

* [Part 2](/single-machine-startup-company-system-part-2)
