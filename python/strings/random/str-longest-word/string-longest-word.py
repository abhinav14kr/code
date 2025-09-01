import re

text = "Data engineering with Python is powerful, flexible, and fun!"



def find_longest_words(text):
    text = text.lower()
    clean = re.sub(r'[^\w\s]', '', text)
    strings = clean.split()
    print(strings)

    longest_word = max(strings, key=len)
    print(f'Longest word(s): {longest_word}')
    print(len(longest_word))


    return longest_word

print(find_longest_words(text))


with open('longest_word.txt', 'w') as f:
    f.write (f'{find_longest_words(text)}')
