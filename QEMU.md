* Command I used to get started with QEMU and virt-manager on Archlinux
* Checked if virtualization is enabled
```shell
$ egrep -c '(vmx|svm)' /proc/cpuinfo
16
```