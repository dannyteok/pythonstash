import json
import os
import pandas as pd
from src.etl.lib import default_project_path
from src.etl.lib import default_project_path_exists


def validate_path_project(path : str):
    if not path:
        raise ValueError("Please set PROJECT_ROOT in your environment variable")


def validate_path_data(path : str):
    if not default_project_path_exists(os.path.join(path, "data")):
        raise ValueError("data/ directory cannot be found.")


def set_variables():
    global REPO_DIR
    global path_data

    REPO_DIR = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
    path_data = os.path.join(REPO_DIR, "data/jsons")


def read_data():
    # This is one example of loading JSON data
    with open(os.path.join(path_data, "neighbourhoods.json")) as file:
        # json.load()
        # json.loads() take a string as input and returns a dictionary as output
        neighbourhoods = json.load(file)

    print(neighbourhoods[0:3])
    # Checks the type of the variable -- it's a list!
    print(type(neighbourhoods))
    print("---------------------")

    # json.dumps() converts the Python object and returns a JSON string
    list_neighbourhoods = json.dumps(neighbourhoods[0:5])
    print(list_neighbourhoods)
    print(type(list_neighbourhoods))


def load_dataframe():
    json_path = os.path.join(path_data, "neighbourhoods.json")
    with open(json_path) as f:
        json_data = json.load(f)

    df = pd.DataFrame(json_data)
    print(df)
    print("-" * 50)

    # Pass the generated JSON data into pandas dataframe


if __name__ == "__main__":
    # See: https://www.freecodecamp.org/news/python-read-json-file-how-to-load-json-from-a-file-and-parse-dumps/
    path_project = default_project_path()
    validate_path_data(path_project)
    set_variables()
    # read_data()
    load_dataframe()


