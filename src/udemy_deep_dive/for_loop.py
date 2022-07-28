'''
In Python, an iterable is an object capable of returning values one at a time.
It's not necessarily a collection of values, but rather an 'object'
Lists are iterable, so is tuples.
An iterable is something you can create using 'in range' function.
range() is not an iterable, range() is a list.
so, is string, and tuples.
'''

# tuples
for x in ('a', 'b', 'c', 4):
    print(x)

# You can also have more complex objects as iterable type. For example, this is a packed tuple:
for x in [(1, 2), (3, 4), (5, 6)]:
    print(x)

# To unpack this packed tuple, you can use
for i, j in [(1, 2), (3, 4), (5, 6)]:
    print(i, j)

print("END :::::::::::::::: END")

# Because string is also an iterable object, you can use the for loop to iterate over it.
s = 'hello world'

# here, the string object actually has index positions, but does not show it. You can introduce it to behave like it.
i = 0
for c in s:
    print(i, c)
    i += 1

print("+++++++++++++++++++++++++++++++++")
# or, use the range() and len() to mimic
for i in range(len(s)):
    print(i, s[i])

print("___+---+___+---+___+---+___+---")
# or, a much better way to unpack string iterable objects is to use
# enumerate, which will simply return an index and the element. Enumerate returns
# a tuple. The first element of the tuple is the index, and the second is the value
# we're getting back from the iteration

for i, c in enumerate(s):
    print(i, c)
