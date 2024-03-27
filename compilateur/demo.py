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
        def get_str(i):
            return self.fetched[1][i]

        def get_int(i):
            return int(get_str(i))

        def get_hex(i):
            return int(get_str(i), 16)

        if self.fetched is not None:
            match get_str(0):
                case "AFC":
                    self.datas[get_hex(1)] = get_int(2)
                case "COP":
                    self.datas[get_hex(1)] = self.datas[get_hex(2)]
                case "ADD":
                    self.datas[get_hex(1)] = (self.datas[get_hex(2)] + self.datas[get_hex(3)]) & 0xFF
                case "MUL":
                    self.datas[get_hex(1)] = (self.datas[get_hex(2)] * self.datas[get_hex(3)]) & 0xFF
                case "SUB":
                    self.datas[get_hex(1)] = (self.datas[get_hex(2)] - self.datas[get_hex(3)]) & 0xFF
                case "DIV":
                    self.datas[get_hex(1)] = (self.datas[get_hex(2)] // self.datas[get_hex(3)]) & 0xFF
                case "JMF":
                    if self.datas[get_hex(1)] == 0:
                        self.pc = get_int(2) - 1
                case "JMP":
                    self.pc = get_int(1) - 1
                case _:
                    print(f"Instruction {self.fetched} not implemented", file=sys.stderr)
                    return False
            return True

    def __str__(self):
        return f"{self.pc:4d} - {self.fetched[0]:25} ({self.datas[:10].hex()}...{self.datas[-10:].hex()})"

    def run(self, max_iter=100):
        print(self)
        while max_iter > 0 and self.fetch() and self.execute():
            print(self)
            max_iter -= 1


def parse_file(file_path: str):
    with open(file_path, 'r') as f:
        lines = [(i[:-1], j[1].replace('@', '').split()) for i, j in ((i, i.split('#')) for i in f.readlines()) if
                 len(j) == 2]
    return lines


if __name__ == "__main__":
    vm = VM()
    vm.load(parse_file("first_test.s"))
    vm.run()
