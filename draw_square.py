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
def drawsq(some_turtle):

    for i in range(1,4):
        some_turtle.forward(200)
        some_turtle.right(120)
        some_turtle.forward(200)
        some_turtle.right(60)

def draw_art():
    window = turtle.Screen()
    window.bgcolor("grey")

    # Create turtle and call it Brad, the bad boy
    brad = turtle.Turtle()
    brad.shape("turtle")
    brad.color("white")
    brad.width(1)
    brad.speed(75)
    for i in range(1,37):
        drawsq(brad)
        brad.right(10)

    window.exitonclick()

draw_art()
