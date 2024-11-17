# timesorted: A Time-Sorted Sequence Library for Nim
**timesorted** is a Nim library that provides an implementation of a sequence of items sorted by time. It is designed to efficiently manage collections of timestamped data, ensuring that items are always maintained in chronological order.

## Features

- **Automatic Sorting**
- **Generic Type Support**
- **Efficient**
- **No Dependencies**

## Installation

Make sure you have Nim installed. You can download it from the [official Nim website](https://nim-lang.org/install.html).

### Using Nimble

If the package is available on Nimble, you can install it using:

```bash
nimble install timesorted
```

### Manual Installation

Clone the repository:

```bash
git clone https://github.com/lilkeet/timesorted
```

Include the `src` directory in your project path or adjust the import statements accordingly.

## Getting Started

### Importing the Library

```nim
import timesortedseq
import timesortedseq/timestamp
```

### Creating a TimeSortedSeq

Create a `TimeSortedSeq` instance parameterized with the type you wish to store. Included is a `TimeStamp` container type that adds a time to any Nim type.

```nim
var x = TimeSortedSeq[TimeStamp[int]]()
```

### Adding Items

Add items to the sequence using the `add` proc. Each `TimeStamp[T]` has a `value` and a `time` field.

```nim
x.add TimeStamp[int](value: 10, time: initDateTime(2024, mFeb, 15))
x.add TimeStamp[int](value: 9, time: initDateTime(2024, mFeb, 16))
x.add TimeStamp[int](value: 8, time: initDateTime(2024, mFeb, 17))
x.add TimeStamp[int](value: 7, time: initDateTime(2024, mFeb, 14))
```

### Accessing Items

Access items using standard indexing. The items are sorted chronologically.

```nim
echo x[0].value  # Outputs: 7
echo x[1].value  # Outputs: 10
echo x[2].value  # Outputs: 9
echo x[3].value  # Outputs: 8
```

### Finding Insertion Index

Use `insertIndexFor` to find the index where a new item should be inserted to maintain chronological order.

```nim
let index = x.insertIndexFor(TimeStamp[int](value: 99, time: initDateTime(2024, mFeb, 15)))
echo index  # Outputs: 1
```

### Finding Items

Use `find` to locate the index of an item in the sequence.

```nim
let idx = x.find(TimeStamp[int](value: 10, time: initDateTime(2024, mFeb, 15)))
echo idx  # Outputs: 1
```

### Iterating Over the Sequence

Iterate over the sequence to access items in chronological order.

```nim
for item in x:
  echo item.value
```

Outputs:

```
7
10
9
8
```

You can also iterate with index:

```nim
for index, item in x:
  echo "Index ", index, ": ", item.value
```

## Custom Types

This library relies on the existance of a symbol called `timeGetter` for any type that may be used with it. Here is a simple example of what this may look like:

```nim
import std/[times]

type MyCustomType = object
  myRecordedData: seq[uint8]
  timeOfRecording: DateTime

template timeGetter(x: MyCustomType): DateTime =
  x.timeOfRecording
```
`timeGetter` informs the library as to how decipher what time an object should be read as.

This library is agnostic to the implementation of a time type, so you can use the standard library's or some other one! All it needs is are `<` and `==`.


## License

This project is licensed under the WTFPL License. See the [LICENSE](license.txt) file for details. This is free software. It comes without any warranty, to the extent permitted by applicable law.

## Contributing

Contributions are welcome! Please open a pull request when you've completed your changes and I will review them.

## Contact

For questions or suggestions, please open an issue on GitHub.
