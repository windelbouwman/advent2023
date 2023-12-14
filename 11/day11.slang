
from std import print, read_file, str_len, str_get
from strlib import split_lines
from datatypes import List

fn main() -> int:
    # let filename = "example.txt"
    let filename = "input.txt"
    let puzzle = load_input(filename)
    part1(puzzle)
    return 0

fn load_input(filename: str) -> Puzzle:
    let galaxies: List[Point] = List()
    let row = 0
    let x_max = 0
    
    for line in split_lines(text: read_file(filename)):
        let col = 0
        let n = str_len(line)
        if n > x_max:
            x_max = n
        while col < n:
            let c = str_get(line, col)
            if c == '#':
                galaxies.append(Point(x: col, y: row))
            col += 1
        row += 1
    let y_max = row
    print("Dimensions: {x_max}x{y_max}")
    return Puzzle(galaxies, x_max, y_max)

struct Point:
    x: int
    y: int

struct Puzzle:
    galaxies: List[Point]
    x_max: int
    y_max: int

struct Pair:
    first: Point
    second: Point

fn part1(puzzle: Puzzle):
    # step 1: Find empty rows and columns
    let x_distances: List[int] = List()
    let y_distances: List[int] = List()

    let d = 0
    while d <= puzzle.x_max or d <= puzzle.y_max:
        let x_empty = true
        let y_empty = true
        for galaxy in puzzle.galaxies:
            if galaxy.x == d:
                x_empty = false
            if galaxy.y == d:
                y_empty = false
        
        if x_empty:
            x_distances.append(1000000)
        else:
            x_distances.append(1)

        if y_empty:
            y_distances.append(1000000)  # Part 1=2, part2=1000000
        else:
            y_distances.append(1)

        d += 1

    # step 2: Find pairs, and distances
    let s = 0
    let index1 = 0
    let n = puzzle.galaxies.len()
    while index1 < n:
        let galaxy1 = puzzle.galaxies.get(index: index1)
        let index2 = index1 + 1
        while index2 < n:
            let galaxy2 = puzzle.galaxies.get(index: index2)

            # Determine distance:
            
            let x1 = galaxy1.x
            let x2 = galaxy2.x
            if x1 > x2:
                x1 = galaxy2.x
                x2 = galaxy1.x
            let dx = 0
            while x1 < x2:
                dx += x_distances.get(index: x1)
                x1 += 1

            let y1 = galaxy1.y
            let y2 = galaxy2.y
            if y1 > y2:
                y1 = galaxy2.y
                y2 = galaxy1.y
            let dy = 0
            while y1 < y2:
                dy += y_distances.get(index: y1)
                y1 += 1
            
            s += dy + dx

            index2 += 1
        index1 += 1
    print("Sum = {s}")
