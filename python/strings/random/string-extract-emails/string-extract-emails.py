import re

text = """
Hello team, please contact us at support@example.com or sales@example.org.
You can also reach out to admin123@company.co.in for escalations.
"""

def extract_emails(text):

    
    text = text.lower()
    clean = re.sub(r'[^\w\s@.]', '', text)
    emails = re.findall('\S+@\S+', clean)
    print(emails)


    unique_emails = set(emails)
    print(unique_emails)

    with open('emails.txt', 'w') as f:
        for email in unique_emails:
            print(f'{email}', file=f)
  
    return emails

extract_emails(text)