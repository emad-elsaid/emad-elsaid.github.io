13-Apr-2025 #hardware

The following are my Asus mobo and memory AI Tweaker profile settings. These are the maximum values that can be used without introducing instability to the hardware. 

# Motherboard
```
sudo dmidecode -t 2
# dmidecode 3.6
Getting SMBIOS data from sysfs.
SMBIOS 3.1.1 present.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: ASUSTeK COMPUTER INC.
	Product Name: PRIME X470-PRO
	Version: Rev X.0x
	Serial Number: 00000000000000000000
	Asset Tag: Default string
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: Default string
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0
```
# Memory
```
sudo dmidecode -t memory
# dmidecode 3.6
Getting SMBIOS data from sysfs.
SMBIOS 3.1.1 present.

Handle 0x002E, DMI type 16, 23 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 256 GB
	Error Information Handle: 0x002D
	Number Of Devices: 4

Handle 0x0035, DMI type 17, 40 bytes
Memory Device
	Array Handle: 0x002E
	Error Information Handle: 0x0034
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 16 GB
	Form Factor: DIMM
	Set: None
	Locator: DIMM_A1
	Bank Locator: BANK 0
	Type: DDR4
	Type Detail: Synchronous Unbuffered (Unregistered)
	Speed: 2933 MT/s
	Manufacturer: Corsair
	Serial Number: 00000000
	Asset Tag: Not Specified
	Part Number: 000000000000000000
	Rank: 2
	Configured Memory Speed: 1467 MT/s
	Minimum Voltage: 1.2 V
	Maximum Voltage: 1.2 V
	Configured Voltage: 1.2 V

.... 4X the previous block for each memory stick ......
```

# CPU
```
lscpu
Architecture:             x86_64
  CPU op-mode(s):         32-bit, 64-bit
  Address sizes:          43 bits physical, 48 bits virtual
  Byte Order:             Little Endian
CPU(s):                   16
  On-line CPU(s) list:    0-15
Vendor ID:                AuthenticAMD
  Model name:             AMD Ryzen 7 2700X Eight-Core Processor
    CPU family:           23
    Model:                8
    Thread(s) per core:   2
    Core(s) per socket:   8
    Socket(s):            1
    Stepping:             2
    Frequency boost:      disabled
    CPU(s) scaling MHz:   60%
    CPU max MHz:          4000.0000
    CPU min MHz:          2200.0000
    BogoMIPS:             8000.09
    Flags:                fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx
                           fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_goo
                          d nopl nonstop_tsc cpuid extd_apicid aperfmperf rapl pni pclmulqdq monitor ssse3 fm
                          a cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy exta
                          pic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt tce topoext perf
                          ctr_core perfctr_nb bpext perfctr_llc mwaitx cpb hw_pstate ssbd ibpb vmmcall fsgsba
                          se bmi1 avx2 smep bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 cl
                          zero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushb
                          yasid decodeassists pausefilter pfthreshold avic v_vmsave_vmload vgif overflow_reco
                          v succor smca sev sev_es
Caches (sum of all):      
  L1d:                    256 KiB (8 instances)
  L1i:                    512 KiB (8 instances)
  L2:                     4 MiB (8 instances)
  L3:                     16 MiB (2 instances)
NUMA:                     
  NUMA node(s):           1
  NUMA node0 CPU(s):      0-15
```

# AI Teaker settings Settings
- DOCP disabled (only 16-20-20-36 timing is available when enabling DOCP and the system doesn't start)
- DDR4 Frequency 2933MHz (3000MHz is not stable)
- Timing: Auto (not possible to set it while DOCP is disabled)
- DRAM voltage 1.35V
- SOC Voltage: (manual) 1.1V
- Ai Tweaker\DRAM Timing Control -> Gear Down Mode: Enabled

# Stress test
```
sudo stress-ng --vm 2 --vm-bytes 80% --timeout 600s
stress-ng: info:  [2830] setting to a 10 mins run per stressor
stress-ng: info:  [2830] dispatching hogs: 2 vm
stress-ng: info:  [2830] skipped: 0
stress-ng: info:  [2830] passed: 2: vm (2)
stress-ng: info:  [2830] failed: 0
stress-ng: info:  [2830] metrics untrustworthy: 0
stress-ng: info:  [2830] successful run completed in 10 mins, 5.57 secs
```

