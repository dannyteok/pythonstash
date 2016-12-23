class Person:
    def __init__(self, name, age, pay=0, job=None):
        self.name = name
        self.age = age
        self.pay = pay
        self.job = job

if __name__ == '__main__':
    bob = Person('Bob Smith', 42, 300000, 'software engineer')
    sue = Person('Sue Jones', 45, 400000, 'hardware engineer')
    print(bob.name, bob.job, bob.pay)

    print("Surname: " + bob.name.split()[-1])
    sue.pay *= 1.10
    print(sue.pay)
    #print("Sue's pay was 40000, but now it is ", float(sue.pay))