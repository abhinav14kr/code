import re

def extract_hashtags(text):
    #  hashtags using regex
    pattern = r'#\w+'
    hashtags = re.findall(pattern, text)

    # Removing duplicates and sorting
    unique_hashtags = sorted(set(hashtags))

    # Save to file
    with open('mentions.txt', 'w') as f:
        for tag in unique_hashtags:
            f.write(tag + '\n')

    return unique_hashtags

# example
text = """
Loving the new features in #Python! 
Working on #DataEngineering projects. 
#AI and #MachineLearning are the future. #Python
"""

print(extract_hashtags(text))
