'''

Choose an option:
1 - Add Task
2 - View Tasks
3 - Remove Task
4 - Exit
> 1
Enter task: Buy groceries

> 2
1. Buy groceries

> 1
Enter task: Finish Python exercise

> 2
1. Buy groceries
2. Finish Python exercise

> 3
Enter task number to remove: 1

> 2
1. Finish Python exercise

'''

# cli-simple-todo-list.py

def show_menu():
    print("Choose an option:")
    print("1 - Add Task")
    print("2 - View Tasks")
    print("3 - Remove Task")
    print("4 - Exit")

def add_task(tasks):
    # TODO: prompt user input and append to tasks
    pass

def view_tasks(tasks):
    # TODO: print numbered list (handle empty list)
    pass

def remove_task(tasks):
    # TODO: prompt number, validate, then pop
    pass

def main():
    tasks = []  # BONUS: load from file here
    while True:
        show_menu()
        choice = input("> ").strip()
        if choice == "1":
            add_task(tasks)
        elif choice == "2":
            view_tasks(tasks)
        elif choice == "3":
            remove_task(tasks)
        elif choice == "4":
            # BONUS: save to file here before exit
            print("Goodbye!")
            break
        else:
            print("Invalid option. Try 1–4.")

if __name__ == "__main__":
    main()

