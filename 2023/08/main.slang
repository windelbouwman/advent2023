
from std import read_file, print, str_len, str_slice, str_get
from strlib import split_lines, split_string, trim
from utils import panic
from datatypes import List
from dicttype import Dictionary


pub fn main() -> int:
    # let puzzle = load_data(filename: "example.txt")
    # let puzzle = load_data(filename: "example3.txt")
    let puzzle = load_data(filename: "input.txt")
    part1(puzzle)
    # Part 2 takes too much memory .....
    # part2(puzzle)
    0

fn part1(puzzle: Puzzle):
    print("Part 1")
    let index = 0
    let n = str_len(text: puzzle.sequence)
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
            node = puzzle.left.get(key: node)
        elif cmd == 'R':
            node = puzzle.right.get(key: node)
        else:
            panic("Invalid cmd: {cmd}")
    print("Steps: {steps}")

fn part2(puzzle: Puzzle):
    # start at all nodes ending with A

    # List of simultanious nodes:
    let nodes: List[str] = List()
    for key in puzzle.left:
        if str_get(text: key, index: 2) == 'A':
            print("Key: {key}")
            nodes.append(key)
    
    let index = 0
    let n = str_len(text: puzzle.sequence)
    let steps = 0
    loop:

        let cmd = str_get(text: puzzle.sequence, index)
        index += 1
        if index >= n:
            index = 0

        let new_nodes: List[str] = List()
        let non_z = false
        for node in nodes:
            # print("> {node}")
            let new_node = ""
            if cmd == 'L':
                new_node = puzzle.left.get(key: node)
            elif cmd == 'R':
                new_node = puzzle.right.get(key: node)
            else:
                panic("Invalid cmd: {cmd}")
            if str_get(text: new_node, index: 2) == 'Z':
                print(new_node)
            else:
                non_z = true

            new_nodes.append(new_node)
        nodes = new_nodes
        steps += 1
        
        if not non_z:
            break
    
    print("Part 2 steps: {steps}")

fn load_data(filename: str) -> Puzzle:
    let section = 0
    let sequence = ""
    let left: Dictionary[str] = Dictionary()
    let right: Dictionary[str] = Dictionary()
    for line in split_lines(text: read_file(filename)):
        if str_len(text: line) == 0:
            section += 1
        else:
            if section == 0:
                sequence = line
            elif section == 1:
                let parts = split_string(text: line, sep: '=')
                let source = trim(parts.first())
                let rhs = parts.last()
                let parts2 = split_string(text: str_slice(text: rhs, begin: 2, end: str_len(text: rhs)-1), sep: ',')
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
