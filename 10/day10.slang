
from std import read_file, str_get, print, str_len, float_to_str
from strlib import split_lines, find_char
from datatypes import List, Option
from hashmap import HashMap
from shapelib import Point, str_point, Path, shoelace

fn main():
    # let filename = "example.txt"
    # let filename = "example3.txt"  # enclosed = 4
    # let filename = "example4.txt"  # enclosed = 10
    let filename = "input.txt"

    let s_pos = Point(x: 0, y: 0)
    let rows: List[str] = List()
    let r = 0
    for line in split_lines(text: read_file(filename)):
        rows.append(line)
        case find_char(text: line, criterium: is_S):
            None:
                pass
            Some(col):
                s_pos.x = col
                s_pos.y = r
        r += 1
    print("S at {str_point(s_pos)}")
    let maze = Maze(rows)

    part1(maze, s_pos)
    
fn part1(maze: Maze, s_pos: Point):
    # Part 1: 
    # Pipe shapes: '-' '|' 'F' 'L' 'J' '7'
    # Talk a walk around the maze, to determine its length
    let points: List[Point] = List()
    let p1 = s_pos
    let counter = 0
    loop:
        maze.set_distance(p: p1, d: counter)
        points.append(p1)
        case try_move(p: p1, maze):
            Some(p_next):
                p1 = p_next
            None:
                break
        counter += 1
        # print("p1 = {str_point(p1)} {counter}")
    counter += 1 # Last step home
    print("Part 1: {counter / 2}")  # 6613

    # part 2: area enclosed by polygon:
    let s = shoelace(points) - (counter / 2) + 1
    print("Part 2: {float_to_str(s)}")

fn is_S(c?: char) -> bool:
    return c == 'S'

fn copy(p?: Point) -> Point:
    return Point(x: p.x, y: p.y)

fn up(p?: Point) -> Point:
    return Point(x: p.x, y: p.y - 1)

fn down(p?: Point) -> Point:
    return Point(x: p.x, y: p.y + 1)

fn left(p?: Point) -> Point:
    return Point(x: p.x - 1, y: p.y)

fn right(p?: Point) -> Point:
    return Point(x: p.x + 1, y: p.y)

fn try_move(p: Point, maze: Maze) -> Option[Point]:
    case try_up(p, maze):
        Some(p):
            return Option.Some(p)
        None:
            pass

    case try_down(p, maze):
        Some(p):
            return Option.Some(p)
        None:
            pass

    case try_left(p, maze):
        Some(p):
            return Option.Some(p)
        None:
            pass

    return try_right(p, maze)

fn try_up(p: Point, maze: Maze) -> Option[Point]:
    let p2 = up(p)
    let c1 = maze.get_char(p)
    let c2 = maze.get_char(p2)
    if is_up_open(c1) and is_down_open(c2) and not maze.has_score(p2):
        return Option.Some(p2)
    else:
        return Option.None()

fn try_down(p: Point, maze: Maze) -> Option[Point]:
    let p2 = down(p)
    let c1 = maze.get_char(p)
    let c2 = maze.get_char(p2)
    if is_down_open(c1) and is_up_open(c2) and not maze.has_score(p2):
        return Option.Some(p2)
    else:
        return Option.None()

fn is_left_open(c?: char) -> bool:
    return c == '-' or c == '7' or c == 'J' or c == 'S'

fn is_right_open(c?: char) -> bool:
    return c == '-' or c == 'L' or c == 'F' or c == 'S'

fn is_down_open(c?: char) -> bool:
    return c == '|' or c == '7' or c == 'F' or c == 'S'

fn is_up_open(c?: char) -> bool:
    return c == '|' or c == 'L' or c == 'J' or c == 'S'

fn try_left(p: Point, maze: Maze) -> Option[Point]:
    let p2 = left(p)
    let c1 = maze.get_char(p)
    let c2 = maze.get_char(p2)

    if is_left_open(c1) and is_right_open(c2) and not maze.has_score(p2):
        return Option.Some(p2)
    else:
        return Option.None()

fn try_right(p: Point, maze: Maze) -> Option[Point]:
    let p2 = right(p)
    let c1 = maze.get_char(p)
    let c2 = maze.get_char(p2)
    if is_right_open(c1) and is_left_open(c2) and not maze.has_score(p2):
        return Option.Some(p2)
    else:
        return Option.None()

class Maze:
    var rows: List[str]
    var scores: HashMap[int] = HashMap()

    fn get_char(p?: Point) -> char:
        if p.y < 0:
            return '.'
        elif p.y >= rows.len():
            return '.'
        else:
            let row = rows.get(index: p.y)
            if p.x < str_len(row) and p.x >= 0:
                return str_get(row, p.x)
            else:
                return '.'
    
    fn has_score(p?: Point) -> bool:
        let key = str_point(p)
        return scores.contains(key)

    fn set_distance(p: Point, d: int):
        let key = str_point(p)
        scores.insert(key, value: d)
