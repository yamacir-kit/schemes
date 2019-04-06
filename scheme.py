def read(string):
    return string

def write(string):
    print string

def evaluate(string):
    return string

if __name__ == '__main__':
    while True:
        write(evaluate(read(raw_input('> '))))

