from std import print, read_file
from utils import panic
from datatypes import List
from vectype import Vector, new_vector
from heapq import PriorityQueue, new_priority_queue_with_capacity
from strlib import split_lines, digit_to_int
from hashmap import HashMap

fn main() -> int:
    # let grid = load_grid(filename: "17/example.txt")
    let grid = load_grid(filename: "17/input.txt")
    part1(grid)
    0

fn cmp_func(a?: State, b?: State) -> bool:
    a.cost < b.cost

fn part1(grid: Grid):
    let s0 = State(row: 0, col: 0, cost: 0, last: Direction.None(), count: 0)
    let queue: PriorityQueue[State] = new_priority_queue_with_capacity(capacity: 10000, f: cmp_func)
    let cache: HashMap[int] = HashMap()
    queue.push(s0)
    let ctx = Context(grid, queue, cache, best: -1)
    while not queue.is_empty():
        let s = queue.pop()
        print("q = {queue.len()}")
        explore(ctx, s, direction: Direction.Up())
        explore(ctx, s, direction: Direction.Down())
        explore(ctx, s, direction: Direction.Left())
        explore(ctx, s, direction: Direction.Right())
    print("Part 1: {ctx.best}")

struct Context:
    grid: Grid
    queue: PriorityQueue[State]
    cache: HashMap[int]
    best: int

fn explore(ctx: Context, s: State, direction: Direction):
    let w = ctx.grid.get_width()
    let h = ctx.grid.get_height()
    let row = case direction:
        Up:
            s.row - 1
        Down:
            s.row + 1
    else:
        s.row
    if row < 0:
        return
    if row >= h:
        return

    let col = case direction:
        Left:
            s.col - 1
        Right:
            s.col + 1
    else:
        s.col
    if col < 0:
        return
    if col >= w:
        return
    
    # Do not go back:
    if is_reverse(direction, s.last):
        return
    
    let count = if is_same(direction, s.last):
        s.count + 1
    else:
        1
    
    # Do not move in the same direction more than 3 times
    if count > 3:
        return

    let cost = s.cost + ctx.grid.get(row, col)

    let key = "{row},{col},{direction_to_string(direction)},{count}"
    let is_cheapest = if ctx.cache.contains(key):
        let old_cost = ctx.cache.get(key)
        # print("Better way -> {key}")
        cost < old_cost
    else:
        true
    
    if is_cheapest:
        ctx.cache.insert(key, value: cost)
        let s1 = State(row, col, cost, last: direction, count)
        ctx.queue.push(s1)

    # Keep track of best option to reach bottom right
    if row == w - 1 and col == h - 1:
        if ctx.best < 0 or (ctx.best > 0 and cost < ctx.best):
            ctx.best = cost
            print("{key} -> {cost}")

fn is_reverse(direction1?: Direction, direction2?: Direction) -> bool:
    """ See if directions are opposite directions """
    case direction1:
        Up:
            case direction2:
                Down:
                    true
            else:
                false
        Down:
            case direction2:
                Up:
                    true
            else:
                false
        Left:
            case direction2:
                Right:
                    true
            else:
                false
        Right:
            case direction2:
                Left:
                    true
            else:
                false
        None:
            false

fn is_same(direction1?: Direction, direction2?: Direction) -> bool:
    """ See if directions are the same directions """
    case direction1:
        Up:
            case direction2:
                Up:
                    true
            else:
                false
        Down:
            case direction2:
                Down:
                    true
            else:
                false
        Left:
            case direction2:
                Left:
                    true
            else:
                false
        Right:
            case direction2:
                Right:
                    true
            else:
                false
        None:
            false

fn direction_to_string(direction: Direction) -> str:
    case direction:
        Up:
            "U"
        Down:
            "D"
        Left:
            "L"
        Right:
            "R"
        None:
            "N"

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
    None

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
