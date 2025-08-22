with open('article.txt') as f:
    lines = f.read()
    print(lines)

word_count = {}

for word in lines.split(): 
    if word in word_count: 
        word_count[word] += 1
    else: 
        word_count[word] = 1

print(word_count)


top_5 = sorted(word_count.items(), key = lambda x:x[1], reverse = True)[:5]
print(top_5)

for item, number in top_5: 
    print(f'{item} -> {number}')

