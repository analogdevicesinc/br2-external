ADSP
====

Supported Boards
----------------

- :doc:`sc598`: ADI SC598 EZ-KIT and EZLITE.
- :doc:`sc846`: ADI SC846 EZ-KIT.

Getting Started
---------------

.. code-block:: bash

   git clone --recurse-submodules https://github.com/analogdevicesinc/br2-external.git
   cd br2-external/buildroot
   # build Buildroot configuration for adi_sc598_ezkit
   make BR2_EXTERNAL="${PWD}/.." adi_sc598_ezkit_defconfig

Additional configuration is applied using Buildroot fragments:

.. code-block:: bash

   support/kconfig/merge_config.sh .config \
       ../configs/buildroot.fragment \
       <ADI Configuration fragments>

ADI Configuration Fragments
----------------------------

- ``configs/buildroot.fragment``

  - Configure Buildroot to speed up builds

- ``configs/debug.fragment``

  - Enable debugging in U-Boot and the kernel
  - Build the kernel image with an embedded root filesystem to reduce
    complexity around writing and mounting a root filesystem from storage

- ``configs/bootstrap.fragment``

  - Enable a minimal bootstrap / installer image
  - Includes only the tools required to program boot media

- ``configs/initramfs.fragment``

  - Build a standalone, RAM-only file system for hardware testing

Example Builds
--------------

Debug Image:

.. code-block:: bash

   make BR2_EXTERNAL="${PWD}/.." adi_sc598_ezkit_defconfig
   support/kconfig/merge_config.sh .config \
       ../configs/buildroot.fragment \
       ../configs/debug.fragment
   make -j$(nproc)

Bootstrap Image:

.. code-block:: bash

   make BR2_EXTERNAL="${PWD}/.." adi_sc598_ezkit_defconfig
   support/kconfig/merge_config.sh .config \
       ../configs/buildroot.fragment \
       ../configs/bootstrap.fragment
   make -j$(nproc)

Initramfs for arm64:

.. code-block:: bash

   make BR2_EXTERNAL="${PWD}/.." adi_sc598_ezkit_defconfig
   support/kconfig/merge_config.sh .config \
       ../configs/buildroot.fragment \
       ../configs/initramfs.fragment
   make -j$(nproc)

Board Documentation
-------------------

.. toctree::
   :maxdepth: 1

   sc598
   sc846
