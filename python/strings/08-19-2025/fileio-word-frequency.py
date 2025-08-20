
word_count = {}

all_words = []

with open('input.txt', 'r') as f:
    for line in f: 
        line = line.lower()
        words = line.split()
        all_words.extend(words)
        print(words) 

for word in all_words: 
    if word in word_count: 
        word_count[word] += 1
    else: 
        word_count[word] = 1

print(word_count)


top_5 = []

for word, count in word_count.items():
    top_5.append((word, count))

top_5 = sorted(top_5, key = lambda x:x[1], reverse = True)[:3]

print(top_5)
