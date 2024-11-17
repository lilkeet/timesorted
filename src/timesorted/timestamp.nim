
import
  std/[times]

export times

type
  TimeStamp*[T] = object
    time*: DateTime
    value*: T

template timeGetter*(x: TimeStamp): DateTime =
  x.time
