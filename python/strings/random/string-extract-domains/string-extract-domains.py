import re

def extract_domains(text):
    # regex pattern to match domain names in URLs
    pattern = r'https?://(?:[\w\-]+\.)*([\w\-]+\.[a-z]{2,})(?:[/:]|$)'

    matches = re.findall(pattern, text)
    unique_domains = sorted(set(matches))

    # save to file
    with open('domains.txt', 'w') as f:
        for domain in unique_domains:
            f.write(domain + '\n')

    return unique_domains

text = """
Check out https://www.google.com/search?q=python and http://blog.example.org/article.
Also visit https://sub.testsite.net/page.
"""

print(extract_domains(text))
