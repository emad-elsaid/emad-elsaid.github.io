---
title: Linux named pipes
image: /images/IMG_20210521_095201.jpg
---

This is a post where I document one of my recent learnings. which is the linux [named pipes](https://en.wikipedia.org/wiki/Named_pipe).

Assuming you are looking for all descriptions of the hardware on your machine. you can use a command that print out the list of hardware like `lshw` which prints something like:

```
mercury
    description: Computer
    width: 64 bits
    capabilities: smp vsyscall32
  *-core
       description: Motherboard
       physical id: 0
     *-memory
          description: System memory
          physical id: 0
          size: 10GiB
     *-cpu
          product: AMD Ryzen 7 2700X Eight-Core Processor
          vendor: Advanced Micro Devices [AMD]
          physical id: 1
          bus info: cpu@0
          width: 64 bits
[...]
     *-pnp00:00
          product: IBM Enhanced keyboard controller (101/2-key)
          physical id: 2
          capabilities: pnp
          configuration: driver=i8042 kbd
     *-pnp00:01
          product: Microsoft PS/2-style Mouse
          physical id: 3
          capabilities: pnp
          configuration: driver=i8042 aux

```

But as this is very long and you want only the list of the hardware without details you can filter them down by **piping** to another filter command like `grep`.

```shell
lshw | grep product
```

Which prints only the lines that include "product" word.

```
          product: AMD Ryzen 7 2700X Eight-Core Processor
          product: 440FX - 82441FX PMC [Natoma]
             product: 82371SB PIIX3 ISA [Natoma/Triton II]
             product: 82371AB/EB/MB PIIX4 IDE
             product: VirtualBox Graphics Adapter
             product: 82540EM Gigabit Ethernet Controller
             product: VirtualBox Guest Service
             product: 82801FB/FBM/FR/FW/FRW (ICH6 Family) High Definition Audio Controller
             product: KeyLargo/Intrepid USB
             product: 82371AB/EB/MB PIIX4 ACPI
             product: 82801HM/HEM (ICH8M/ICH8M-E) SATA Controller [AHCI mode]
          product: IBM Enhanced keyboard controller (101/2-key)
          product: Microsoft PS/2-style Mouse
```

You notice there is indentation in every line and you want to remove it so you can pipe this output to a command that trim the spaces like `awk '{$1=$1};1'`

```bash
lshw | grep product | awk '{$1=$1};1'
```

which prints the lines

```
product: AMD Ryzen 7 2700X Eight-Core Processor
product: 440FX - 82441FX PMC [Natoma]
product: 82371SB PIIX3 ISA [Natoma/Triton II]
product: 82371AB/EB/MB PIIX4 IDE
product: VirtualBox Graphics Adapter
product: 82540EM Gigabit Ethernet Controller
product: VirtualBox Guest Service
product: 82801FB/FBM/FR/FW/FRW (ICH6 Family) High Definition Audio Controller
product: KeyLargo/Intrepid USB
product: 82371AB/EB/MB PIIX4 ACPI
product: 82801HM/HEM (ICH8M/ICH8M-E) SATA Controller [AHCI mode]
product: IBM Enhanced keyboard controller (101/2-key)
product: Microsoft PS/2-style Mouse
```

You can extend this to remove the `product: ` prefix in every line.

## The Pipe

So this sign we used `|` is called a **pipe** and what happens when we use it between two commands is that the shell will execute both commands and pass the standard output **stdout** of the left command to the **stdin** of the right command. which makes the commands output flow without temperory storage from one process to the next.

The Pipe is created pragmatically using **unistd.h** `pipe` function. It creates 2 files descriptors one open for reading and the other is opened for write. then the writing end is passed to the left command as **stdout** and the reading end is passed to the right command as **stdin**.

When the process writes to the write file descriptor the kernel will block until the other process is reading from the other reading file descriptor. then it will flow the written data from the write file to the reading file.


## Shortcomings

The pipe is a good tool to flow standard output of a command to the standard input of another command. But what if the command doesn't read from standard input? in this case we can use the **named pipe**

## Named pipe

Named pipe is just like the pipe but it is represented as a file on the filesystem. so you can pass it to any command that reads or writes to a file and the data will flow from the writing process to the reading process without actually writing it to the disk. the file size remains 0 bytes.

So for the past example we can use named pipe as such.

```bash
mkfifo lshw-output
```

This creates a file called `lshw-output` in the current directory. it works like a normal file but instead of writing and reading from the disk it will work like the pipe. will block writes until another process is reading then it'll flow the data from the writing end to the reading end.

So we can do this by executing the next 2 commands in different terminals:

```bash
lshw > lshw-output
```

```bash
grep product lshw-output
```

And if you want to trim the spaces you can write the last command output to another pipe then read it with `awk`

```bash
mkfifo grep-output
grep product lshw-output > grep-output
```

Then read it with awk in another terminals

```bash
awk '{$1=$1};1' grep-output
```

You'll notice that `lshw` terminal is waiting and the `grep` also is waiting until you execute the `awk` command. which will

* start reading from `grep-output` file
* which means `grep` can start writing to it
* which means it can start reading from `lshw-output` file
* then `lshw` can start writing its output to the `lshw-output` file

so all commands will run in parallel and the data will flow between them without writing it to the disk. if you check the pipe files size it'll be 0 bytes. You can delete the pipe file like any other file with `rm` or `unlink`.

## Usage possibilities

* If you have processes that reads or writes to files not to **stdin** and **stdout** you can create the pipe and pass it as a file parameter.
* If you have a really large continuous output that you don't want to persist on disk just to process it with a program.
* You can give permissions to the pipe so you can have a program that runs as a user with write permissions to the pipe. And have the pipe permission allow a group of users read from it. so you can pass the data from one user to another on the same system.
