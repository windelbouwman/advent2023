
from std import read_file, print, str_len
from strlib import split_lines, trim, split_string
from datatypes import List
from aoclib import get_numbers, find_min_value

fn main():
    # let puzzle = load_data("example.txt")
    let puzzle = load_data(filename: "input.txt")
    part1(puzzle)
    # part2(mappings)

fn load_data(filename: str) -> Puzzle:
    let state = 0
    let seeds = List()
    let mapname = ""
    let ranges: List[Range] = List()
    let mappings: List[Mapping] = List()
    for line in split_lines(text: read_file(filename)):
        switch state:
            0:
                print("Seed: {line}")
                seeds = get_numbers(text: split_string(text: line, sep: ':').get(index: 1))
                state = 1
            1:
                state = 2
            2:
                mapname = line
                ranges = List()
                print("Map: {mapname}")
                state = 3
            3:
                if str_len(line) == 0:
                    state = 2
                    mappings.append(Mapping(name: mapname, ranges))
                else:
                    print("range: {line}")
                    let numbers = get_numbers(text: line)
                    ranges.append(Range(destination: numbers.get(index: 0), source: numbers.get(index: 1), length: numbers.get(index: 2)))
        else:
            pass

    if state == 3:
        mappings.append(Mapping(name: mapname, ranges))

    return Puzzle(seeds, mappings)

fn part1(puzzle: Puzzle):
    let locations: List[int] = List()
    for seed in puzzle.seeds:
        print("seed: {seed}")
        for mapping in puzzle.mappings:
            seed = map_value(value: seed, mapping)
            print("    {mapping.name} -> {seed}")
        locations.append(seed)
    
    let smallest_location = find_min_value(values: locations)
    print("part 1: {smallest_location}")


struct Puzzle:
    seeds: List[int]
    mappings: List[Mapping]

struct Range:
    destination: int
    source: int
    length: int

struct Mapping:
    name: str
    ranges: List[Range]

fn map_value(value: int, mapping: Mapping) -> int:
    for range in mapping.ranges:
        if range.source <= value and value < range.source + range.length:
            let offset = value - range.source
            return range.destination + offset
    return value
