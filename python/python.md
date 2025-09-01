[[learning]] #coding 

## **MIT playlist**

[MIT Python Course (YouTube)](https://www.youtube.com/watch?v=xAcTmDO6NTI&list=PLUl4u3cNGP62A-ynp6v6-LGBCzeH3VAQB)

---

## Grouping Examples

### Group words by length

```python
groups = {}

for word in words: 
    first_key = len(word)

    if first_key not in groups: 
        groups[first_key] = []
    groups[first_key].append(word)

print(groups)
```

---

### Group scores into categories

```python
groups = {}

for name, number in scores:
    if number >= 90:
        groupkey = 'Excellent'
    elif 75 <= number <= 90:
        groupkey = 'Good'
    elif 60 <= number <= 74:
        groupkey = 'Average'
    else:
        groupkey = 'Poor'

    if groupkey not in groups:
        groups[groupkey] = []
    groups[groupkey].append(name)

print(groups)
```

---

### Word frequency counter

```python
text = "apple banana apple orange banana apple grape grape orange apple"  
words = text.split(" ")
groups = {}

for word in words:
    if word not in groups:
        groups[word] = 0
    groups[word] += 1

print(groups)
```

---

### Group products by category

```python
products = [
    ("Laptop", "Electronics"),
    ("Mouse", "Electronics"),
    ("Shampoo", "Personal Care"),
    ("Toothpaste", "Personal Care"),
    ("Keyboard", "Electronics"),
    ("Notebook", "Stationery"),
    ("Pen", "Stationery"),
    ("Soap", "Personal Care"),
    ("Monitor", "Electronics"),
    ("Marker", "Stationery")
]

groups = {}
for product, category in products:
    if category not in groups: 
        groups[category] = []
    groups[category].append(product)

print(groups)
```

---

### Group sales by category

```python
sales = [
    ("Laptop", "Electronics", 5),
    ("Mouse", "Electronics", 20),
    ("Keyboard", "Electronics", 12),
    ("Shampoo", "Personal Care", 30),
    ("Toothpaste", "Personal Care", 10),
    ("Soap", "Personal Care", 25),
    ("Notebook", "Stationery", 15),
    ("Pen", "Stationery", 50),
    ("Marker", "Stationery", 35),
    ("Monitor", "Electronics", 7),
]

groups = {}

for product, category, qty in sales: 
    if category not in groups: 
        groups[category] = []
    groups[category].append(product)

print(groups)
```

---

### Group people by age range

```python
people = [
    ("Alice", 24),
    ("Bob", 35),
    ("Charlie", 17),
    ("David", 45),
    ("Eva", 52),
    ("Frank", 29),
    ("Grace", 68),
    ("Hannah", 34),
    ("Ian", 15),
    ("Jack", 73)
]

groups = {}

for name, age in people: 
    if age <= 18: 
        group = 'Minor'
    elif 19 <= age <= 35: 
        group = 'Young adult'
    elif 36 <= age <= 60: 
        group = 'Adult'
    else: 
        group = 'Senior' 

    if group not in groups: 
        groups[group] = []
    groups[group].append(name)

print(groups)
```

---

### Purchases – grouping variations

#### Group by category → customers

```python
groups = {}

for name, product, category in purchases: 
    if category not in groups: 
        groups[category] = []
    groups[category].append(name)

print(groups)
```

#### Group by category → items

```python
groups = {}

for customer, item, category in purchases: 
    if category not in groups: 
        groups[category] = []
    groups[category].append(item)

print(groups)
```

#### Group by category → item counts

```python
groups = {}

for customer, item, category in purchases: 
    if category not in groups: 
        groups[category] = {}
    if item not in groups[category]: 
        groups[category][item] = 0 
    groups[category][item] += 1 

print(groups)
```

---

### Customer spending by category (average spend)

```python
purchases = [
    ("Alice", "Laptop", "Electronics", 1200),
    ("Alice", "Keyboard", "Electronics", 100),
    ("Bob", "Mouse", "Electronics", 25),
    ("Bob", "Tablet", "Electronics", 500),
    ("Charlie", "Shampoo", "Personal Care", 10),
    ("Charlie", "Toothpaste", "Personal Care", 8),
    ("David", "Soap", "Personal Care", 3)
]

groups = {}

for customer, item, category, price in purchases: 
    if (customer, category) not in groups:
        groups[(customer, category)] = []
    groups[(customer, category)].append(price)

averages = {k: sum(v) / len(v) for k, v in groups.items()}

print(averages)
```

---

## Recursion

### Factorial

```python
def factorial(n):
    if n == 0:
        return 1
    else:
        return n * factorial(n - 1)
```

![[Pasted image 20250811161210.png]]

---

## File I/O

### Writing to a file

```python
with open('totals.txt', 'w') as f:
    for name, total in result.items():
        print(f'{name} -> {total}', file=f)
```

### Reading line by line

```python
with open('totals.txt', 'r') as f:
    for line in f:
        print(line.strip())
```

### Reading all lines

```python
with open('totals.txt', 'r') as f:
    lines = f.readlines()

for line in lines:
    print(line.strip())
```

### Reading full content

```python
with open('totals.txt', 'r') as f:
    content = f.read()
    print(content)
```


### Basic File Modes (Text Mode)

| Mode   | Description                                                                                     |
| ------ | ----------------------------------------------------------------------------------------------- |
| `'r'`  | **Read** (default). Opens the file for reading. Fails if the file does not exist.               |
| `'w'`  | **Write**. Creates a new file or **overwrites** an existing file.                               |
| `'a'`  | **Append**. Creates a new file if it doesn’t exist, or **adds to the end** of an existing file. |
| `'x'`  | **Exclusive creation**. Creates a file, but fails if it already exists.                         |
| `'r+'` | Read **and** write. File must exist.                                                            |
| `'w+'` | Write **and** read. Overwrites the file.                                                        |
| `'a+'` | Append **and** read. Reads and writes, keeping original contents and adding to end.             |

## **String Manipulation**


---

### Clean word count

```python
import re 

# Original text with punctuation and capitalization
text = "Hello, world! Hello Python. Python is fun, isn't it?"

# Convert all text to lowercase
# Example: "Hello, World!" -> "hello, world!"
text = text.lower()

# Remove punctuation using regex [^\w\s] (anything not word or space) and split into words
# Example before: "hello, world! hello python."
# Example after: ["hello", "world", "hello", "python", "python", "is", "fun", "isnt", "it"]
clean = re.sub(r'[^\w\s]', '', text).split()
print(clean) # transformed text with no punctuation and no capitalization

# Initialize an empty dictionary to count word frequencies
word_count = {}

# Loop through each word in the list
# Example progression: {"hello": 1}, {"hello": 2}, {"hello": 2, "world": 1}, ...
for word in clean:
    if word in word_count:
        word_count[word] += 1
    else:
        word_count[word] = 1

print(word_count) # word count dictionary, e.g. {"hello": 2, "python": 2, "is": 1, ...}

# Sort dictionary by frequency (highest first) and take the top 3
# Example result: [("hello", 2), ("python", 2), ("world", 1)]
sorted_word_count = sorted(word_count.items(), key=lambda x: x[1], reverse=True)[:3]
print(sorted_word_count) # top 3 words by frequency

with open('totals.txt', 'w') as f:
    for char, total in sorted_word_count:
        print(f'{char} -> {total}', file=f)
```

---

### Count vowels

```python
# Sample text
text = "Data Engineering with Python"

# Convert to lowercase
# Example: "Data Engineering" -> "data engineering"
text = text.lower()

# Function to count how many vowels are in the string
def count_vowel(text):
    vowels = 'aeiou'
    count = 0
    for char in text:
        # Example: char='a' -> counts +1
        # Example: char='t' -> ignored
        if char in vowels:
            count += 1
    return count

print(count_vowel(text)) # Example output: 9 vowels
```

---

### Longest word

```python
import re

# Sample text
text = "Data engineering with Python is powerful, flexible, and fun!"

# Function to find the longest word
def find_longest_words(text):
    text = text.lower()  
    # Example: "Data Engineering" -> "data engineering"

    clean = re.sub(r'[^\w\s]', '', text)
    # Example: "powerful," -> "powerful"

    strings = clean.split()
    # Example: "data engineering with python" -> ["data", "engineering", "with", "python"]

    print(strings)

    # Find the longest word by comparing lengths
    # Example list: ["data", "engineering", "python"] -> longest = "engineering"
    longest_word = max(strings, key=len)

    print(f'Longest word(s): {longest_word}')  # e.g. "engineering"
    print(len(longest_word))  # e.g. 11

    return longest_word

print(find_longest_words(text))


with open('longest_word.txt', 'w') as f:
    f.write (f'{find_longest_words(text)}')
```

---

### Most frequent word

```python
# Sample text
text = "The quick brown fox jumps over the lazy dog. The dog was not amused."

# Split text into words by spaces
# Example: "The quick brown fox" -> ["The", "quick", "brown", "fox"]
words = text.split()

# Dictionary to count occurrences
word_count = {}

for word in words:
    # Convert to lowercase and strip periods
    # Example: "The." -> "the"
    # Example: "dog." -> "dog"
    word = word.lower().strip(".")
    
    # Add to dictionary or increment count
    # Example: {"the": 1}, {"the": 2}, {"the": 2, "dog": 1}
    if word in word_count:
        word_count[word] += 1
    else:
        word_count[word] = 1

print(word_count)  # Full frequency dictionary

# Find the word with the maximum count
# Example: {"the": 3, "dog": 2, "quick": 1} -> most frequent = "the"
most_frequent_word = max(word_count, key=word_count.get)
count = word_count[most_frequent_word]

print(f"{most_frequent_word}: {count}")  # e.g. "the: 3"
```

---

