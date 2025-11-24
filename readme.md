# ADI br2-external

This [br2-external](https://buildroot.org/downloads/manual/manual.html#outside-br-custom)
contains Buildroot configuration specific to ADI that can not be mainlined.
Generic support for ADI evaluation boards is implemented in the [ADI Buildroot
tree](github.com/analogdevicesinc/buildroot).

```
git clone --recurse-submodules https://github.com/analogdevicesinc/br2-external.git
cd br2-external/buildroot
make BR2_EXTERNAL="${PWD}/.." adi_sc598_ezkit_defconfig
support/kconfig/merge_config.sh .config \
    ../configs/buildroot.fragment \
    ../configs/debug.fragment
```

Then follow the board specific instructions in `buildroot/board/adi/`.

## ADI configuration

- `configs/buildroot.fragment`
    - Configure Buildroot to speed up builds
- `configs/debug.fragment`
    - Enable debugging in U-Boot and the kernel
    - Build the kernel image with an embedded root filesystem to reduce
      complexity around writing and mounting a root filesystem from storage
