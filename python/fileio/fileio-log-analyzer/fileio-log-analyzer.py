from collections import Counter
import re

level_counts = {}

with open('server.log', 'r') as file:
    content = file.read()
    print(content)

    log_levels = re.findall(r'\b(INFO|ERROR|WARNING|DEBUG|CRITICAL)\b', content)

    # Manually counting each log level
    for level in log_levels:
        if level in level_counts:
            level_counts[level] += 1
        else:
            level_counts[level] = 1

print(level_counts)

# Print the result
for level, count in level_counts.items():
    print(f"{level} -> {count}")



# writing to a new file

with open('summary.log', 'w') as summary_file:
    for level, count in level_counts.items():
        summary_file.write(f"{level} -> {count}\n")