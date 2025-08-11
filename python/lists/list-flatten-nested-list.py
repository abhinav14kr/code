data = [1, [2, 3], [4, [5, 6]], 7]

def flatten(lst):
	for item in lst:
		if isinstance(item, list):
			yield from flatten(item)
		else:
			yield item

new = list(flatten(data))

print(new)