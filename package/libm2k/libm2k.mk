################################################################################
#
# libm2k
#
################################################################################
LIBM2K_VERSION = 94fb7036f0541e6d655d80610b3eb04aea580a69
LIBM2K_SITE = https://github.com/analogdevicesinc/libm2k.git
LIBM2K_SITE_METHOD = git

LIBM2K_INSTALL_STAGING = YES
LIBM2K_LICENSE = LGPL-2.1
LIBM2K_LICENSE_FILES = LICENSE
LIBM2K_DEPENDENCIES = libiio

LIBM2K_CONF_OPTS = -DENABLE_DOC=OFF \
	-DBUILD_EXAMPLES=ON \
	-DENABLE_LOG=OFF \
	-DENABLE_EXCEPTIONS=ON \
	-DENABLE_PYTHON=OFF \
	-DENABLE_CSHARP=OFF \
	-DENABLE_LABVIEW=OFF \
	-DENABLE_TOOLS=ON \
	-DINSTALL_UDEV_RULES=OFF


$(eval $(cmake-package))
