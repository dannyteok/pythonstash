import os
from os import path


def default_project_path():
    """
    :return: Returns environment value PROJECT_ROOT if set
    """
    return os.environ.get("PROJECT_ROOT")

def default_project_path_exists(path):
    """
    :return: Returns True is path exists
    """
    return os.path.exists(path)