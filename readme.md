
# ADI br2-external

This Buildroot external tree supports Analog Devices ADSP-SC598 and SC589 evaluation kits.

---

## Program Pre-built Binaries

Pre-built binaries can be directly flashed onto the board via JTAG or loaded into RAM using U-Boot and initramfs. See the "Bootstrap" and "Initramfs RAM Boot" sections for both methods.

---

## Clone and Build

```bash
git clone --recurse-submodules https://github.com/analogdevicesinc/br2-external.git
cd br2-external/buildroot
```

### Configure for EV-SC598-SOM

```bash
make BR2_EXTERNAL="${PWD}/.." adi_sc598_ezkit_defconfig
support/kconfig/merge_config.sh .config ../board/adi/ev-sc598-som/buildroot.fragment
```

### Optional Build Configs

Use one of the following fragment files depending on your need:

#### Bootstrap Image

Minimal image with SPI flash programming tools.

```bash
support/kconfig/merge_config.sh .config ../board/adi/ev-sc598-som/bootstrap.fragment
```

#### Initramfs Image

Kernel with built-in rootfs for RAM booting.

```bash
support/kconfig/merge_config.sh .config ../board/adi/ev-sc598-som/initramfs.fragment
```

#### Kuiper Image

Full-featured image with Kuiper Linux packages.

```bash
support/kconfig/merge_config.sh .config ../board/adi/ev-sc598-som/kuiper.fragment
```

### Build

```bash
make -j"$(nproc)"
```

---

## Output Artifacts

After build completes, artifacts are in `output/images/`:

```
boot.vfat
emmc.img
flash.img
Image
rootfs.ext2
rootfs.ext4 -> rootfs.ext2
sc598-som-ezkit.dtb
u-boot
u-boot.ldr
u-boot-spl
u-boot-spl.ldr
```

---

## Initramfs RAM Boot (No Flash Required)

Used for fast development using kernel + initramfs over network.

### Required Artifacts

- Image
- sc598-som-ezkit.dtb

### Start HTTP Server

```bash
cd output/images
python3 -m http.server
```

### U-Boot Commands

```bash
wget ${kernel_addr_r} http://<host-ip>/Image
wget ${fdt_addr_r} http://<host-ip>/sc598-som-ezkit.dtb
booti ${kernel_addr_r} - ${fdt_addr_r}
```

### Memory Addresses

| Component    | Variable         | Address     |
|--------------|------------------|-------------|
| Kernel       | kernel_addr_r    | 0x90009000  |
| Device Tree  | fdt_addr_r       | 0x90000000  |

---

## Bootstrap to Flash (JTAG)

Used for flashing U-Boot and images to SPI NOR flash.

### Build and Install OpenOCD

```bash
git clone https://github.com/analogdevicesinc/openocd
cd openocd
./bootstrap
./configure
make -j$(nproc)
```

### Start OpenOCD

```bash
src/openocd -f ice1000.cfg \
    -f adspsc59x_a55.cfg \
    --search tcl/ \
    --search tcl/interface/ \
    --search tcl/target/
```

### Load U-Boot via GDB

```bash
sudo apt-get install -y gdb-multiarch
cd br2-external/buildroot/output/images
gdb-multiarch
(gdb) load u-boot-spl
(gdb) c
^C
(gdb) load u-boot
(gdb) c
```

### Flash U-Boot and System Image

Start web server from host:

```bash
python3 -m http.server
```

On U-Boot console:

```bash
sf probe
dhcp
wget ${fdt_addr_r} <host-ip>:/flash.img
sf update ${fdt_addr_r} 0x0 ${filesize}
```

Set rotary switch S1 to 1 and reset the board.

---

## Hardware Design and Constraints

- GPIO expanders control power and peripheral enable/disable.
- Ethernet and USB share SoC pins; not usable simultaneously.
- UART0 and SD/MMC are behind switches; only one option active at boot.
- SPI2 connects to multiple peripherals through bus switches.

### Board Revisions

- Mainline support targets Rev. E.
- Rev. D has different GPIO and NOR flash; may not boot or show console.

---

## Directory Layout

```
board/adi/
├── adzs-sc589-ezlite/
├── ev-sc598-som/
│   ├── *.fragment, genimage.cfg, post-build.sh
patches/
├── linux/
│   ├── *.patch, *.fragment
├── uboot/
│   ├── *.patch
```

---

## References

- Buildroot BR2_EXTERNAL Manual: https://buildroot.org/downloads/manual/manual.html#custom-br2-external