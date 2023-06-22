def main():
    project_name = "{{ cookiecutter.project_name }}"

    print("Project initialized successfully! You can now jump to {} folder.".format(project_name))
    print("{}/README.md contains instructions on how to proceed.".format(project_name))

if __name__ == '__main__':
    main()
