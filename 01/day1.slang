
from std import print, read_file, str_get, str_len, str_to_int
from strlib import split_lines, is_digit, find_char, reverse_find_char
from datatypes import Option, option_unwrap

fn main():
    print("Hello")
    part1()
    print("Done")
   
fn part1():
    print("Part 1")
    let text = read_file("input.txt")

    let sum = 0
    for line in split_lines(text):
        # IDEA: find_char function
        # First digit:
        let c1 = str_get(text: line, option_unwrap(find_char(text: line, criterium: is_digit)))
        let c2 = str_get(text: line, index: option_unwrap(reverse_find_char(text: line, criterium: is_digit)))
        let num_text = "{c1}{c2}"

        let num = str_to_int(num_text)
        sum += num
    
    print("Sum: {sum}")  # 54644

fn part2():
    print("Part 2")
