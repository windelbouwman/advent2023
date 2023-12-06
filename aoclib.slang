
from std import str_to_int, str_len
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

fn zip[L,R,P](left: List[L], right: List[R], merger: fn(L, R) -> P) -> List[P]:
    # Zip two lists into a merged list!
    assert(condition: left.len() == right.len(), message: "Can only zip lists of equal length")

    let pairs: List[P] = List()
    let b_iter = right.iter()
    for a in left:
        let b = option_unwrap(b_iter.next())
        let pair = merger(a, b)
        pairs.append(pair)
    
    return pairs

fn map[T,V](values: List[T], function: fn(T) -> V) -> List[V]:
    let mapped: List[V] = List()
    for value in values:
        mapped.append(function(value))
    return mapped

fn filter[T](values: List[T], criterium: fn(T) -> bool) -> List[T]:
    let allowed: List[T] = List()
    for value in values:
        if criterium(value):
            allowed.append(value)
    return allowed

extern fn sqrt(value: float) -> float
extern fn round_up(value: float) -> int
extern fn round_down(value: float) -> int

