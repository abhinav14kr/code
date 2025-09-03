import re

text = "Madam Arora teaches malayalam and level civic stats"

string = text.lower()

clean = re.sub(r'[^\w\s]', '', string).split()
print(clean)


palindromes = [word for word in clean if word == word[::-1]]
print(palindromes)


unique_palindromes = set(palindromes)
print(len(unique_palindromes))


with open('palindromes.txt', 'w') as f:
    for word in unique_palindromes:
        print(f'{word}', file=f)