import tables, unittest
import ../src/dmidecode

let sample = """
Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
    Vendor: LENOVO
    Characteristics:
        PCI is supported
        BIOS is upgradeable
"""

var obj: Table[string, dmidecode.Section]
obj = dmidecode.parseDMI(sample)

check obj.len == 1
check obj.hasKey("BIOS Information")
check obj["BIOS Information"].title == "BIOS Information"
check obj["BIOS Information"].hadleLine == "Handle 0x0000, DMI type 0, 24 bytes"

check obj["BIOS Information"].props.len == 2
check obj["BIOS Information"].props["Vendor"].val == "LENOVO"
check obj["BIOS Information"].props["Characteristics"].items == [
    "PCI is supported", "BIOS is upgradeable"]
