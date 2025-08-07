list1 = [1, 3, 5, 7]
list2 = [2, 4, 6, 8]

def merge_sorted_lists(list1, list2):
    result = []
    i, j = 0, 0
    while i < len(list1) and j < len(list2):
        if list1[i] < list2[j]:
            result.append(list1[i])
            i += 1
        else: 
            result.append(list2[j])
            j += 1

    result.extend(list1[i:])
    result.extend(list2[j:])

    print(result)

merge_sorted_lists(list1, list2)    


# alternate using sorted function 

list1 = [1, 3, 5, 7]
list2 = [2, 4, 6, 8]

merged = sorted(list1 + list2)
print(merged)
