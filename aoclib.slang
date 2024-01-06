
from std import str_to_int, str_len, str_slice
from strlib import split_string, trim
from utils import assert
from datatypes import List, option_unwrap

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



fn find_string(text: str, pattern: str) -> int:
    # Find a pattern in a text
    let n2 = str_len(pattern)
    let n = str_len(text) - n2 + 1
    let index = 0
    while index < n:
        let candidate = str_slice(text, index, index + n2)
        if candidate == pattern:
            return index
        else:
            index += 1
    return -1

fn rfind_string(text: str, pattern: str) -> int:
    # Find a pattern in a text (from end of text)
    let n = str_len(text)
    let n2 = str_len(pattern)
    let index = n - n2
    while index >= 0:
        let candidate = str_slice(text, index, index + n2)
        if candidate == pattern:
            return index
        else:
            index -= 1
    return -1

extern fn sqrt(value: float) -> float
extern fn round_up(value: float) -> int
extern fn round_down(value: float) -> int

