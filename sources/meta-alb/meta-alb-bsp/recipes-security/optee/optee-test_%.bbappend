require optee-nxp.inc

MAJ_VER = "${@oe.utils.trim_version("${PV}", 2)}"

SRCREV = "0ba83ceb55a3c86620b4df6537dd0ace722401ca"

URL ?= "git://github.com/nxp-auto-linux/optee_test.git;protocol=https"
BRANCH ?= "${RELEASE_BASE}-${MAJ_VER}"
SRC_URI = "\
    ${URL};branch=${BRANCH} \
    file://run-ptest \
"
