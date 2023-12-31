

from std import read_file, print, str_len, float_to_str, str_to_int
from strlib import split_lines, trim, split_string
from datatypes import List
from aoclib import get_numbers, find_min_value, sqrt, round_down, round_up
from functools import zip


fn main():
    # let puzzle = load_data(filename: "example.txt")
    let puzzle = load_data(filename: "input.txt")
    part1(puzzle)
    part2(puzzle)

fn load_data(filename: str) -> Puzzle:
    let lines = split_lines(text: read_file(filename))
    let line1 = lines.get(index: 0)
    let line2 = lines.get(index: 1)
    let times = get_numbers(text: split_string(text: line1, sep: ':').last())
    let distances = get_numbers(text: split_string(text: line2, sep: ':').last())
    return Puzzle(times, distances)

fn part1(puzzle: Puzzle):
    let sum = 1
    for race in get_races(puzzle):
        print("Race: time={race.time}, distance={race.distance}")
        # d = t_hold * (t_total - t_hold)
        analytical(race)
        sum = sum * win_options(race)
    print("Part 1: {sum}")

fn part2(puzzle: Puzzle):
    let time_text = ""
    let distance_text = ""
    for time in puzzle.times:
        time_text = time_text + "{time}"
    for distance in puzzle.distances:
        distance_text = distance_text + "{distance}"
    let race = Race(time: str_to_int(time_text), distance: str_to_int(distance_text))
    print("Big race: time={race.time} distance={race.distance}")
    analytical(race)

fn win_options(race: Race) -> int:
    # Brute force:
    let count = 0
    let t_hold = 1
    while t_hold < race.time:
        if does_win(t_hold, race):
            count += 1
        t_hold += 1
    return count

fn does_win(t_hold: int, race: Race) -> bool:
    let d = t_hold * (race.time - t_hold)
    return d > race.distance

fn analytical(race: Race):
    # d = t_hold * t_total - t_hold*t_hold
    # 0 = - t_hold*t_hold + t_hold * t_total - d
    
    # Use abc-formula:
    # -b  +/- sqrt(b*b -4*a*c)
    # ----------------
    #     2*a
    # a = -1, b = time, c = -distance

    let a = -1
    let b = race.time
    let c = -race.distance
    let r = sqrt(b*b - 4*a*c)
    let x1 = (-b + r) / (2*a)
    let x2 = (-b - r) / (2*a)
    let x1i = round_up(x1)
    let x2i = round_down(x2)

    x1i += 1
    while does_win(t_hold: x1i-1, race):
        x1i -= 1
    print("Does win? x1i={x1i} {bool_to_str(does_win(t_hold: x1i, race))}")
    #x1i -= 1
    #print("Does win? x1i={x1i} {bool_to_str(does_win(t_hold: x1i, race))}")

    x2i -= 1
    while does_win(t_hold: x2i+1, race):
        x2i += 1
    print("Does win? x2i={x2i} {bool_to_str(does_win(t_hold: x2i, race))}")
    # print("Does win? x2i={x2i} {bool_to_str(does_win(t_hold: x2i, race))}")
    
    let margin = x2i - x1i + 1
    print("Part 2, margin={margin}")

fn bool_to_str(value?: bool) -> str:
    if value:
        return "yes"
    else:
        return "no"

fn distance(t_hold: int, t_total: int) -> int:
    # Calculate how far we get when holding 
    let t_drive = t_total - t_hold
    let d = t_hold * (t_total - t_hold)
    return d

struct Puzzle:
    times: List[int]
    distances: List[int]

struct Race:
    time: int
    distance: int

fn get_races(puzzle: Puzzle) -> List[Race]:
    return zip(left: puzzle.times, right: puzzle.distances, merger: create_race)

fn create_race(time: int, distance: int) -> Race:
    return Race(time, distance)
