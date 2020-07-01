# Package

version       = "0.1.0"
author        = "luxick"
description   = "Generic result type for operations that can fail."
license       = "GPL-2.0"
srcDir        = "src"

# Dependencies

requires "nim >= 1.2.4"

task genDocs, "Generate Docs":
  exec "nim doc --project -o:doc src/op.nim"
