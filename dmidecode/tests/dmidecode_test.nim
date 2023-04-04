import tables, unittest
import ../src/dmidecode

let sample = """
Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
    Vendor: LENOVO
    Characteristics:
        PCI is supported
        BIOS is upgradeable
    BIOS Revision: 1.40
        Targeted content distribution is supported
"""

var obj: Table[string, dmidecode.Section]
obj = dmidecode.parseDMI(sample)

check obj.len == 1
check obj.hasKey("BIOS Information")
check obj["BIOS Information"].title == "BIOS Information"
check obj["BIOS Information"].hadleLine == "Handle 0x0000, DMI type 0, 24 bytes"

check obj["BIOS Information"].props.len == 3
check obj["BIOS Information"].props["Vendor"].val == "LENOVO"
check obj["BIOS Information"].props["Characteristics"].items == [
    "PCI is supported", "BIOS is upgradeable"]
check obj["BIOS Information"].props["BIOS Revision"].val == "1.40"
check obj["BIOS Information"].props["BIOS Revision"].items == ["Targeted content distribution is supported"]
