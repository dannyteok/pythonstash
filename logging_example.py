import logging # this is standard library
import mylib # --saved in same dir path as this. This is called package/module hierarchy.

"""
NOTE ABOUT LOGGING LEVELS - https://docs.python.org/2/howto/logging.html
Default level is WARNING. This means that only events of this level and above will be tracked, unless specified otherwise in basicConfig.
Events that are tracked can be handled in different ways. The simplest way of handling tracked events is to print them to the console (stdout). Another common way
is to write them to a disk file.
"""

def main():
    #logging.basicConfig(level=logging.INFO) # add filename='dtpy01.log' to pipe stdout (what you'd see on screen) to file
    logging.basicConfig(format='%(asctime)s - [%(levelname)s]: %(message)s'
        , datefmt='%Y-%m-%d %I:%M:%S %p'
        , level=logging.INFO
        ) #level=logging[DEBUG|INFO|WARNING|ERROR|CRITICAL] in order of severity.

    logging.info('Initializing...\n')
    mylib.do_something() # calling a function from another script.

    # Example of calling a logging debug
    logging.debug('This message, a debug message, should appear on the console')

    # Example of calling a logging info
    logging.info('So should this, a normal info or INFO.')

    # Example of calling a logging warning
    logging.warning('And this, too, a warning message')

    logging.info('Finished')

if __name__ == '__main__':
main()
