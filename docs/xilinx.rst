Xilinx
======

The Xilinx based targets are built in CI/CD using the ADSP approach documented
in :doc:`adsp`. Additionally, a non-standard ADI specific approach is also
maintained and documented below.

Top-level Makefile
------------------

A small wrapper at the repo root mirrors the in-tree workflow without having
to ``cd buildroot/`` first:

.. code-block:: bash

   make buildroot                   # clone & patch (skips if buildroot/ exists)
   make zynq_pluto_defconfig        # from ./configs and forwarded to Buildroot
   make -j$(nproc)                  # forwarded; BR2_EXTERNAL is set for you

Override the checkout source with ``BUILDROOT_URL`` / ``BUILDROOT_VERSION``; the
defaults point at the `ADI Buildroot fork <https://github.com/analogdevicesinc/buildroot>`_
on ``adi-2026.02-y``. ``make buildroot-patch`` re-applies any local patches and is
idempotent — patches already present in the checkout are skipped via
``git apply --check``.

Be mindful of your environment variables, they may overwrite variables and
affect the build. You can unset a single variable like ``U`` by suffixing with
``env -u U make``.

Buildroot Patches
-----------------

``patches/buildroot/`` holds ADI-specific Buildroot changes (package fix-ups,
kernel build glue, etc.). These are already merged into the ADI Buildroot
fork the submodule points at, so they are normally no-ops at build time. They
are kept here as an applicable set so the same image can be built against a
stock upstream Buildroot checkout (via ``BUILDROOT_URL`` override) without
manually carrying the patches.
