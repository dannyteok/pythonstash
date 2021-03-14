import os


def csv_reader(filename):
    for row in open(filename, "r"):
        yield row

project_root_dir = "/home/dantvli/Documents/gitrepos/homeworks/aspire-data-test-python"
dir_id = "starter"
src_location = f"input_data/{dir_id}"
print(os.getcwd())
data_location = os.path.join(project_root_dir, src_location, "customers.csv")
# print(data_location)

row_num = csv_reader(data_location)
show_gen = [print(row) for row in row_num]
