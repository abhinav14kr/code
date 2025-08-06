text = "The quick brown fox jumps over the lazy dog. The dog was not amused."


words = text.split()

word_count = {}

for word in words: 
    word = word.lower().strip(".")
    if word in word_count:
        word_count[word] += 1
    else:
        word_count[word] = 1

print(word_count)

most_frequent_word = max(word_count, key=word_count.get)
count = word_count[most_frequent_word]
print(f"{most_frequent_word}: {count}")