 
from std import read_file, ord, str_len, print, str_slice
from utils import assert
from strlib import split_lines, split_string, str_to_int
from datatypes import List
from math import modulo

fn main():
    # let filename = "example.txt"
    let filename = "input.txt"
    let puzzle = load_puzzle(filename)
    # part1(puzzle)
    part2(puzzle)

fn load_puzzle(filename: str) -> Puzzle:
    let lines = split_lines(text: read_file(filename))
    let line = lines.get(index: 0)
    let items = split_string(text: line, sep: ',')
    return Puzzle(items)

fn part1(puzzle: Puzzle):
    let s = 0
    for item in puzzle.items:
        s += hash(text: item)
    print("Part 1: {s}")

fn part2(puzzle: Puzzle):
    let hash_map = HashMap()
    hash_map.init()
    for text in puzzle.items:
        let parts = split_string(text, sep: '=')
        if parts.len() == 2:
            # Insert!
            let label = parts.get(index: 0)
            let strength = str_to_int(parts.get(index: 1))
            print("Insert {label} = {strength}")
            hash_map.insert(label, strength)
        else:
            let n = str_len(text)
            let label = str_slice(text, begin: 0, end: n - 1)
            print("Remove {label}")
            hash_map.delete(label)
    
    let s = 0
    let i = 0
    for box in hash_map.boxes:
        i += 1
        let j = 0
        for lens in box.lenses:
            j += 1
            let power = i * j * lens.strength
            s += power
    print("Part 2: {s}")

struct Lens:
    label: str
    strength: int

struct Box:
    lenses: List[Lens]

class HashMap:
    var boxes: List[Box] = List()

    fn init():
        let i = 0
        while i < 256:
            i += 1
            boxes.append(Box(lenses: List()))
        assert(condition: boxes.len() == 256, message: "Expect 256 boxes")
    
    fn insert(label: str, strength: int):
        let index = hash(text: label)
        let box = boxes.get(index)
        for lens in box.lenses:
            if lens.label == label:
                lens.strength = strength
                return
        box.lenses.append(Lens(label, strength))
    
    fn delete(label: str):
        let index = hash(text: label)
        let box = boxes.get(index)
        let del_index = -1
        let i = 0
        for lens in box.lenses:
            if lens.label == label:
                del_index = i
                break
            else:
                i += 1
        if del_index >= 0:
            box.lenses.delete_at(index: del_index)


fn hash(text: str) -> int:
    let h = 0
    for c in text:
        h = (h + ord(c)) * 17
        h = modulo(value: h, divisor: 256)
    return h

struct Puzzle:
    items: List[str]
