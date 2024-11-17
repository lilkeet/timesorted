
##[Implementation of a sequence of items that are sorted by time.]##

import
  std/[times, algorithm]

export times

{.experimental: "strictFuncs".}
{.experimental: "strictDefs".}

type
  TimeSortedSeq*[T] = object
    ## A sequence that is always sorted by time.
    data: seq[T]

converter toSeq*[T](x: TimeSortedSeq[T]): lent seq[T] =
  result = x.data

func `$`*(x: TimeSortedSeq): string =
  result = $x.toSeq

func newTimeSortedSeqOfCap*[T](cap: Natural): TimeSortedSeq[T] {.inline.} =
  result = TimeSortedSeq(data: newSeqOfCap[T](cap))

func `[]`*[T](
    host: TimeSortedSeq[T]; index: int|BackwardsIndex
  ): lent T {.inline.}=
  result = host.data[index]

func `[]`[T; U, V: Ordinal](
    host: TimeSortedSeq[T]; x: HSlice[U, V]
  ): seq[T] {.inline.} =
  result = host.data[x]

func len*(host: TimeSortedSeq): int {.inline.} =
  host.data.len

func high*(host: TimeSortedSeq): int {.inline.} =
  host.data.high


proc insertIndexFor*[T](host: TimeSortedSeq[T]; potentialNewVal: T): int =
  ## Returns the index that the `potentialNewVal` would be inserted at.
  ##
  ## Requires that there is some proc, func, template, or macro called
  ## `timeGetter` for type `T` that returns some `DateTime`-like type.
  mixin timeGetter

  when not compiles(timeGetter(potentialNewVal)):
    {.error: "Please implement a proc, func, template, or macro called " &
       "`timeGetter` for your type that returns some datatype that " &
       "represents a point in time before using a TimeSortedSeq.".}

  result = 0

  var count = host.len
  var step, pos: int
  while count != 0:
    step = count shr 1
    pos = result + step
    if timeGetter(host[pos]) < timeGetter(potentialNewVal):
      result = pos + 1
      count -= step + 1
    else:
      count = step


proc add*[T](host: var TimeSortedSeq[T]; newVal: sink T) {.inline.} =
  host.data.insert newVal, host.insertIndexFor(newVal)

proc find*[T](host: TimeSortedSeq[T]; val: T): int {.inline.} =
  ## Returns the index that `val` is at or `-1` if it is not present.
  ##
  ## Requires that there is some proc, func, template, or macro called
  ## `timeGetter` for type `T` that returns some `DateTime`-like type.
  mixin timeGetter

  when not compiles(timeGetter(val)):
    {.error: "Please implement a proc, func, template, or macro called " &
       "`timeGetter` for your type that returns some datatype that " &
       "represents a point in time before using a TimeSortedSeq.".}

  proc myCmp(x, y: T): int =
    if timeGetter(x) == timeGetter(y): return 0
    if timeGetter(x) < timeGetter(y): return -1
    return 1

  result = host.toSeq.binarySearch(val, myCmp)


iterator items*[T](host: TimeSortedSeq[T]): lent T =
  for x in host.data:
    yield x

iterator pairs*[T](host: TimeSortedSeq[T]): (int, lent T) =
  for index, x in host.data:
    yield (index, x)
