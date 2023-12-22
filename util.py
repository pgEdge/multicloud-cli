#!/usr/bin/env python3

#  Copyright 2023-2024 PGEDGE  All rights reserved. #

import os
import sys
import configparser
import json as jjson
# import logging

import libcloud

import termcolor
from libcloud.compute.types import Provider
from prettytable import PrettyTable

CONFIG = f"{os.getenv('HOME')}/.multicloud.conf"

PROVIDERS = \
    [
        ["equinixmetal", "Equinix Metal"],
        ["ec2",          "Amazon Web Services"],
    ]


def exit_message(msg, rc=1):
    if rc == 1:
        message(f"ERROR: {msg}")
    else:
        message(msg)
    os._exit(rc)


def message(msg):
    print(msg)


def output(tbl, fields, json): 
    if json:
       print(jjson.dumps(tbl))
       return

    p = PrettyTable()
    p.field_names = fields
    p.add_rows(tbl)
    print(p)

    return


def load_config(section):
    if not os.path.exists(CONFIG):
        exit_message(f"config file {CONFIG} missing")
    try:
        config = configparser.ConfigParser()		
        rc = config.read(CONFIG)
        sect = config[section]
        return(sect)
    except Exception:
        exit_message(f"missing section '{section}' in config file '{CONFIG}'")

    return None


def get_provider(prvdr):
    lp = prvdr.lower()

    for p in PROVIDERS:
        if (lp == p[0]) or (lp == p[1]):
            return(p[0])

    exit_message(f"Invalid Provider {prvdr}")


def get_connection(provider="equinixmetal", metro=None, project=None):
    prvdr = get_provider(provider)
    sect = load_config(prvdr)

    try:
        Driver = libcloud.compute.providers.get_driver(prvdr)
        if prvdr == "equinixmetal":
            p1 = sect["api_token"]
            conn = Driver(p1)
            if not project:
                project = sect["project"]
        elif prvdr in ("ec2"):
            p1 = sect["access_key_id"]
            p2 = sect["secret_access_key"]
            if not metro:
                metro = sect["metro"]
            conn = Driver(p1, p2, region=metro )
        else:
            exit_message(f"Invalid provider '{prvdr}'")
    except Exception as e:
        exit_message(str(e), 1)

    return (prvdr, conn, sect, metro, project)


def output_table(tbl, json):
    if json:
        print(tbl.get_json_string())
    else:
        print(tbl)

    return
