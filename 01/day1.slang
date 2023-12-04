
from std import print, read_file, str_get, str_len, str_to_int
from strlib import split_lines, is_digit
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
        # print(line)
        # let num_text = ""

        # IDEA: find_char function
        # First digit:
        let c1 = option_unwrap(find_char(text: line, criterum: is_digit))
        let c2 = option_unwrap(reverse_find_char(text: line, criterum: is_digit))
        let num_text = "{c1}{c2}"

        # let i = 0
        # let n = str_len(line)
        # while i < n:
        #     let c = str_get(line, i)
        #     if is_digit(c):
        #         print("char [{i}] = {c}")
                
        #         break
        #     i += 1

        # Last digit
        # let n = str_len(line)
        # let i = n
        # while i > 0:
        #     i -= 1
        #     let c = str_get(line, i)
        #     if is_digit(c):
        #         # print("char [{i}] = {c}")
        #         num_text = num_text + "{c}"
        #         break

        let num = str_to_int(num_text)
        sum += num
        # print("Num = {num}")
    
    print("Sum: {sum}")  # 54644


fn part2():
    print("Part 2")


fn find_char(text: str, criterum: fn(char) -> bool) -> Option[char]:
    let i = 0
    let n = str_len(text)
    while i < n:
        let c = str_get(text, i)
        if criterum(c):
            return Option.Some(c)
        i += 1
    return Option.None()


fn reverse_find_char(text: str, criterum: fn(char) -> bool) -> Option[char]:
    let n = str_len(text)
    let i = n
    while i > 0:
        i -= 1
        let c = str_get(text, i)
        if criterum(c):
            return Option.Some(c)
    return Option.None()


fn replace(text: str):
    pass
