#!/usr/bin/env python3
# (c) 2020 Simon Meggle <simon.meggle@elabit.de>

# This file is part of Robotmk, a module for the integration of Robot
# framework test results into Checkmk.
# https://robotmk.org
# https://github.com/simonmeggle/robotmk
# https://robotframework.org/#tools

# Robotmk is free software;  you can redistribute it and/or modify it
# under the  terms of the  GNU General Public License  as published by
# the Free Software Foundation in version 3.  This file is distributed
# in the hope that it will be useful, but WITHOUT ANY WARRANTY;  with-
# out even the implied warranty of  MERCHANTABILITY  or  FITNESS FOR A
# PARTICULAR PURPOSE. See the  GNU General Public License for more de-
# ails.  You should have  received  a copy of the  GNU  General Public
# License along with GNU Make; see the file  COPYING.  If  not,  write
# to the Free Software Foundation, Inc., 51 Franklin St,  Fifth Floor,
# Boston, MA 02110-1301 USA.

# This plugin requires Python > 3.7 and some modules:
# pip3 install robotframework pyyaml mergedeep python-dateutil

from robotmk import robotmk, RMKPlugin, RMKrunner, test_for_modules




def main():
    test_for_modules()
    RMKPlugin.get_args()
    rmk = RMKrunner()
    cmdline_suites='all' # TBD: start suites from cmdline
    rmk.start_suites(cmdline_suites)
    rmk.loginfo("... Quitting Runner, bye. ---") 
    # It is important to write at least one byte to the agent so that it can save this
    # as a state with a cache_time. 
    print('')    

if __name__ == '__main__':
    main()
else:
    # when imported as module
    import mergedeep
    import robot
    import yaml
    from dateutil import parser
