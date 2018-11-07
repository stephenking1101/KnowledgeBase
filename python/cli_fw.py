#!/usr/bin/python

# -*- coding: utf-8 -*-
import getpass
import sys
from optparse import OptionParser

# constant
USAGE = "{0} [options] {1}"

HELP_FORMAT = """
Usage: {0} [operation] [options] [args]

Operations:
{1}
Use "{0} help [operation]" for more information about a specific operation.
"""

class Status(object):
    SUCCEEDED = "SUCCEEDED"
    FAILED = "FAILED"
    CANCELLED = "CANCELLED"


class CliSubCmd(object):
    def __init__(self, action, description, args_description=''):
        self.action = action
        self.description = description
        if args_description:
            self.args_description = args_description
        else:
            self.args_description = ''
        self.options = {}
        self.argv = []
        self.user = getpass.getuser()
        self.parser = OptionParser(usage=USAGE.format(self.action, self.args_description), add_help_option=True)

    def _set_cmd_name(self, cmd_name):
        self.parser.set_usage(USAGE.format('%s %s' % (cmd_name, self.action), self.args_description))

    def parse_arguments(self, args=None):
        try:
            (self.options, self.argv) = self.parser.parse_args(args)
        except Exception as e:
            print(e)
            sys.exit(1)

    def before_execute(self):
        pass

    def execute(self):
        pass

    def after_execute(self, status):
        pass

    def after_throwing(self, status, e):
        pass


def confirm(promote_info, option_value=False):
    if option_value:
        return True

    while True:
        confirm_input = input('Confirm to %s ? Enter (y)es or (n)o:' % (promote_info))
        if confirm_input == 'yes' or confirm_input == 'y':
            return True
        elif confirm_input == 'no' or confirm_input == 'n':
            return False

class CLI_CMD:
    def __init__(self, cmd_name):
        self.cmd_name = cmd_name
        self.actions = []

    def addSubCli(self, actionObj):
        actionObj._set_cmd_name(self.cmd_name)
        self.actions.append(actionObj)

    def print_help(self):
        operations = ""
        max_action_length = 0
        for actionObj in self.actions:
            if len(actionObj.action) > max_action_length:
                max_action_length = len(actionObj.action)
        operation_format = '{:' + str(max_action_length + 4) + '}'
        for actionObj in self.actions:
            operations += '    ' + operation_format.format(actionObj.action) + actionObj.description + '\n'
        print(HELP_FORMAT.format(self.cmd_name, operations))

    def get_action(self, action):
        for action_obj in self.actions:
            if action_obj.action == action:
                return action_obj
        return None

    def execute(self):
        """main function"""
        if len(sys.argv) < 2 or len(sys.argv) == 2 and not self.get_action(sys.argv[1]):
            self.print_help()
            sys.exit(1)
        if len(sys.argv) == 3 and sys.argv[1] == "help":
            self.get_action(sys.argv[2]).parser.print_help()
            sys.exit(1)
        action = sys.argv[1]
        action_obj = self.get_action(action)

        if not action_obj:
            print("Unsupported action: ", action)
            self.print_help()
            sys.exit(1)

        try:
            action_obj.parse_arguments()
            action_obj.before_execute()
            status = action_obj.execute()
            action_obj.after_execute(status)

            if type(status) is int:
                sys.exit(status)
            elif not status or status.upper().strip() == Status.SUCCEEDED:
                sys.exit(0)
            else:
                sys.exit(-1)
        except Exception as e:
            action_obj.after_throwing('FAILED', e)
            print('{0} execute FAILED!'.format(action))
            print(e)
            sys.exit(-1)
