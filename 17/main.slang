from std import print, read_file
from utils import panic
from datatypes import List
from vectype import Vector, new_vector
from heapq import PriorityQueue, new_priority_queue_with_capacity
from strlib import split_lines, digit_to_int
from hashmap import HashMap

fn main() -> int:
    # let grid = load_grid(filename: "17/example.txt")
    # let grid = load_grid(filename: "17/example2.txt")
    let grid = load_grid(filename: "17/input.txt")
    part1(grid)
    0

fn cmp_func(a?: State, b?: State) -> bool:
    a.cost < b.cost

fn part1(grid: Grid):
    let s1 = State(row: 4, col: 0, cost: grid.get(row: 1, col: 0) + grid.get(row: 2, col: 0) + grid.get(row: 3, col: 0) + grid.get(row: 4, col: 0), last: Direction.Down(), count: 4)
    let s2 = State(row: 0, col: 4, cost: grid.get(row: 0, col: 1) + grid.get(row: 0, col: 2) + grid.get(row: 0, col: 3) + grid.get(row: 0, col: 4), last: Direction.Right(), count: 4)
    let queue: PriorityQueue[State] = new_priority_queue_with_capacity(capacity: 10000, f: cmp_func)
    let cache: HashMap[int] = HashMap()
    let ctx = Context(grid, queue, cache, best: 0)
    push_state(ctx, s1)
    push_state(ctx, s2)
    while not queue.is_empty():
        let s = queue.pop()
        print("q = {queue.len()}")
        explore2(ctx, s)
    print("Part 2: {ctx.best}")

struct Context:
    grid: Grid
    queue: PriorityQueue[State]
    cache: HashMap[int]
    best: int

fn explore2(ctx: Context, s: State):
    let w = ctx.grid.get_width()
    let h = ctx.grid.get_height()

    case s.last:
        Up:
            # Try up:
            if s.row > 0 and s.count < 10:
                let cost = s.cost + ctx.grid.get(row: s.row - 1, col: s.col)
                let s1 = State(row: s.row - 1, col: s.col, cost, last: Direction.Up(), count: s.count + 1)
                push_state(ctx, s1)
            try_turn_left(ctx, s)
            try_turn_right(ctx, s)
        Down:
            # Try down:
            if s.row + 1 < h and s.count < 10:
                let cost = s.cost + ctx.grid.get(row: s.row + 1, col: s.col)
                let s1 = State(row: s.row + 1, col: s.col, cost, last: Direction.Down(), count: s.count + 1)
                push_state(ctx, s1)
            try_turn_left(ctx, s)
            try_turn_right(ctx, s)
        Left:
            # Try left:
            if s.col > 0 and s.count < 10:
                let cost = s.cost + ctx.grid.get(row: s.row, col: s.col - 1)
                let s1 = State(row: s.row, col: s.col - 1, cost, last: Direction.Left(), count: s.count + 1)
                push_state(ctx, s1)
            try_turn_up(ctx, s)
            try_turn_down(ctx, s)
        Right:
            # Try right:
            if s.col + 1 < w and s.count < 10:
                let cost = s.cost + ctx.grid.get(row: s.row, col: s.col + 1)
                let s1 = State(row: s.row, col: s.col + 1, cost, last: Direction.Right(), count: s.count + 1)
                push_state(ctx, s1)
            try_turn_up(ctx, s)
            try_turn_down(ctx, s)

fn try_turn_up(ctx: Context, s: State):
    if s.row > 3:
        let cost = s.cost + ctx.grid.get(row: s.row - 1, col: s.col) + ctx.grid.get(row: s.row - 2, col: s.col) + ctx.grid.get(row: s.row - 3, col: s.col) + ctx.grid.get(row: s.row - 4, col: s.col)
        let s1 = State(row: s.row - 4, col: s.col, cost, last: Direction.Up(), count: 4)
        push_state(ctx, s1)

fn try_turn_down(ctx: Context, s: State):
    let h = ctx.grid.get_height()
    if s.row + 4 < h:
        let cost = s.cost + ctx.grid.get(row: s.row + 1, col: s.col) + ctx.grid.get(row: s.row + 2, col: s.col) + ctx.grid.get(row: s.row + 3, col: s.col) + ctx.grid.get(row: s.row + 4, col: s.col)
        let s1 = State(row: s.row + 4, col: s.col, cost, last: Direction.Down(), count: 4)
        push_state(ctx, s1)

fn try_turn_left(ctx: Context, s: State):
    if s.col > 3:
        let cost = s.cost + ctx.grid.get(row: s.row, col: s.col - 1) + ctx.grid.get(row: s.row, col: s.col - 2) + ctx.grid.get(row: s.row, col: s.col - 3) + ctx.grid.get(row: s.row, col: s.col - 4)
        let s1 = State(row: s.row, col: s.col - 4, cost, last: Direction.Left(), count: 4)
        push_state(ctx, s1)

fn try_turn_right(ctx: Context, s: State):
    let w = ctx.grid.get_width()
    if s.col + 4 < w:
        let cost = s.cost + ctx.grid.get(row: s.row, col: s.col + 1) + ctx.grid.get(row: s.row, col: s.col + 2) + ctx.grid.get(row: s.row, col: s.col + 3) + ctx.grid.get(row: s.row, col: s.col + 4)
        let s1 = State(row: s.row, col: s.col + 4, cost, last: Direction.Right(), count: 4)
        push_state(ctx, s1)

fn push_state(ctx: Context, s?: State):
    let key = "{s.row},{s.col},{direction_to_string(s.last)},{s.count}"
    # print("{key} => {s.cost}")
    let is_cheapest = if ctx.cache.contains(key):
        # print("Better way -> {key}")
        s.cost < ctx.cache.get(key)
    else:
        true
    
    if is_cheapest:
        ctx.cache.insert(key, value: s.cost)
        ctx.queue.push(s)

    # Keep track of best option to reach bottom right
    let w = ctx.grid.get_width()
    let h = ctx.grid.get_height()
    if s.row == h - 1 and s.col == w - 1:
        if ctx.best == 0 or (ctx.best > 0 and s.cost < ctx.best):
            ctx.best = s.cost
            print("{key} -> {s.cost}")
    pass

struct State:
    row: int
    col: int
    cost: int
    last: Direction
    count: int

enum Direction:
    Up
    Down
    Left
    Right

fn direction_to_string(direction?: Direction) -> str:
    case direction:
        Up:
            "U"
        Down:
            "D"
        Left:
            "L"
        Right:
            "R"

fn load_grid(filename: str) -> Grid:
    let rows: Vector[Vector[int]] = new_vector()
    let lines = split_lines(text: read_file(filename))
    for line in lines:
        let row: Vector[int] = new_vector()
        for c in line:
            row.append(digit_to_int(c))
        rows.append(row)
    Grid(rows)

class Grid:
    var rows: Vector[Vector[int]]

    fn get_width() -> int:
        rows[0].len()
    
    fn get_height() -> int:
        rows.len()

    fn get(row: int, col: int) -> int:
        rows[row][col]
