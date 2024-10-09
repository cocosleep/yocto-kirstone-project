# Provides common settings for S32CC boards, emulation and simulation models
require conf/machine/include/s32-base.inc
require conf/machine/include/arm/armv8a/tune-cortexa53.inc

SOC_FAMILY:append = ":s32cc"

DEFAULTTUNE:s32cc ?= "cortexa53-crypto"