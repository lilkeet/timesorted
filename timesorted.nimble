# Package
when defined(nimsuggest):
  import system/nimscript

version       = "0.1.0"
author        = "lilkeet"
description   = "A sequence that is always sorted by time."
license       = "WTFPL"
srcDir        = "src"


# Dependencies

requires "nim >= 2.0.0"

import
  std/[strformat, strutils, setutils, macros, genasts]
from std/os import splitFile

type
  TestModule {.pure.} = enum
    TimeStamp, TimeSorted

proc cleanuptests =
  rmDir "testresults"
  rmDir "nimcache"
  rmFile "outputGotten.txt"

  withDir "tests":
    # rmFile "megatest.nim"
    # rmFile "megatest".toExe

    for category in getCurrentDir().listDirs:
      withDir category:
        for file in getCurrentDir().listFiles:
          let (_, name, extension) = file.splitFile
          if extension == ".nim":
            rmFile name.toExe
            rmFile fmt"{name}.js"


func toDirName(module: TestModule): string =
  result = ($module).toLowerAscii

proc test(module: TestModule) =
  echo fmt"Beginning tests for module '{module}'."
  let args = ["--targets:\"c cpp js objc\"",
    "--megatest:off"
  ]
  let command = fmt"category {module.toDirName}"
  exec &"testament {args.join(\" \")} {command}"


# Tasks
task tests, "Runs all tests":
  for module in TestModule.fullSet:
    test module
  cleanuptests()

macro generateTestTasksForAllModules() =
  result = newStmtList()

  for module in TestModule.fullSet:
    let taskName = ident(fmt"test{module}")
    let taskTemplateCall = genAst(taskName, module):
      task taskName, "Runs all tests for module '$1'" % [($module).toLowerAscii]:
        test module
        cleanuptests()
    result.add taskTemplateCall

generateTestTasksForAllModules()
