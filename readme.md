# ADI br2-external

This [br2-external](https://buildroot.org/downloads/manual/manual.html#outside-br-custom)
contains Buildroot configuration specific to ADI that cannot be mainlined.
Generic support for ADI evaluation boards is implemented in the
[ADI Buildroot tree](github.com/analogdevicesinc/buildroot).

## Getting Started

```sh
git clone --recurse-submodules https://github.com/analogdevicesinc/br2-external.git
cd br2-external/buildroot
make BR2_EXTERNAL="${PWD}/.." adi_sc598_ezkit_defconfig
```

Additional configuration is applied using Buildroot fragments:

```sh
support/kconfig/merge_config.sh .config \
    ../configs/buildroot.fragment \
    <ADI Configuration fragments>
```

## Top-level Makefile

A small wrapper at the repo root mirrors the in-tree workflow without having
to `cd buildroot/` first:

```sh
make buildroot                   # clone & patch (skips if buildroot/ exists)
make zynq_pluto_defconfig        # forwarded to Buildroot
make -j$(nproc)                  # forwarded; BR2_EXTERNAL is set for you
```

Override the checkout source with `BUILDROOT_URL` / `BUILDROOT_VERSION`; the
defaults point at the [ADI Buildroot fork](https://github.com/analogdevicesinc/buildroot)
on `adi-2026.02-y`. `make buildroot-patch` re-applies any local patches and is
idempotent — patches already present in the checkout are skipped via
`git apply --check`.

## Buildroot patches

`patches/buildroot/` holds ADI-specific Buildroot changes (package fix-ups,
kernel build glue, etc.). These are already merged into the ADI Buildroot
fork the submodule points at, so they are normally no-ops at build time. They
are kept here as an applicable set so the same image can be built against a
stock upstream Buildroot checkout (via `BUILDROOT_URL` override) without
manually carrying the patches.

## ADI Configuration Fragments

- `configs/buildroot.fragment`
    - Configure Buildroot to speed up builds
- `configs/debug.fragment`
    - Enable debugging in U-Boot and the kernel
    - Build the kernel image with an embedded root filesystem to reduce
      complexity around writing and mounting a root filesystem from storage
- `configs/bootstrap.fragment`  
    - Enable a minimal bootstrap / installer image.  
    - Includes only the tools required to program boot media.

## Example Builds

### Debug Image

```sh
make BR2_EXTERNAL="${PWD}/.." adi_sc598_ezkit_defconfig
support/kconfig/merge_config.sh .config \
    ../configs/buildroot.fragment \
    ../configs/debug.fragment
make -j$(nproc)
```

### Bootstrap Image

```sh
make BR2_EXTERNAL="${PWD}/.." adi_sc598_ezkit_defconfig
support/kconfig/merge_config.sh .config \
    ../configs/buildroot.fragment \
    ../configs/bootstrap.fragment
make -j$(nproc)
```
