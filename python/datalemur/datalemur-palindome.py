def is_palindrome(s):
    s = s.lower().replace(" ", "")
    return s == s[::-1]


print(is_palindrome("hello"))
print(is_palindrome("A man a plan a canal Panama"))

# using reverse

def is_palindrome(s):
    s = ''.join(s.split()).lower()
    return list(s) == list(reversed(s))

print(is_palindrome("hello"))
print(is_palindrome("A man a plan a canal Panama")) 

# two-pointer technique

def is_palindrome(s):
    s = ''.join(s.split()).lower()
    left, right = 0, len(s) - 1
    while left < right:
        if s[left] != s[right]:
            return False
        left += 1
        right -= 1
    return True


print(is_palindrome("hello"))
print(is_palindrome("A man a plan a canal Panama")) 