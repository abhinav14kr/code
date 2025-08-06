x = 'Abhi'
y = 'naviiii'
i,j = 0,0
output = ''
while i < len(x) and j < len(y): 
    if i < len(x): 
        output = output + x[i]
        i = i + 1
    if i < len(y): 
        output = output + y[j]
        j = j + 1
print(output) 