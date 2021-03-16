import json
import os
from src.etl.lib import default_project_path
from src.etl.lib import default_project_path_exists

path_project = default_project_path()

if path_project == '':
    raise ValueError("Please set PROJECT_ROOT in your environment variable")
elif default_project_path_exists(os.path.join(path_project, "data")) is False:
    raise ValueError("data/ directory cannot be found.")
else:
    path_data = os.path.join(path_project, "data")

# See: https://www.freecodecamp.org/news/python-read-json-file-how-to-load-json-from-a-file-and-parse-dumps/
with open(os.path.join(path_data, "jsons/", "neighbourhoods.json")) as file:
    neighbourhood = json.load(file)

print(neighbourhood[0:3])
print(type(neighbourhood))
print("---------------------")

neighbourhood_list = json.dumps(neighbourhood[0:3])
print(neighbourhood_list)
print(type(neighbourhood_list))