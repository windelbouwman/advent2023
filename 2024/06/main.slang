
from std import print, read_file
from vectype import Vector, new_vector
from strlib import split_lines
from utils import panic
from settype import StringSet, Set, new_set
from aoclib import Direction, dir_eq, turn_right, dir_hash

fn main() -> int:
    let grid = load_grid(filename: "06/input.txt")
    # let grid = load_grid(filename: "06/example.txt")
    let s = find_start(grid)
    part1(grid, s)
    part2(grid, s)
    0

fn part1(grid: Grid, s: State):
    s = copy_state(s)
    let visited = StringSet()
    let w = grid.width()
    let h = grid.height()
    loop:
        let key = "{s.row},{s.col}"
        visited.add(key)

        # New position:
        let row = s.row
        let col = s.col
        case s.dir:
            Up:
                row -= 1
            Down:
                row += 1
            Left:
                col -= 1
            Right:
                col += 1
        
        # Check out of grid:
        if row < 0 or row >= h or col < 0 or col >= w:
            break
        let c = grid.get(row, col)
        if c == '.':
            s.row = row
            s.col = col
        elif c == '#':
            s.dir = turn_right(s.dir)
        else:
            panic("Bad char: {c}")
    print("Part1: {visited.len()}")

fn part2(grid: Grid, s: State):
    let state_grid = new_state_grid(grid)
    let s0 = s
    s = copy_state(s)
    let options = StringSet()
    let w = grid.width()
    let h = grid.height()
    loop:
        # New position:
        let row = s.row
        let col = s.col
        case s.dir:
            Up:
                row -= 1
            Down:
                row += 1
            Left:
                col -= 1
            Right:
                col += 1
        
        # Check out of grid:
        if row < 0 or row >= h or col < 0 or col >= w:
            break

        # Check next cell:
        let c = grid.get(row, col)
        if c == '.':
            print("Check loop when blocking {s.row},{s.col}")
            let key = "{row},{col}"
            if not options.contains(key):
                grid.set(row, col, value: '#')
                if would_loop(grid, state_grid, s: s0, block_row: row, block_col: col):
                    options.add(key)
                grid.set(row, col, value: '.')
            s.row = row
            s.col = col
        elif c == '#':
            s.dir = turn_right(s.dir)
        else:
            panic("Bad char: {c}")
    print("Part2: {options.len()}")

fn would_loop(grid: Grid, state_grid: StateGrid, s: State, block_row: int, block_col: int) -> bool:
    """ Check if we would loop if we would need to turn and step once """
    # let visited: Set[State] = new_set(f_hash: state_hash, f_eq: state_eq)
    state_grid.clear()
    let w = grid.width()
    let h = grid.height()
    s = copy_state(s)
    loop:
        if state_grid.contains(s):
            return true
        else:
            state_grid.add(copy_state(s))

        # New position:
        let row = s.row
        let col = s.col
        case s.dir:
            Up:
                row -= 1
            Down:
                row += 1
            Left:
                col -= 1
            Right:
                col += 1

        # Check out of grid:
        if row < 0 or row >= h or col < 0 or col >= w:
            break

        # Check next cell:
        let c = grid.get(row, col)
        if c == '.': # Move ahead
            s.row = row
            s.col = col
        elif c == '#': # Turn
            s.dir = turn_right(s.dir)
        else:
            panic("Bad char: {c}")
    false

fn find_start(grid: Grid) -> State:
    let row = 0
    while row < grid.height():
        let col = 0
        while col < grid.width():
            if grid.get(row, col) == '^':
                let s = State(row, col, dir: Direction.Up())
                grid.set(row, col, value: '.')
                return s
            col += 1
        row += 1
    panic("Start not found!")

fn load_grid(filename: str) -> Grid:
    let rows: Vector[Vector[char]] = new_vector()
    let lines = split_lines(text: read_file(filename))
    for line in lines:
        let row: Vector[char] = new_vector()
        for c in line:
            row.append(c)
        rows.append(row)
    Grid(rows)

struct State:
    row: int
    col: int
    dir: Direction

fn copy_state(s?: State) -> State:
    State(row: s.row, col: s.col, dir: s.dir)

fn state_eq(s1?: State, s2?: State) -> bool:
    s1.row == s2.row and s1.col == s2.col and dir_eq(s1.dir, s2.dir)

fn state_hash(s?: State) -> int:
    s.row * 13 + s.col * 37  + dir_hash(s.dir) * 73

class Grid:
    var rows: Vector[Vector[char]]

    fn width() -> int:
        rows[0].len()
    
    fn height() -> int:
        rows.len()

    fn get(row: int, col: int) -> char:
        rows[row][col]

    fn set(row: int, col: int, value: char):
        rows[row].set(index: col, value)

    fn dump():
        for row in rows:
            let txt = ""
            for c in row:
                txt = txt + "{c}"
            print(txt)
        print("")

fn new_state_grid(grid: Grid) -> StateGrid:
    let rows: Vector[Vector[int]] = new_vector()
    let row_nr = 0
    while row_nr < grid.height():
        let row: Vector[int] = new_vector()
        let col_nr = 0
        while col_nr < grid.width():
            row.append(0)
            col_nr += 1
        rows.append(row)
        row_nr += 1
    StateGrid(rows)

class StateGrid:
    var rows: Vector[Vector[int]]

    fn contains(s?: State) -> bool:
        let value = rows[s.row][s.col]
        let mask = 1 << dir_hash(s.dir)
        value & mask != 0

    fn add(s?: State):
        let mask = 1 << dir_hash(s.dir)
        let value = rows[s.row][s.col]
        value = value | mask
        rows[s.row].set(index: s.col, value)

    fn clear():
        for row in rows:
            let index = 0
            while index < row.len():
                row.set(index, value: 0)
                index += 1
