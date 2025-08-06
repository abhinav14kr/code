s = input("Enter a name or a string: ")
s1 = s.split()

print(s1)


l1 = []

for i in s1: 
    l1.append(i[::-1])
output = ' '.join(l1)

print(output)