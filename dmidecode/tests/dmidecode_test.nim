import tables, unittest
import ../src/dmidecode

let sample = """
Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
"""

var obj : Table[string, dmidecode.Section]
obj = dmidecode.parseDMI(sample)

check obj.len == 1