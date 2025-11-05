# ADI br2-external

## Program pre-built binaries

## Build from source

```
git clone --recurse-submodules https://github.com/analogdevicesinc/br2-external.git
cd br2-external/buildroot
```

### Configure EV-SC598-SOM

```
make BR2_EXTERNAL="${PWD}/.." adi_sc598_ezkit_defconfig
support/kconfig/merge_config.sh .config \
    ../board/adi/ev-sc598-som/buildroot.fragment
```

### Build

```
make -j "$(nproc)"
```

## Bootstrap

Build and install the ADI fork of OpenOCD:

```bash
git clone https://github.com/analogdevicesinc/openocd
./bootstrap
./configure 
make -j$(nproc)
```

Run `openocd` with either `ice1000.cfg` or `ice2000.cfg` and one of the
following configs:

- `adspsc58x.cfg`
- `adspsc59x_a55.cfg`

For example, for the ICE-1000 and ADZS-SC589-EZLITE run the following:

```
src/openocd -f ice1000.cfg \
    -f adspsc58x.cfg \
    --search tcl/ \
    --search tcl/interface/ \
    --search tcl/target/
```

In another terminal either `cd` into the extracted release archive or
`br2-external/buildroot/output/images` when building from source. Then load and
run the two U-Boot stages using `gdb-multiarch`:

```bash
sudo apt-get install -y gdb-multiarch
gdb-multiarch
(gdb) load u-boot-spl
(gdb) c
^C
(gdb) load u-boot
(gdb) c
```
