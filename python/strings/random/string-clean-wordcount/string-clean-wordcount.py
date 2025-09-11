import re

text = "Hello, world! Hello Python. Python is fun, isn't it?"

text = text.lower()

clean = re.sub(r'[^\w\s]', '', text).split()
print(clean) # transformed text with no punctuation and no capitalization


word_count = {}

for word in clean: 
    if word in word_count: 
        word_count[word] += 1
    else: 
        word_count[word] = 1

print(word_count) # word count dictionary

sorted_word_count = sorted(word_count.items(), key=lambda x: x[1], reverse=True)[:3]
print(sorted_word_count) # top 3 words by frequency


with open('totals.txt', 'w') as f:
    for char, total in sorted_word_count:
        print(f'{char} -> {total}', file=f)
