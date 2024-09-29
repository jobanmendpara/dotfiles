from ranger.api.commands import Command
import os
import errno

class mk(Command):
    """
    :mk <pathname>

    The mk command creates a file or directory at the specified pathname.
    If pathname ends with a '/', it will assume you want to create a directory.
    Otherwise, it will assume you want to create a file. Intermediate directories are created.

    e.g., ':mk dir/' creates a directory.
    e.g., ':mk file.txt' creates a file.
    """

    def execute(self):
        pathname = os.path.join(self.fm.thisdir.path, ' '.join(self.args[1:]))
        try:
            if pathname[-1] == '/':
                os.makedirs(pathname, exist_ok=True)
            else:
                os.makedirs(os.path.dirname(pathname), exist_ok=True)
                open(pathname, 'a').close()
        except OSError as err:
            if err.errno != errno.EEXIST or not os.path.isdir(pathname):
                self.fm.notify("An error occurred: {0}.".format(err))

