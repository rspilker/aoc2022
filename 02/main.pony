use "package:../shared"

actor Main
  let _scorecard1: Array[I32] val = [
    3 + 1 ; 6 + 2 ; 0 + 3
    0 + 1 ; 3 + 2 ; 6 + 3
    6 + 1 ; 0 + 2 ; 3 + 3
  ]
  let _scorecard2: Array[I32] val = [
    3 + 0 ; 1 + 3 ; 2 + 6
    1 + 0 ; 2 + 3 ; 3 + 6
    2 + 0 ; 3 + 3 ; 1 + 6
  ]

  new create(env: Env) =>
    Reader(env).run(Processor02(_card(env)))
  
  fun _card(env: Env): Array[I32 val] val =>
    if try env.args(2)? else "" end == "alt" then
      return _scorecard2
    end
    _scorecard1

actor Processor02 is Processor
  let _scorecard: Array[I32] val
  var _sum: I32 = 0

  new create(scorecard: Array[I32] val) =>
    _scorecard = scorecard

  be process(line: String) => 
    if (line.size() != 0) then
      _sum = _sum + _score(line)
    end

  be done(printer: Printer tag) =>
    printer.print(_sum.string())

  fun _score(line: String): I32 =>
    let moves = line.split()
    try
      let theirs: U32 val = "ABC".find(moves(0)?)?.u32()
      let mine: U32 val = "XYZ".find(moves(1)?)?.u32()
      return _scorecard(((theirs * 3) + mine).usize())?
    else
      return -1000000
    end
