import turtle

'''
def drawsq(some_turtle):

    counter = 0
    while counter < 36:
        for i in range(1,5):
            angle = 0
            angle += 1
            some_turtle.forward(150)
            some_turtle.right(60)
            some_turtle.right(angle)
        counter += 1
'''

def bigdiamond(pen):

    for i in range(3):
        pen.forward(300)
        pen.right(180)


def smalldiamond(pen):

    for i in range(3):
        pen.forward(200)
        pen.right(120)


def draw_art():
    window = turtle.Screen()
    window.bgcolor("grey")

    # Create turtle and call it Brad, the bad boy
    brad = turtle.Turtle()
    brad.shape("turtle")
    brad.color("white")
    brad.width(1)
    brad.speed("fastest")
    for i in range(72):
        smalldiamond(brad)
        brad.right(5)

        bigdiamond(brad)
        brad.right(5)
    #brad.right(350)

#    for j in range(72):
#       bigdiamond(brad)
#        brad.right(5)


    window.exitonclick()


def print_menu():
    print("Hello! Choose a design from below - ")
    print("1. Shapes of triangles.")
    print("2. Shapes of rhombus.")
    print("3. Shapes of squares.")
    print("4. Shapes of pentagons.")
    print("5. Shapes of hexagons.")

print_menu()
draw_art()
