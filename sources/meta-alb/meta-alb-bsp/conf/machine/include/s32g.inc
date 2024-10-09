require conf/machine/include/s32cc-board.inc
require ${@bb.utils.contains('DISTRO_FEATURES', 'pfe', 'conf/machine/include/s32g-pfe.inc', '', d)}

MACHINEOVERRIDES =. "s32g:"
