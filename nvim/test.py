class Calculator:
   def __init__(self, name, precision=2):
        self.name = name
        self.precision = precision

    def calculate(self, x, y, operation="add"):
        if operation == "add":
            result = x + y
        elif operation == "multiply":
            result = x * y
        else:
            result = 0

        for i in range(3):
            result += i

        return round(result, self.precision)


def greet(name, age, city):
    message = f"Hello {name}, you are {age} years old"

    if city == "Mumbai":
        message += " and you live in Mumbai"
    else:
        message += f" and you live in {city}"

    return message


def process_numbers(numbers, multiplier, offset):
    results = []

    for number in numbers:
        if number > 10:
            value = number * multiplier + offset
            results.append(value)

    return results


calculator = Calculator("MyCalculator", 3)

answer = calculator.calculate(
    10,
    20,
    "multiply",
)

message = greet(
    "Shivam",
    21,
    "Mumbai",
)

numbers = process_numbers(
    [1, 5, 10, 15, 20],
    2,
    5,
)
