import sys


class VM:
    def __init__(self):
        self.datas = bytearray(256)
        self.pc = -1
        self.instructions = []
        self.fetched = ["", None]

    def load(self, instructions: list):
        self.instructions = instructions.copy()

    def fetch(self):
        self.pc += 1
        if self.pc < len(self.instructions):
            self.fetched = self.instructions[self.pc]
            return True
        else:
            self.fetched = ["", None]
            return False

    def execute(self):
        def get_name() -> str:
            return self.fetched[1][0]

        def get_arg(i) -> int:
            arg = self.fetched[1][i]
            return self.datas[int(arg[1:], 16)] if arg[0] == "@" else int(arg)

        def set_ram(i, value: int):
            arg = self.fetched[1][i]
            self.datas[int(arg[1:], 16)] = (value & 0xFF)

        def debug_arg(i) -> str:
            arg = self.fetched[1][i]
            return f"{self.datas[int(arg[1:], 16)]}({arg})" if arg[0] == "@" else arg

        if self.fetched is not None:
            match get_name():
                case "AFC":
                    print(f"Before {debug_arg(1)} <- {debug_arg(2)}")
                    set_ram(1, get_arg(2))
                    print(f"After {debug_arg(1)} <- {debug_arg(2)}")
                case "COP":
                    print(f"Before {debug_arg(1)} <- {debug_arg(2)}")
                    set_ram(1, get_arg(2))
                    print(f"After {debug_arg(1)} <- {debug_arg(2)}")
                case "ADD":
                    print(f"Before {debug_arg(1)} <- {debug_arg(2)} + {debug_arg(3)}")
                    set_ram(1, (get_arg(2) + get_arg(3)))
                    print(f"After {debug_arg(1)} <- {debug_arg(2)} + {debug_arg(3)}")
                case "MUL":
                    print(f"Before {debug_arg(1)} <- {debug_arg(2)} * {debug_arg(3)}")
                    set_ram(1, (get_arg(2) * get_arg(3)))
                    print(f"After {debug_arg(1)} <- {debug_arg(2)} * {debug_arg(3)}")
                case "SUB":
                    print(f"Before {debug_arg(1)} <- {debug_arg(2)} - {debug_arg(3)}")
                    set_ram(1, (0x100 + get_arg(2) - get_arg(3)))
                    print(f"After {debug_arg(1)} <- {debug_arg(2)} - {debug_arg(3)}")
                case "DIV":
                    print(f"Before {debug_arg(1)} <- {debug_arg(2)} / {debug_arg(3)}")
                    set_ram(1, (get_arg(2) // get_arg(3)))
                    print(f"After {debug_arg(1)} <- {debug_arg(2)} / {debug_arg(3)}")
                case "EQU":
                    print(f"Before {debug_arg(1)} <- {debug_arg(2)} == {debug_arg(3)}")
                    set_ram(1, (get_arg(2) == get_arg(3)))
                    print(f"After {debug_arg(1)} <- {debug_arg(2)} == {debug_arg(3)}")
                case "JMF":
                    if get_arg(1) == 0:
                        self.pc = get_arg(2) - 1
                case "JMP":
                    self.pc = get_arg(1) - 1
                case _:
                    print(f"Instruction {self.fetched} not implemented", file=sys.stderr)
                    return False
            return True

    def __str__(self):
        return f"{self.pc:4d} - {self.fetched[0]:25} ({self.datas[:10].hex().upper()}...{self.datas[-10:].hex().upper()})"

    def run(self, max_iter=100):
        print(self, end="\n\n")
        while max_iter > 0 and self.fetch() and self.execute():
            print(self, end="\n\n")
            max_iter -= 1


def parse_file(file_path: str):
    with open(file_path, 'r') as f:
        lines = [(i[:-1], j[1].split()) for i, j in ((i, i.split('#')) for i in f.readlines()) if
                 len(j) == 2]
    return lines


if __name__ == "__main__":
    vm = VM()
    vm.load(parse_file("first_test.s"))
    vm.run()
