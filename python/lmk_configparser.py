#!/usr/bin/python3
# Script to parse a configuration file for the LMK03806 to the expected
# format for the FSBL
# Author: Felipe Torres González (torresfelipex1<AT>gmail.com)
# Date: 2016-10-10
# -----------------------------------------------------------------------------

import sys

if len(sys.argv) < 2:
    print("Usage: lmk_configparser.py <filein> [fileout]")
    exit(1)

file_i = open(sys.argv[1], 'r')
fileout_name = "lmkconfig.txt"
if len(sys.argv) > 1:
    fileout_name = sys.argv[2]
file_o = open(fileout_name, 'w')

registers = []

for line in file_i.readlines():
    raw_line = line.split("\t")
    registers.append([raw_line[0].split(" ")[0], raw_line[1][:-1]])

file_o.write("const struct {int reg; uint32_t val;} tilmk03806_regs_WR[] = {\n")
file_o.write("{1, 0x800201C1},  //POWERDOWN\n")
file_o.write("{1, 0x800001C1},  //POWERUP\n")
file_o.write("{0, 0x80020140},  //RESET\n")
for reg in registers:
    file_o.write("{%s, %s},\n" % (reg[0][1:], reg[1]))
file_o.write("{-1, 0}};\n")

file_i.close()
file_o.close()
print("%s succesfully writed!" % fileout_name)
exit(0)
