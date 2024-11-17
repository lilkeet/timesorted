 
discard """
  action: "run"
  batchable: true
  joinable: true
  timeout: 2.0
  targets: "c cpp js objc"
  valgrind: off
  matrix: ""
"""

import
  std/[times],
  ../../src/timesorted/[timestamp]


var x = TimeStamp[int](value: 10, time: dateTime(2024, mFeb, 15))

doAssert x.value == 10
doAssert x.time == dateTime(2024, mFeb, 15)

doAssert timeGetter(x) == x.time

x.value = 15
x.time = dateTime(1875, mDec, 15)

doAssert x.value == 15
doAssert x.time == dateTime(1875, mDec, 15)
