import sequtils, tables, strutils

# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

when isMainModule:
  echo("Hello, World!")

type Property* = ref object
  val*: string
  items*: seq[string]

type
  Section* = ref object
    hadleLine*, title*: string
    props*: Table[string, Property]

type ParseState = enum
  noOp, sectionName, readKeyValue, readList

proc getIdentLevel(line: string): int =
  for i, c in pairs(line):
    if not c.isSpaceAscii():
      return i
  return 0

proc parseDMI*(source: string): Table[string, Section] =
  var sections = initTable[string, Section]()
  let lines = source.splitLines()
  var s: Section = nil
  var state: ParseState = noOp
  var key, value: string
  for i, line in pairs(lines):
    if line.isEmptyOrWhitespace:
      if s != nil:
        sections[s.title] = s
      continue
    if line.startsWith("Handle"):
      s = new Section
      s.hadleLine = line
      s.props = initTable[string, Property]()
      state = sectionName
      continue
    if state == sectionName:
      s.title = line
      state = readKeyValue
      continue
    if state == readKeyValue:
      let kv = line.strip().split(':')
      key = kv[0].strip()
      if kv.len == 2:
        value = kv[1].strip()
      else:
        value = ""
      s.props[key] = new Property
      s.props[key].val = value
      s.props[key].items = newSeq[string]()
      if i < len(lines) - 1 and getIdentLevel(line) < getIdentLevel(lines[i + 1]):
        state = readList
        continue
      continue
    if state == readList:
      s.props[key].items.add(line.strip())
      if i < len(lines) - 1 and getIdentLevel(line) > getIdentLevel(lines[i + 1]):
        state = readKeyValue
        continue
      continue
  return sections
