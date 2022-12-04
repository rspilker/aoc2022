use "collections"
use "package:../shared"

actor Main
  new create(env: Env) =>
    Reader(env).run(Processor03(try env.args(2)?.u32()? else 1 end))

actor Processor03 is Processor
  let _each: U32
  let _lines: Array[String] = []
  var _cnt: U32 = 0
  var _sum: I32 = 0

  new create(each: U32) =>
    _each = each

  be process(line: String) => 
    if _each == 1 then
      _sum = _sum + _map(_common(_split(line)))
    else
      let slot = (_cnt = _cnt + 1) % _each
      _lines.push(line)
      if slot == (_each - 1) then 
        _sum = _sum + _map(_common(_lines.clone()))
        _lines.clear()
      end
    end


  be done(printer: Printer tag) =>
    printer.print(_sum.string())

  fun _split(line: String): Array[String] =>
    let count: ISize val = (line.size() / 2).isize()
    [line.substring(0, count); line.substring(count)]

  fun ref _common(sets: Array[String]): U8 => 
    try
      var candidates = _set(sets(0)?)
      for i in Range(1, sets.size()) do
        candidates = candidates and _set(sets(i)?)
      end
      candidates.values().next()?
    else
      255
    end
  
  fun _set(str: String): HashSet[U8, HashIs[U8]] =>
    let res = HashSet[U8, HashIs[U8]](str.size())
    res.union(str.values())
    res
      

  fun _map(x: U8): I32 =>
    let lower: I32 = x.i32() - 'a'
    if lower < 0 then
      (x.i32() - 'A') + 27
    else
      lower + 1
    end
