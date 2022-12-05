use "collections"
use "package:../shared"

actor Main
  new create(env: Env) =>
    let cm9000 = {
      (src: Array[String] ref, dst: Array[String] ref, cnt: USize)? => 
        for i in Range(0, cnt) do
          dst.push(src.pop()?)
        end
    } val
    let cm9001 = {
      (src: Array[String] ref, dst: Array[String] ref, cnt: USize) => 
        let split = src.size() - cnt
        dst.concat(src.values(), split, cnt)
        src.truncate(split)
    } val

    Reader(env).run(Processor05(
      if try env.args(2)? else "" end == "9001" then cm9001 else cm9000 end
    ))

actor Processor05 is Processor
  let _crane: Crane val
  var _stacks: Array[Array[String]] = []

  new create(crane: Crane val) =>
    _crane = crane

  be process(line: String) => 
    let linetype = line.clone().>strip().substring(0, 1)
    if linetype == "[" then
      _add(line)
    elseif linetype == "m" then
      let parts = line.split()
      try
        _move(parts(1)?.usize()?, parts(3)?.usize()?, parts(5)?.usize()?)
      end
    end
    
  be done(printer: Printer tag) =>
    try 
      var result: String = ""
      for i in Range(0, _stacks.size()) do
        result = result + _stacks(i)?.pop()?
      end
      printer.print(result)
    else 
      printer.print("Something went wrong")  
    end

  fun ref _add(line: String) =>
    let cnt = (line.size() / 4) + 1
    for i in Range(0, (line.size() / 4) + 1) do
      if _stacks.size() <= i then
        _stacks.push([as String:])
      end
      try
        let idx: ISize = ((i * 4) + 1).isize()
        let crate: String val = line.substring(idx, idx + 1)
        if (crate != " ") then 
          _stacks(i)?.unshift(crate)
        end
      end
    end


  fun ref _move(count: USize, from: USize, to: USize) =>
    try
      _crane(_stacks(from - 1)?, _stacks(to - 1)?, count)?
    end

interface Crane
  fun apply(src: Array[String] ref, dst: Array[String] ref, cnt: USize)?