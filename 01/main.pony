use "collections"
use "package:../shared"

actor Main
  new create(env: Env) =>
    Reader(env).run(Processor01(try env.args(2)?.i8()? else 1 end))

actor Processor01 is Processor
  let _top: I8
  var _elves: List[I64] = List[I64]()
  var _current: I64 = 0

  new create(top: I8) =>
    _top = top

  be process(line: String) => 
    if (line.size() == 0) then
      _elves.push(_current)
      _current = 0
    else
      _current = _current + try line.i64()? else -100000000 end
    end

  be done(printer: Printer tag) =>
    if (_current != 0) then
      _elves.push(_current)
    end
    
    let sorted = Sort[List[I64], I64](_elves)

    var i: I8 = _top
    var sum: I64 = 0
    while i > 0 do
      sum = sum + try sorted.pop()? else -1000000 end
      i = i - 1
    end

    printer.print(sum.string())