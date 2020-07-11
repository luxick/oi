# Package

version       = "2.0.1"
author        = "luxick"
description   = "Generic result type for operations that can fail."
license       = "GPL-2.0"
srcDir        = "src"

# Dependencies

requires "nim >= 1.2.4"

task docs, "Generate Docs":
  exec "nim doc --project -o:doc src/op.nim"

task bench, "Runs the benchmark code":
  exec "nim c -r benchmarks/bench.nim"

