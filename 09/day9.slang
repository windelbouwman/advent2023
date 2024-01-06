
from std import read_file, print
from strlib import split_lines
from aoclib import get_numbers
from functools import all
from utils import assert
from datatypes import List

fn main():
    # let filename = "example.txt"
    let filename = "input.txt"
    let s = 0
    let s2 = 0
    for line in split_lines(text: read_file(filename)):
        let numbers = get_numbers(text: line)
        s += predict(numbers) # part 1
        s2 += backfill(numbers) # part 2
    print("part 1: sum = {s}")
    print("part 2: sum = {s2}")

fn predict(numbers: List[int]) -> int:
    if all_zeros(numbers):
        return 0
    else:
        let delta = diff(numbers)
        let d2 = predict(numbers: delta)
        return numbers.last() + d2

fn backfill(numbers: List[int]) -> int:
    if all_zeros(numbers):
        return 0
    else:
        let delta = diff(numbers)
        let d2 = backfill(numbers: delta)
        return numbers.first() - d2

fn is_zero(value: int) -> bool:
    return value == 0

fn all_zeros(numbers: List[int]) -> bool:
    return all(values: numbers, check: is_zero)

fn diff(numbers: List[int]) -> List[int]:
    assert(condition: numbers.len() > 1, message: "Expect at least two items in list")
    let differences = List()
    let p = 0
    let first = true
    for n in numbers:
        if first:
            first = false
        else:
            differences.append(n - p)
        p = n
    return differences

