'''
students = {'Student1': {'Exam1': 80, 'Exam2': 80, 'Exam3': 70}, 'Student2': {'Exam1': 90, 'Exam2': 70, 'Exam3': 65}, 'Student3': {'Exam1': 92, 'Exam2': 87, 'Exam3': 95}}

Linted as
students =
{
	'Student1': {
		'Exam1': 80,
		'Exam2': 80,
		'Exam3': 70
	},
	'Student2': {
		'Exam1': 90,
		'Exam2': 70,
		'Exam3': 65
	},
	'Student3': {
		'Exam1': 92,
		'Exam2': 87,
		'Exam3': 95
	}
}

for student in students:
    print(student)

>> Student1
   Student2
   Student3

for student in students:
    print(student)
	for exam in students[student]
		print(exam)

>>
Student1
Exam1
Exam2
Exam3
Student2
Exam1
Exam2
Exam3
Student3
Exam1
Exam2
Exam3

It's better to use a list comprehension to build up a list of dictionary to present it.

'''

#studentgrades = [{student: {exam: students[student][exam]}} for student in students for exam in students[student] ]
#                                  ⎥                                         ⎥
#                                  ⎥                                         ⎥
#                                  └╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶+

