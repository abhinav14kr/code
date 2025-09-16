import re

def extract_ips(text):
    # regex pattern for IPv4 (0–255 per octet)
    pattern = (
        r'\b(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.'
        r'(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.'
        r'(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.'
        r'(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\b'
    )

    matches = re.findall(pattern, text)
    ips = [".".join(match) for match in matches] 

    unique_ips = sorted(set(ips))

    # save to file
    with open('ips.txt', 'w') as f:
        for ip in unique_ips:
            f.write(ip + '\n')

    return unique_ips

text = """
User connected from 192.168.1.10 at 10:00 AM.
Another login attempt from 10.0.0.5 failed.
Suspicious activity from 256.300.1.1 should not be counted.
"""

print(extract_ips(text))
