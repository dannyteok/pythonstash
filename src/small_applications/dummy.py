x, y, z, n = (int(input()) for _ in range(4))

print(f"Value for x is: {x}")
print(f"Value for y is: {y}")
print(f"Value for z is: {z}")
print(f"Value for n is: {n}")

print(
    [
        [a, b, c]
        for a in range(0, x + 1)
        for b in range(0, y + 1)
        for c in range(0, z + 1)
        if a + b + c != n
    ]
)

"""
for a in range(0,2)
for b in range(0,3)
for c in range(0,4)
"""
