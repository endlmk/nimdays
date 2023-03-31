import sequtils, tables, strutils

# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

when isMainModule:
  echo("Hello, World!")


type
  Section* = ref object
    hadleLine*, title*: string

proc parseDMI*(source: string): Table[string, Section] =
  var sections = initTable[string, Section]()
  let lines = source.splitLines()
  var s: Section = nil
  var isNextTitle = false
  for line in lines:
    if line.isEmptyOrWhitespace:
      continue
    if line.startsWith("Handle"):
      s = new Section
      s.hadleLine = line
      isNextTitle = true
      continue
    if isNextTitle:
      s.title = line
      continue
  sections[s.title] = s
  return sections
