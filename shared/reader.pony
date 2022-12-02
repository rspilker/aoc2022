use "files"

actor Reader is Printer
  let _env: Env

  new create(env: Env) =>
    _env = env

  be run(processor: Processor tag) =>
    let caps = recover val FileCaps.>set(FileRead).>set(FileStat) end

    try
      with file = OpenFile(
        FilePath(FileAuth(_env.root), _env.args(1)?, caps)) as File
      do
        for line in file.lines() do
          processor.process(consume line)
        end
        processor.done(this)
      end
    else
      try
        _env.err.print("Couldn't open " + _env.args(1)?)
      end
    end

  be print(msg: String) =>
    _env.out.print(msg)

trait Printer
  be print(msg: String)

trait Processor
  be process(line: String)
  be done(printer: Printer tag)
