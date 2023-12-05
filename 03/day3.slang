
from std import print, read_file, str_len, str_get, str_slice, str_to_int
from strlib import split_lines, is_digit
from datatypes import List
from utils import panic


fn main():
    # let schematic = load_data(filename: "example.txt")
    let schematic = load_data(filename: "input.txt")
    part1(schematic)
    part2(schematic)

fn part1(schematic: Schematic):
    print("Part 1")
    for symbol in schematic.symbols:
        let row_range1 = Range(begin: symbol.row - 1, end: symbol.row + 1)
        let column_range1 = Range(begin: symbol.column - 1, end: symbol.column + 1)
        for label in schematic.labels:
            let row_range2 = Range(begin: label.row, end: label.row)
            let column_range2 = Range(begin: label.column, end: label.column + str_len("{label.number}") - 1)
            
            if ranges_overlap(row_range1, row_range2):
                if ranges_overlap(column_range1, column_range2):
                    print("touch: {symbol.symbol}: {label.number}")
                    symbol.labels.append(label.number)
    
    let sum = 0
    for symbol in schematic.symbols:
        for label in symbol.labels:
            sum += label
    print("Sum: {sum}")

fn part2(schematic: Schematic):
    let sum = 0
    for symbol in schematic.symbols:
        if symbol.labels.len() == 2:
            let ratio = 1
            for label in symbol.labels:
                ratio = ratio * label
            sum += ratio
    print("Part 2: {sum}")

struct Range:
    begin: int
    end: int

fn overlap(s1: int, end1: int) -> bool:
    pass

fn ranges_overlap(self: Range, other: Range) -> bool:
    return (self.begin <= other.end) and (other.begin <= self.end)

fn load_data(filename: str) -> Schematic:
    let labels: List[Label] = List()
    let symbols: List[Symbol] = List()
    let row = 0
    for line in split_lines(read_file(filename)):
        let n = str_len(line)
        let i = 0
        while i < n:
            let c = str_get(line, i)
            if is_digit(c):
                let j = i
                i += 1
                while i < n:
                    c = str_get(line, i)
                    if is_digit(c):
                        i += 1
                    else:
                        break
                let num = str_slice(line, j, i)
                print("Number {num} at {row},{j}")
                let label = Label(number: str_to_int(num), row, column: j)
                labels.append(label)
            elif c == '.':
                i += 1
            else:
                # Symbol!
                print("Symbol: {c} @ {row},{i}")
                let sym = Symbol(symbol: c, row, column: i, labels: List())
                symbols.append(sym)
                i += 1
        row += 1
    return Schematic(labels, symbols)

struct Symbol:
    symbol: char
    row: int
    column: int
    labels: List[int]

struct Label:
    number: int
    row: int
    column: int

struct Schematic:
    labels: List[Label]
    symbols: List[Symbol]

