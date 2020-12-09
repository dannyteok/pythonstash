def multipliers():
    for i in range(4): yield lambda x : i * x
    return i
print(multipliers(5))