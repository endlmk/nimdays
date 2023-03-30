import sequtils, tables, strutils

# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

when isMainModule:
  echo("Hello, World!")


type
  Section* = ref object
    hadleLine*, title* :string

proc parseDMI* (source: string) : Table[string, Section] = 
  return initTable[string, Section]()