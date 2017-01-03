from person_start import Person

bob = Person('Bob Smith', 42, 20650, 'janitor')
sue = Person('Sue Jones', 45, 40000)

people = [bob, sue]
for person in people:
    print(person.name, person.pay, person.job)
