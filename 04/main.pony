use "package:../shared"

actor Main
  new create(env: Env) =>
    Reader(env).run(Processor04(
      if try env.args(2)? else "" end == "overlap" then
        {(a: Assignment, b: Assignment): Bool => a.overlaps(b)}
      else 
        {(a: Assignment, b: Assignment): Bool => a.contains(b) or a.is_contained_by(b)}
      end
    ))

actor Processor04 is Processor
  let _matcher: AssignmentMatcher val
  var _sum: I64 = 0

  new create(matcher: AssignmentMatcher val) =>
    _matcher = matcher

  be process(line: String) => 
    try 
      (let a, let b) =_assignments(line)?
      if _matcher(a, b) then
        _sum = _sum + 1
      end
    end

  be done(printer: Printer tag) =>
    printer.print(_sum.string())

  fun _assignments(line: String): (Assignment, Assignment)?=> 
    let parts = line.split(",")
    (_assigment(parts(0)?)?, _assigment(parts(1)?)?)

  fun _assigment(part: String): Assignment? =>
    let bounds = part.split("-")
    Assignment(bounds(0)?.u32()?, bounds(1)?.u32()?)

class Assignment
  let _from: U32
  let _to: U32

  new create(from: U32, to: U32) =>
    _from = from
    _to = to

  fun ref contains(other: Assignment): Bool =>
    (_from <= other._from) and (_to >= other._to)

  fun ref is_contained_by(other: Assignment): Bool =>
    other.contains(this)

  fun ref overlaps(other: Assignment): Bool =>
    (_from <= other._to) and (_to >= other._from)

interface AssignmentMatcher
  fun apply(a: Assignment, b: Assignment) : Bool