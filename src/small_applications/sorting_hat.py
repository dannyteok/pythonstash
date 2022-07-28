import random


houses = ["Gryffindor", "Hufflepuff", "Ravenclaw", "Slytherin"]


def select_house():
    house = random.choice(houses)
    return house


if __name__ == "__main__":
    print(f"\n+" + "-" * 40 + "+")
    print(f"|" + f" You belong to House {select_house()}! |\n")
    print("+" + "-" * 40 + "+")
