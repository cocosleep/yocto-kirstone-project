#
# This class is meant to help to build a binary flash image for the user
# that will directly lead to a bootable system.
# While it is somewhat unlikely to be used directly, it could be used
# directly. Currently the users are the flashimage and sd card classes.
#
# It provides generic helper functions that permit filling a
# destination with binary data and checking for overlaps.
#
# It also supports the necessary checks for a flash that is logically
# split in half by address twiddling, which has been called "bank 4"
# by NXP [Freescale] for some of the evaluation boards.
#
# The size limit for images that can be worked with should be defined
# by the capability of "printf" to print a "%u" or "%x" integer only.
#
# Heinz Wrobel <Heinz.Wrobel@nxp.com>
#
DEPENDS += "bc-native"

RAWIMAGE_DD_BS_DEFAULT ?= "134217728"

rawimage_initutils () {
        # Example for a straight 64MiB flash:
        # rawimage_initutils("flash image", "no", 67108864)
        rawimage_typename="$1"
        rawimage_bank4="$2"
        rawimage_fullsize="$3"

        rawimage_regions=""
}

rawimage_add_region () {
        # Add a new flash region for writing an image
        # Check if there is an overlap with an existing region
        start="$1"
        size="$2"
        name="$3"

        end=$(printf "%s + %s\n" ${start} ${size} | bc)

        for entry in ${rawimage_regions}; do
                start0=$(printf "%s" ${entry} | cut -d '-' -f1)
                end0=$(printf "%s" ${entry} | cut -d '-' -f2)
                startearly=$(printf "x=0;if(%s < %s)x=1;x\n" ${start} ${end0} | bc);
                endlate=$(printf "x=0;if(%s > %s)x=1;x\n" ${end} ${start0} | bc);
                if [ "${startearly}" -eq 1 ] && [ "${endlate}" -eq 1 ]; then
                        error_str=$(printf "%s (0x%x - 0x%x) overlaps with (0x%x - 0x%x)" "${name}" "${start}" "${end}" "${start0}" "${end0}")
                        bberror "${rawimage_typename} regions overlap: ${error_str}"
                        exit 1
                fi
        done

        # Save regions in string using format:
        #     start0-end0 start1-end1 ...
        rawimage_regions="${rawimage_regions} ${start}-${end}"
}

#
# Create an image that can by written to flash directly
#
rawimage_generate_entry() {
        infile="$1"
        outfile="$2"
        offsetname="$3"
        offsetvar="$4"
        ddopts="$5"
        filesize="$6"

        bbdebug 1 "rawimage_generate_entry \"${infile}\" \"${outfile}\" \"${offsetname}\" \"${offsetvar}\""
        if [ -n "${infile}" ]; then
                if [ -z "${offsetvar}" ]; then
                    bberror "${infile} is set but offset ${offsetname} for this file inside the ${rawimage_typename} is undefined"
                    exit 1
                fi

                offset=$(printf "%u\n" "${offsetvar}" | bc)
                if [ -z "${offset}" ]; then
                        bberror "${offsetname} is undefined. To use the ${rawimage_typename} it needs to be defined as byte offset."
                        exit 1
                fi

                if [ -z "${filesize}" ]; then
                        filesize=$(stat -L -c "%s" "${infile}")
                fi
                offsetmax=$(printf "%s + %s\n" ${offset} ${filesize} | bc)

                if [ "${rawimage_bank4}" = "yes" ]; then
                        xorhalf=$(printf "%s / 2\n" ${rawimage_fullsize} | bc)
                        offsetbank4=$(printf "(%d + %d) %% %d\n" ${offset} ${xorhalf} ${rawimage_fullsize} | bc)
                        tmp=$(printf "x=0;if(%s < %s)x=1;x\n" ${offset} ${xorhalf} | bc);
                        if [ ${tmp} -eq "1" ]; then
                                tmp=$(printf "x=0;if(%s > %s)x=1;x\n" ${offsetmax} ${xorhalf} | bc);
                                if [ ${tmp} -eq "1" ]; then
                                        error_str=$(printf "%s is reaching into bank 4 range to 0x%x. Please reduce size or turn off bank 4 in your configuration!" "${infile}" ${offsetmax})
                                        bberror "${error_str}"
                                        exit 1
                                fi
                        fi
                fi

                tmp=$(printf "x=0;if(%s > %s)x=1;x\n" ${offsetmax} ${rawimage_fullsize} | bc);
                if [ ${tmp} -eq "1" ]; then
                        error_str=$(printf "%s is reaching beyond the end of the ${rawimage_typename} to 0x%x!" "${infile}" ${offsetmax})
                        bberror "${error_str}"
                        exit 1
                fi

                # We permit custom options to also handle partial files.
                # Default is to copy the full file however with a
                # reasonable block size.
                if [ -z "${ddopts}" ]; then
                        ddopts="bs=${RAWIMAGE_DD_BS_DEFAULT}"
                fi

                # add region for checking overlap with existing ones
                rawimage_add_region "${offset}" "${filesize}" "${offsetname}"

                hexoffset=$(printf "0x%x" ${offset})
                bbnote "Generating ${rawimage_typename} entry at ${hexoffset} for ${infile}"

                dd "if=${infile}" "of=${outfile}" conv=notrunc oflag=seek_bytes seek=${offset} ${ddopts}
                if [ "${rawimage_bank4}" = "yes" ]; then
                        rawimage_add_region "${offsetbank4}" "${filesize}" "${offsetname}"

                        hexoffsetbank4=$(printf "0x%x" ${offsetbank4})
                        bbnote "Generating ${rawimage_typename} entry at ${hexoffsetbank4} for ${infile} in bank 4"
                        dd "if=${infile}" "of=${outfile}" conv=notrunc oflag=seek_bytes seek=${offsetbank4} ${ddopts}
                fi
        fi
}
