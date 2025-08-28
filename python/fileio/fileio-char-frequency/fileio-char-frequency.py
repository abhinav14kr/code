
with open('notes.txt', 'r') as file:
    content = file.read()
    print(content) 

    char_frequency = {}

    for char in content.lower():
        if char not in [' ', '\n']:  # ignores spaces and newlines which i did not include in my previous code until chatgpt corrected it
            if char in char_frequency:
                char_frequency[char] += 1
            else:
                char_frequency[char] = 1


results = {}

for character, count in char_frequency.items(): 
    print(f'{character} -> {count}')

print(results)
    

with open("char_count.txt", "w") as text_file:
    for character, count in char_frequency.items():
        text_file.write(f'{character} -> {count}\n')