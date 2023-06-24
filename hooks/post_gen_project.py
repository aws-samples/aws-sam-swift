import os
import platform
import shutil
from cookiecutter.main import cookiecutter

def get_architecture() -> str:
    arch = platform.machine().lower()

    if 'amd' in arch or 'x86' in arch:
        return 'x86_64'
    elif 'aarch' in arch or 'arm' in arch:
        return 'arm64'
    else:
        return arch

def remove_parent_project_folder(project_name: str):

    try:
        dirpath = os.path.join('../', project_name)
        os.rename(dirpath, dirpath)
        shutil.rmtree(dirpath, ignore_errors=True)
    except:
        print(f'Could not delete the parent folder: {project_name}. Please remove manually.')

def main():

    project_name = "{{ cookiecutter.project_name }}"
    
    template = "{{ cookiecutter.template }}"

    project_slug = project_name.lower().replace(' ', '-')
    architecture = get_architecture()

    templates_repo = "{{ cookiecutter._templates_repo }}"
    template_dir = os.path.join("templates", template.lower().replace(' ', '-'))
    
    cookiecutter(
        templates_repo,
        directory=template_dir,
        no_input=True,
        output_dir="..",
        overwrite_if_exists=True,
        extra_context={
            "project_name": project_name,
            "project_slug": project_slug,
            "architecture": architecture
        }
    )

    # remove the temporary parent folder
    remove_parent_project_folder(project_name)

    print()
    print("-----------------------")
    print("Generating application:")
    print("-----------------------")
    print(f"Name: {project_name}")
    print(f"Folder: {project_slug}")
    print(f"Runtime: swift 5.8")
    print(f"Architecture: {architecture}")
    print(f"Dependency Manager: spm")
    print(f"Application Template: {template}")
    print()
    print("Project initialized successfully! You can now jump to the {} folder.".format(project_slug))
    print()
    print(f"Next steps can be found in the README file at {project_slug}/README.md")
    print()

if __name__ == '__main__':
    main()
