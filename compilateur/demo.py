import sys


class VM:
    def __init__(self, debug=False):
        self.datas = bytearray(256)
        self.pc = -1
        self.instructions = []
        self.fetched = ["", None]
        self.debug = debug

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
                    set_ram(1, get_arg(2))
                case "COP":
                    set_ram(1, get_arg(2))
                case "ADD":
                    set_ram(1, (get_arg(2) + get_arg(3)))
                case "MUL":
                    set_ram(1, (get_arg(2) * get_arg(3)))
                case "SUB":
                    set_ram(1, (0x100 + get_arg(2) - get_arg(3)))
                case "DIV":
                    set_ram(1, (get_arg(2) // get_arg(3)))
                case "EQU":
                    set_ram(1, (get_arg(2) == get_arg(3)))
                case "JMF":
                    if get_arg(1) == 0:
                        self.pc = get_arg(2) - 1
                case "JMP":
                    self.pc = get_arg(1) - 1
                case "PRI":
                    print(get_arg(1))
                case _:
                    print(f"Instruction {self.fetched} not implemented", file=sys.stderr)
                    return False
            return True

    def state_str(self):
        return f"{self.pc:4d} - {self.fetched[0]:25}"

    def datas_str(self):
        return f"{self.datas[:10].hex(' ').upper()} ... {self.datas[-10:].hex(' ').upper()}"

    def run(self, max_iter=100):
        if self.debug:
            print(self.state_str())
        while max_iter > 0 and self.fetch() and self.execute():
            max_iter -= 1
            if self.debug:
                print(self.state_str())
                print(self.datas_str())


def parse_file(file_path: str):
    with open(file_path, 'r') as f:
        lines = [(i[:-1], j[1].split()) for i, j in ((i, i.split('#')) for i in f.readlines()) if
                 len(j) == 2]
    return lines


if __name__ == "__main__":
    vm = VM()
    vm.load(parse_file("first_test.s"))
    vm.run()
