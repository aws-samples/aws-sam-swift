BOLD_START = "\033[1m"
BOLD_END = "\033[0m"

def main():

    try:

        project_name = "{{ cookiecutter.project_name }}"
        __project_slug = "{{ cookiecutter.__project_slug }}"
        architecture = "{{ cookiecutter.__architecture }}"
        runtime = "{{ cookiecutter._runtime }}"
        template_name = "{{ cookiecutter._template_name}}"

        print()
        print("-----------------------")
        print("Generating application:")
        print("-----------------------")
        print(f"Name: {project_name}")
        print(f"Folder: {__project_slug}/")
        print(f"Runtime: {runtime}")
        print(f"Architecture: {architecture}")
        print(f"Dependency Manager: Swift Package Manager (SPM)")
        print(f"Application Template: {template_name}")
        print()
        print(f"Project initialized successfully! You can now jump to the folder: {BOLD_START}{__project_slug}/{BOLD_END}")
        print()
        print(f"Next steps can be found in the file: {BOLD_START}{__project_slug}/README.md{BOLD_END}")
        print()

    except Exception as exception:
        print(f"Error generating project: {exception}")

if __name__ == '__main__':
    main()
