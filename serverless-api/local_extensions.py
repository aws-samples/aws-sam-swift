import platform
from cookiecutter.utils import simple_filter

@simple_filter
def architecture(v):
    arch = platform.machine().lower()
    if 'aarch' in arch or 'arm' in arch:
        return 'arm64'
    else:
        return v