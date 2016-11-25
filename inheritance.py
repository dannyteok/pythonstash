class Parent():
    """ This is the parent class. """

    def __init__(self, last_name, eye_color):
        print("Parent Constructor Called")
        self.last_name = last_name
        self.eye_color = eye_color


class Child(Parent):
    """ This is the child class.
    It inherits/reuse all that is defined in class Parent by default, and it can
    have additional attributes/ arguments of its own. """

    def __init__(self, last_name, eye_color, num_of_toys):
        print("Child Constructor Called")
        Parent.__init__(self, last_name, eye_color)
        self.num_of_toys = num_of_toys

#amanda_pip = Parent("Pip", "Green")
brad_pip = Child("Rosalove", "Blue", 9)
#print(amanda_pip.last_name)
print(brad_pip.last_name)
print(brad_pip.num_of_toys)


"""
Notes:
1. When this code runs, we're initializing an instance brad_pip of the Child class.
2. Because the __init__ take 3 arguments in Child class, we have to parse 3 arguments in.
3. When the Child class is called, it will print out "Child Constructor Called", then
   move on to initialize Parent class.
4. The constructor for the Parent is going to get called next. At the end of
   the line Parent.__init__(self, last_name, eye_color), lets call this Z, your control cursor will move up to
   Parent()'s __init__, which will print "Parent Constructor Called"
5. Here, the last_name and eye_color will be initialized. Once this is done, the control cursor
   will return to Z.
6. Here, the num_of_toys instance will be properly initialized.
7. When 6. is done, this mean that the instance brad_pip has now been properly created.
"""