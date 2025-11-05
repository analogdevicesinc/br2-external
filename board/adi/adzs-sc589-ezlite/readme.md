# ADSP-SC589 Evaluation Hardware

This tutorial describes how to use the predefined Buildroot
configuration for the ADSP-SC589 evaluation hardware.

## Building

```bash
make adi_sc589_ezlite
make -j$(nproc)
```

## Bootstrap

Build and install the ADI fork of OpenOCD:

```bash
git clone https://github.com/analogdevicesinc/openocd
./bootstrap
./configure 
make -j$(nproc)
src/openocd -f ice1000.cfg \
    -f adspsc58x.cfg \
    --search tcl/ \
    --search tcl/interface/ \
    --search tcl/target/
```

```bash
sudo apt-get install -y gdb-multiarch
gdb-multiarch
(gdb) load u-boot-spl
(gdb) c
^C
(gdb) load u-boot
(gdb) c
```
