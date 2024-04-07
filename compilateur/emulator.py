#!/usr/bin/python3
from sys import stderr


class VM:
    def __init__(self, debug=False, csv_file="", arch=8):
        self.arch = arch
        self.datas = bytearray()
        self.pc = 0
        self.instructions = list()
        self.fetched = ("", [])
        self.debug = debug
        self.csv_file = csv_file

    def load(self, instructions: list[tuple[str, list[str]]]):
        self.instructions = instructions.copy()

    def fetch(self) -> bool:
        if self.pc < len(self.instructions):
            self.fetched = self.instructions[self.pc]
            return True
        else:
            self.fetched = ("", [])
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

        if self.fetched[1]:
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
                case "INF":
                    set_ram(1, (get_arg(2) < get_arg(3)))
                case "SUP":
                    set_ram(1, (get_arg(2) > get_arg(3)))
                case "EQU":
                    set_ram(1, (get_arg(2) == get_arg(3)))
                case "JMF":
                    if get_arg(1) == 0:
                        self.pc = get_arg(2)
                case "JMP":
                    self.pc = get_arg(1)
                case "PRI":
                    print(get_arg(1))
                case _:
                    raise NotImplementedError(f"Instruction {self.fetched} not implemented")
        self.pc += 1

    def log_state(self):
        if self.debug:
            print(f"{self.pc:4d} - {self.fetched[0]}")

    def csv_header(self):
        if self.csv_file:
            with open(self.csv_file, 'w') as f:
                print(f"FETCH;{bytes(range(1 << self.arch)).hex(';').upper()}", file=f)

    def csv_datas(self):
        if self.csv_file:
            with open(self.csv_file, 'a') as f:
                print(f"{self.fetched[0]};{';'.join(map(str, self.datas))}", file=f)

    def run(self, max_iter=255):
        self.pc = 0
        self.datas = bytearray(1 << self.arch)
        self.csv_header()
        self.csv_datas()
        while self.fetch():
            if max_iter == 0:
                raise RecursionError("Maximum number of instruction reached")
            self.execute()
            max_iter -= 1
            self.log_state()
            self.csv_datas()


def parse_file(file_path: str) -> list[tuple[str, list[str]]]:
    with open(file_path, 'r') as f:
        lines = [(i[:-1], j[1].split()) for i, j in ((i, i.split('#')) for i in f.readlines()) if
                 1 < len(j) < 4]
    return lines


if __name__ == "__main__":
    from argparse import ArgumentParser

    parser = ArgumentParser(add_help=False, description="A simple virtual machine to run Dragon programs.")
    parser.add_argument("-h", "--help", action="help", help="Show this help message and exit")
    parser.add_argument("file", type=str, help="The file to run")
    parser.add_argument("-i", "--max-iter", type=int, default=255,
                        help="Maximum number of instruction can be executed, prevent infinite loop. (default: 255)")
    parser.add_argument("-d", "--debug", action="store_true",
                        help="Enable debug mode, it will print the state of the VM between each execution.")
    parser.add_argument("-r", "--csv-ram", default="",
                        help="CSV file to save the RAM state at the end of the execution.")
    args = parser.parse_args()

    vm = VM(args.debug, args.csv_ram)
    vm.load(parse_file(args.file))
    vm.run(args.max_iter)
