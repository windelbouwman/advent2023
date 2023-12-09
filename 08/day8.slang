
from std import read_file, print, str_len, str_slice, str_get
from strlib import split_lines, split_string, trim
from utils import panic
from datatypes import Dictionary, option_unwrap


fn main():
    # let puzzle = load_data(filename: "example.txt")
    # let puzzle = load_data(filename: "example2.txt")
    let puzzle = load_data(filename: "input.txt")
    part1(puzzle)

fn part1(puzzle: Puzzle):
    print("Part 1")
    let index = 0
    let n = str_len(puzzle.sequence)
    let node = "AAA"
    let steps = 0
    while not (node == "ZZZ"):
        let cmd = str_get(text: puzzle.sequence, index)
        index += 1
        if index >= n:
            index = 0
        
        print(node)
        
        steps += 1
        if cmd == 'L':
            node = option_unwrap(puzzle.left.get(key: node))
        elif cmd == 'R':
            node = option_unwrap(puzzle.right.get(key: node))
        else:
            panic("Invalid cmd: {cmd}")
    print("Steps: {steps}")

fn load_data(filename: str) -> Puzzle:
    let section = 0
    let sequence = ""
    let left: Dictionary[str] = Dictionary()
    let right: Dictionary[str] = Dictionary()
    for line in split_lines(text: read_file(filename)):
        if str_len(line) == 0:
            section += 1
        else:
            if section == 0:
                sequence = line
            elif section == 1:
                let parts = split_string(text: line, sep: '=')
                let source = trim(parts.first())
                let rhs = parts.last()
                let parts2 = split_string(text: str_slice(text: rhs, 2, str_len(rhs)-1), sep: ',')
                let a = trim(parts2.first())
                let b = trim(parts2.last())
                # print(" |{source}| -> [{a}] [{b}]")
                left.insert(key: source, value: a)
                right.insert(key: source, value: b)
            else:
                print(line)
    return Puzzle(sequence, left, right)

struct Puzzle:
    sequence: str
    left: Dictionary[str]
    right: Dictionary[str]