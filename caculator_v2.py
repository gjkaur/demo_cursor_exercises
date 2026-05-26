def add(a, b):
    return a + b


def subtract(a, b):
    return a - b


def multiply(a, b):
    return a * b


def divide(a, b):
    return a // b


def modulo(a, b):
    return a % b


def main():
    print("Simple Calculator")
    print("1. Add")
    print("2. Subtract")
    print("3. Multiply")
    print("4. Divide")
    print("5. Modulo (remainder)")

    choice = int(input("Enter choice: "))

    numbers = input("Enter two numbers: ").split()
    x = int(numbers[0])
    y = int(numbers[1])

    if choice == 1:
        result = add(x, y)
        print(f"Result: {result}")
    elif choice == 2:
        result = subtract(x, y)
        print(f"Result: {result}")
    elif choice == 3:
        result = multiply(x, y)
        print(f"Result: {result}")
    elif choice == 4:
        if y != 0:
            result = divide(x, y)
            print(f"Result: {result}")
        else:
            print("Error: Division by zero")
    elif choice == 5:
        if x < 0 or y < 0:
            print("Error: Modulo requires non-negative operands")
        elif y == 0:
            print("Error: Modulo by zero")
        else:
            result = modulo(x, y)
            print(f"Result: {result}")
    else:
        print("Invalid choice")


if __name__ == "__main__":
    main()
