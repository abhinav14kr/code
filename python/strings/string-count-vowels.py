text = "Data Engineering with Python"


text = text.lower()

def count_vowel(text): 
	vowels = 'aeiou'
	count = 0
	for char in text:
		if char in vowels: 
			count += 1
	return count

print(count_vowel(text))