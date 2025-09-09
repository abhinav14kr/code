
import re

def extract_mentions(text):
    #  mentions using regex
    pattern = r'@\w+'
    mentions = re.findall(pattern, text)

    # Removing duplicates and sorting
    unique_mentions = sorted(set(mentions))

    # Save to file
    with open('mentions.txt', 'w') as f:
        for mention in unique_mentions:
            f.write(mention + '\n')

    return unique_mentions

text = """
Thanks @Alice for the update! 
We should also loop in @Bob and @Charlie123. 
Great work @team_dev! 🚀
"""

print(extract_mentions(text))