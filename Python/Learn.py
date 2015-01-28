s = "hello - my name is byron!"
longString = ''.join(str(oct(ord(c))) for c in s)


for i in map(int, [longString]):
    chars = format(i, ',').split(',')
    print chars
    for char in chars:
    	num = int(str(char))
    	print num




# print ord('b')

# print oct(ord('1'))

# print int('26', 8)

# print format(num, 'o')
# print oct(10)