################################################################################
#
# libini
#
################################################################################

LIBINI_VERSION = 8797a7b5b70a40883a0a0e8dcd874ad74db62587
LIBINI_SITE = https://github.com/pcercuei/libini.git
LIBINI_SITE_METHOD = git

LIBINI_INSTALL_STAGING = YES
LIBINI_LICENSE = LGPLv2.1+
LIBINI_LICENSE_FILES = LICENSE.txt

$(eval $(cmake-package))
