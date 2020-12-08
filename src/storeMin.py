import random

minimum = 10000

for i in range(25):
    random_number = random.randint(0, 4999)
    print("Generated number is {}: ".format(random_number))
    if random_number <= minimum:
        minimum = random_number

print("The minimum number found is: " + str(minimum))