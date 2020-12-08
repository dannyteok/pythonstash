import os

# Get files
def rename_files():
    FILELIST = os.listdir(r"C:\Users\danny.teok\Downloads\prank")
    SAVED_PATH = os.getcwd()
    print("Current working directory is " + SAVED_PATH)

    # Change directory to target
    os.chdir(r"C:\Users\danny.teok\Downloads\prank")

    print(FILELIST)
    SAVED_PATH = os.getcwd()
    print("Current working directory is now " + SAVED_PATH)
    print(SAVED_PATH)

    # Rename files
    for i in FILELIST:
        print("Renaming " + i + " to " + i.translate(None, "0123456789"))
        os.rename(i, i.translate(None, "0123456789"))

rename_files()
