class Parent():
    """ This is the parent class. """

    def __init__(self, last_name, eye_color):
        print("Parent Constructor Called")
        self.last_name = last_name
        self.eye_color = eye_color

    def show_info(self):
        print("Part of the parent class I will show you the the following INFORMATION --")
        print("Showing Information: Last name:" + self.last_name
              + ", and Eye color: " + self.eye_color)
        print("###########################################")


class Child(Parent):
    """ This is the child class.
    It inherits/reuse all that is defined in class Parent by default, and it can
    have additional attributes/ arguments of its own. """

    def __init__(self, last_name, eye_color, num_of_toys):
        print("Child Constructor Called")
        Parent.__init__(self, last_name, eye_color)
        self.num_of_toys = num_of_toys

    def show_info(self):
        print("The child's last name is: "
              + self.last_name
              + ", having "
              + self.eye_color.lower()
              + " eyes, and has "
              + str(self.num_of_toys) + " toy(s) in possession.")

        print("This part of show_info belongs to the Child's class, which will be shown because"
              "it overrides the parent's show_info.")


amanda_pip = Parent("Pip", "BROWN")
amanda_pip.show_info()

brad_pip = Child("Rosalove", "GREEN", 9)
#print(amanda_pip.last_name)
print(brad_pip.last_name)
print(brad_pip.num_of_toys)
brad_pip.show_info()



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