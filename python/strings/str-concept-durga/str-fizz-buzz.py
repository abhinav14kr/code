def fizz_buzz(input): 
    if input % 3 == 0 and input % 5 == 0: 
        return 'fizzbuzz'
    if input % 3 == 0: 
        return 'fizz'
    if input % 5 ==0: 
        return 'buzz'
    if input % 3 == 0 and input % 5 == 0: 
        return 'fizzbuzz'
    
print(fizz_buzz(5))
    