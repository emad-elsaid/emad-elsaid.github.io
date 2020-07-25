---
title: "Getting Your CPU Speed in GHz on Linux"
date: 2018-02-12T00:08:43+01:00
---

I'm using I3 and I3blocks on my machine, and I wanted to show my current
processor speed as one of the I3blocks sections just because!

so the first problem I faced is how to get my current processor speed, `lscpu`
returns the full CPU details as follows:

```
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              4
On-line CPU(s) list: 0-3
Thread(s) per core:  2
Core(s) per socket:  2
Socket(s):           1
NUMA node(s):        1
Vendor ID:           GenuineIntel
CPU family:          6
Model:               142
Model name:          Intel(R) Core(TM) i7-7600U CPU @ 2.80GHz
Stepping:            9
CPU MHz:             1490.249
CPU max MHz:         3900.0000
CPU min MHz:         400.0000
BogoMIPS:            5810.00
Virtualization:      VT-x
L1d cache:           32K
L1i cache:           32K
L2 cache:            256K
L3 cache:            4096K
NUMA node0 CPU(s):   0-3
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb invpcid_single pti retpoline rsb_ctxsw tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm mpx rdseed adx smap clflushopt intel_pt xsaveopt xsavec xgetbv1 xsaves dtherm ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp
```

I need to show only the "CPU MHz" line, `grep` could be a potential solution
with

```bash
lscpu | grep "CPU MHz"
```

But that will give you this output

```
CPU MHz:             1484.185
```

so you need to get the number without the text, here we can use `awk` to extract
the number, and as awk will consider it the 3rd column we can do the following
to show only the number

```bash
lscpu | grep "CPU MHz" | awk '{print $3}'
```

that will output the number without any text, and as `awk` can be used to print
in case a condition is true we can print the number if "CPU MHz" is found,
getting rid of `grep`

```bash
lscpu | awk '/CPU MHz/ {print $3}'
```

the number is in MHz, so if we want to display it in GHz we need to divide by
1000

```bash
lscpu | awk '/CPU MHz/ {print $3/1000}'
```

that will print the number with all digits after floating point `2.08582`, if we
need to print it with a certain precision we can use `printf` function to limit
the digits to one or two digits, the following will limit the digits to 2 digits
after floating point

```bash
lscpu | awk '/CPU MHz/ {printf("%0.2f", $3/1000)}'
```

that will print something like `3.07` depending on your processor speed, my
script at the end looked like that

```bash
#!/usr/bin/env bash
lscpu | awk '/CPU MHz/ {printf("%.1f GHz",$3/1000); }'
```

I prefer the 1 digit precision and added "GHz" at the end of the output.
