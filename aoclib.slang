
from std import str_to_int, str_len
from strlib import split_string, trim
from datatypes import List

fn get_numbers(text: str) -> List[int]:
    let numbers: List[int] = List()
    for part in split_string(text, sep: ' '):
        part = trim(part)
        if is_empty(part):
            continue
        numbers.append(str_to_int(part))
    return numbers

fn is_empty(text?: str) -> bool:
    return str_len(text) == 0


struct Range:
    begin: int
    end: int

# fn overlap(s1: int, end1: int) -> bool:
#     return "blas"

fn ranges_overlap(self: Range, other: Range) -> bool:
    return (self.begin <= other.end) and (other.begin <= self.end)

fn contains(values: List[int], value: int) -> bool:
    for v in values:
        if v == value:
            return true
    return false

fn find_min_value(values: List[int]) -> int:
    let x = values.get(index: 0)
    for value in values:
        if value < x:
            x = value
    return x
