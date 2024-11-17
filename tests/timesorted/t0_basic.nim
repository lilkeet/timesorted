 
discard """
  action: "run"
  batchable: true
  joinable: true
  timeout: 10.0
  targets: "c cpp js objc"
  valgrind: on
  matrix: "-d:useMalloc"
"""

import
  std/[times],
  ../../src/timesorted,
  ../../src/timesorted/[timestamp]


var x = TimeSortedSeq[TimeStamp[int]]()

doAssert x.insertIndexFor(TimeStamp[int](value: 99,
  time: dateTime(2024, mFeb, 15))) == 0

x.add TimeStamp[int](value: 10, time: dateTime(2024, mFeb, 15))
x.add TimeStamp[int](value: 9, time: dateTime(2024, mFeb, 16))
x.add TimeStamp[int](value: 8, time: dateTime(2024, mFeb, 17))
x.add TimeStamp[int](value: 7, time: dateTime(2024, mFeb, 14))

doAssert x[0].value == 7
doAssert x[1].value == 10
doAssert x[2].value == 9
doAssert x[3].value == 8

doAssert x.insertIndexFor(TimeStamp[int](value: 99,
  time: dateTime(2024, mJul, 15))) == x.high + 1


doAssert x.find(TimeStamp[int](value: 10, time: dateTime(2024, mFeb, 15))) ==
  1



const ValuesInOrder = [7, 10, 9, 8]

var i = 0
for item in x:
  doAssert ValuesInOrder[i] == item.value
  inc i

for index, item in x:
  doAssert ValuesInOrder[index] == item.value


x.delete 1

doAssert x.len == 3

doAssert x[0].value == 7
doAssert x[1].value == 9
doAssert x[2].value == 8
