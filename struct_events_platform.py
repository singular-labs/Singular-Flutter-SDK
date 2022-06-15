#!/usr/bin/env python3

import os
import json
import shutil
import argparse
import sys

import importlib.util

from singular_struct_events_common import StructEventsCommon
dir_path = os.path.dirname(os.path.realpath(__file__))
structEventsCommon = StructEventsCommon(dir_path + "/../")



def format_var_name(data_type, data):
    return structEventsCommon.camel_case(data)


def generate_code(data, data_type):
    ret = 'class ' + data_type.capitalize() + '{\n'
    for elem in data:
        ret = ret +'\tstatic String get ' + format_var_name(data_type, elem) + " => " + "\"{}\";\n".format(elem)
    ret = ret +'}'
    file_name = data_type + '.dart'
    structEventsCommon.write_file(ret, dir_path + '/lib/'+file_name)
    #print(ret)





if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-skip_repo", "--skip_repo", help = "skip cloning source json repo and asume it exists")
    parser.add_argument("-tmp_dir", "--tmp_dir", help = "tmp dir")
    args = parser.parse_args()
    if not args.tmp_dir:
        print('no tmp dir provided')
        sys.exit(-1)
    if not args.skip_repo:
        structEventsCommon.clone_repo(args.tmp_dir)
    events_data = structEventsCommon.read_data("events",args.tmp_dir)
    attributes_data = structEventsCommon.read_data("attributes",args.tmp_dir)
    generate_code(events_data, "events")
    generate_code(attributes_data, "attributes")
    structEventsCommon.update_zendesk_structured_events("6573481580827", events_data, attributes_data, format_var_name )
    if not args.skip_repo:
        structEventsCommon.delete_repo(args.tmp_dir)