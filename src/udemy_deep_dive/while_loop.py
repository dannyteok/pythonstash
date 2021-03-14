a = 0
b = 10

while a < 4:
    print('--------------------')
    a += 1
    b -= 1

    try:
        a / b
    except ZeroDivisionError:
        print(f"{a}, {b} - division by Zero")
        break
    finally:
        print(f"{a}, {b} - will always execute")

    print(f"{a}, {b} - the main loop")
else:
    print("code executed without a zero division error")