numbers = [3, 17, 1, 24, 7, 8]

def max_value(numbers):
    if not numbers: 
        return None 
    max_value = numbers[0]
    for number in numbers: 
        if number > max_value:
            max_value = number
    return max_value
    
print(max_value(numbers))
    
