use "collections"
use "package:../shared"

actor Main
  new create(env: Env) =>
    let message = try env.args(1)? else "" end
    let length = try env.args(2)?.usize()? else 23 end
    let buffer = [as U8:]
    try 
      for i in Range(0, message.size()) do
        buffer.push(message.at_offset(i.isize())?)
        if i < (length - 1) then 
          continue
        end
        let unique: HashSet[U8, HashIs[U8]] = HashSet[U8, HashIs[U8]]()
        unique.union(buffer.values())
        if unique.size() == length then
          env.out.print((i + 1).string())
          return
        end
        buffer.shift()?
      end
    end
    env.out.print("No match found")