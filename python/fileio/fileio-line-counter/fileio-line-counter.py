# total number of lines 

with open('data.txt', 'r') as f:
    lines = f.readlines()
    for line in lines:
        print(line.strip())

    line_count = len(lines)
print(f'Total Lines: {line_count}')

# total number of words 

c = 0

with open(r'data.txt','r') as f:

    data = f.read()
    w = data.split()
    c += len(w)

print(f'Total Words: {c}')

# total number of characters

with open(r'data.txt','r') as f:
    text = f.read().strip().split()
    len_char = sum(len(word) for word in text)
    print(f'Total Characters: {len_char}')




with open("summary.txt", "w") as text_file:
    text_file.write("Total Lines: {line_count}\n")
    text_file.write("Total Words: {c}\n")
    text_file.write("Total Characters: {len_char}\n")



# more efficient way to read once and write the output for 3 different ask is  below as per chatgpt 

# Read file once
with open("data.txt", "r") as f:
    lines = f.readlines()

# Count lines
line_count = len(lines)

# Count words
words = []
for line in lines:
    words.extend(line.split())
word_count = len(words)

# Count characters (excluding spaces)
char_count = sum(len(word) for word in words)

# Print results
print("Chatgpt method results below")
print(f"Total Lines: {line_count}")
print(f"Total Words: {word_count}")
print(f"Total Characters: {char_count}")

# Write summary to file
with open("summary.txt", "w") as out:
    out.write(f"Total Lines: {line_count}\n")
    out.write(f"Total Words: {word_count}\n")
    out.write(f"Total Characters: {char_count}\n")
