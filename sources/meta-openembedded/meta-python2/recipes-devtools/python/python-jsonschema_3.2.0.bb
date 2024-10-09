
SUMMARY = "An implementation of JSON Schema validation for Python"
HOMEPAGE = "https://github.com/Julian/jsonschema"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://COPYING;md5=7a60a81c146ec25599a3e1dabb8610a8 \
                    file://json/LICENSE;md5=9d4de43111d33570c8fe49b4cb0e01af"

FILESEXTRAPATHS:prepend := "${THISDIR}/python-jsonschema:"

SRC_URI[md5sum] = "f1a0b5011f05a02a8dee1070cd10a26d"
SRC_URI[sha256sum] = "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"

DEPENDS += "${PYTHON_PN}-vcversioner-native ${PYTHON_PN}-setuptools-scm-native"

PACKAGECONFIG ??= "format"
PACKAGECONFIG[format] = ",,,\
    ${PYTHON_PN}-idna \
    ${PYTHON_PN}-jsonpointer \
    ${PYTHON_PN}-webcolors \
    ${PYTHON_PN}-rfc3987 \
    ${PYTHON_PN}-strict-rfc3339 \
"
PACKAGECONFIG[nongpl] = ",,,\
    ${PYTHON_PN}-idna \
    ${PYTHON_PN}-jsonpointer \
    ${PYTHON_PN}-webcolors \
    ${PYTHON_PN}-rfc3986-validator \
    ${PYTHON_PN}-rfc3339-validator \
"

inherit pypi setuptools

RDEPENDS:${PN} += " \
    ${PYTHON_PN}-argparse \
    ${PYTHON_PN}-attrs \
    ${PYTHON_PN}-contextlib \
    ${PYTHON_PN}-core \
    ${PYTHON_PN}-datetime \
    ${PYTHON_PN}-functools32 \
    ${PYTHON_PN}-importlib-metadata \
    ${PYTHON_PN}-io \
    ${PYTHON_PN}-json \
    ${PYTHON_PN}-lang \
    ${PYTHON_PN}-netclient \
    ${PYTHON_PN}-numbers \
    ${PYTHON_PN}-pkgutil \
    ${PYTHON_PN}-pprint \
    ${PYTHON_PN}-pyrsistent \
    ${PYTHON_PN}-re \
    ${PYTHON_PN}-shell \
    ${PYTHON_PN}-six \
    ${PYTHON_PN}-subprocess \
    ${PYTHON_PN}-unittest \
    ${PYTHON_PN}-setuptools-scm \
    ${PYTHON_PN}-textutils \ 
    ${PYTHON_PN}-zipp \
"

BBCLASSEXTEND = "native nativesdk"

SKIP_RECIPE[python-jsonschema] ?= "${@bb.utils.contains('I_SWEAR_TO_MIGRATE_TO_PYTHON3', 'yes', '', 'python2 is out of support for long time, read https://www.python.org/doc/sunset-python-2/ https://python3statement.org/ and if you really have to temporarily use this, then set I_SWEAR_TO_MIGRATE_TO_PYTHON3 to "yes"', d)}"
