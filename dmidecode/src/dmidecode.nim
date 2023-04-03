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

proc parseDMI*(source: string): Table[string, Section] =
  var sections = initTable[string, Section]()
  let lines = source.splitLines()
  var s: Section = nil
  var state: ParseState = noOp
  var key: string
  for line in lines:
    if line.isEmptyOrWhitespace:
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
      if kv.len == 2:
        key = kv[0].strip()
        let value = kv[1].strip()
        s.props[key] = new Property
        if value.isEmptyOrWhitespace():
          state = readList
          continue
        s.props[key].val = value
      continue
    if state == readList:
      s.props[key].items.add(line.strip())
      continue
  sections[s.title] = s
  return sections
