import re

text = "Python is fun. Python is powerful, and Python is flexible!"
N = 2

string = text.lower()

clean = re.sub(r'[^\w\s]', '', string).split()
print(clean)

groups = {}

for word in clean: 
    if word not in groups: 
        groups[word] = 0 
    groups[word] += 1

print(groups)

sorted_items = sorted(groups.items(), key=lambda x: x[1], reverse= True)
top_n = sorted_items[:N]
print(top_n)


with open('top_words.txt', 'w') as f:
    for name, total in top_n:
        print(f'{name} -> {total}', file=f)
