
from std import print, read_file, str_get, str_len, str_to_int
from strlib import split_lines, is_digit, find_char, reverse_find_char
from datatypes import Option, option_unwrap
from dicttype import Dictionary
from aoclib import find_string, rfind_string

fn main():
    part1()
    part2()
    print("Done")
   
fn part1():
    print("Part 1")
    let text = read_file("input.txt")

    let sum = 0
    for line in split_lines(text):
        # First digit:
        let c1 = str_get(text: line, option_unwrap(find_char(text: line, criterium: is_digit)))
        let c2 = str_get(text: line, index: option_unwrap(reverse_find_char(text: line, criterium: is_digit)))
        let num_text = "{c1}{c2}"
        let num = str_to_int(num_text)
        sum += num

    print("Sum: {sum}")  # 54644

fn part2():
    print("Part 2")
    let text = read_file("input.txt")
    # let text = read_file("example.txt")
    let patterns: Dictionary[int] = Dictionary()
    patterns.insert(key: "one", value: 1)
    patterns.insert(key: "two", value: 2)
    patterns.insert(key: "three", value: 3)
    patterns.insert(key: "four", value: 4)
    patterns.insert(key: "five", value: 5)
    patterns.insert(key: "six", value: 6)
    patterns.insert(key: "seven", value: 7)
    patterns.insert(key: "eight", value: 8)
    patterns.insert(key: "nine", value: 9)
    patterns.insert(key: "1", value: 1)
    patterns.insert(key: "2", value: 2)
    patterns.insert(key: "3", value: 3)
    patterns.insert(key: "4", value: 4)
    patterns.insert(key: "5", value: 5)
    patterns.insert(key: "6", value: 6)
    patterns.insert(key: "7", value: 7)
    patterns.insert(key: "8", value: 8)
    patterns.insert(key: "9", value: 9)

    let sum = 0
    for line in split_lines(text):
        # IDEA: find_char function
        # First digit:
        let index1 = str_len(line) + 1
        let index2 = -1
        let c1 = 0
        let c2 = 0
        for key in patterns:
            let index = find_string(text: line, pattern: key)
            if index >= 0 and index < index1:
                index1 = index
                c1 = patterns.get(key)
            index = rfind_string(text: line, pattern: key)
            if index >= 0 and index > index2:
                index2 = index
                c2 = patterns.get(key)
        let num = c1 * 10 + c2
        sum += num
    print("Sum: {sum}")
