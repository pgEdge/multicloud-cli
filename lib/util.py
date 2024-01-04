#!/usr/bin/env python3

#  Copyright 2023-2024 PGEDGE  All rights reserved. #

import os, sys, configparser, sqlite3, json

os.chdir(os.path.dirname(__file__))
sys.path.append(os.path.join(os.path.dirname(__file__), "lib"))

import libcloud
from libcloud.compute.types import Provider

import termcolor

CONFIG = f"{os.getenv('HOME')}/.multicloud/conf"

PROVIDERS = \
    [
        ["eqn", "equinixmetal", "Equinix Metal"],
        ["aws", "ec2",          "Amazon Web Services"],
        ["azr", "azure",        "Microsoft Azure"],
        ["gcp", "gce",          "Google Cloud Platform"],
    ]


def exit_message(msg, rc=1):
    if rc == 1:
        message(f"ERROR: {msg}")
    else:
        message(msg)
    os._exit(rc)


def message(msg):
    print(msg)


def load_config(section):
    # make section an alias
    if section == "equinixmetal":
        section = "eqn"
    elif section == "ec2":
        section = "aws"

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


def get_connection(provider="equinixmetal", metro=None, project=None):
    sect = load_config(provider)

    # convert provider to libcloud from an alias
    if provider == "aws":
        provider = "ec2"
    elif provider == "eqn":
        provider = "equinixmetal"

    Driver = libcloud.compute.providers.get_driver(provider)
    if provider in ("equinixmetal"):
        try:
            p1 = sect["api_token"]
            conn = Driver(p1)
            if not project:
                project = sect["project"]
        except Exception as e:
           exit_message(f"cannot load [eqn] section of config file '{CONFIG}'\n {str(e)}")

    elif provider in ("ec2"):
        try:
            p1 = sect["access_key_id"]
            p2 = sect["secret_access_key"]
            if not metro:
                metro = sect["metro"]
            conn = Driver(p1, p2, region=metro )
        except Exception as e:
           exit_message(f"cannot load [aws] section of config file '{CONFIG}'\n {str(e)}")

    else:
        exit_message(f"Invalid provider '{provider}'")

    airport = get_airport(provider, metro)

    return (conn, sect, metro, airport, project)


def output_json(tbl):
    print(tbl)

    return


def is_metro(metro):
    try:
        cursor = cL.cursor()
        cursor.execute(f"SELECT count(*) FROM metros WHERE metro = '{metro}'")
        data = cursor.fetchone()
        if data[0] > 0:
            return(True)
    except Exception as e:
        exit_message(f"is_metro({metro}) ERROR:\n {str(e)}", 1)

    return(False)


def is_parent(parent):
    try:
        cursor = cL.cursor()
        cursor.execute(f"SELECT count(*) FROM metros WHERE parent = '{parent}'")
        data = cursor.fetchone()
        if data[0] > 0:
            return(True)
    except Exception as e:
        exit_message(f"is_parent({parent}) ERROR:\n {str(e)}", 1)

    return(False)


def is_airport(airport):
    try:
        cursor = cL.cursor()
        cursor.execute(f"SELECT count(*) FROM airports WHERE airport = '{airport}'")
        data = cursor.fetchone()
        if data[0] > 0:
            return(True)
    except Exception as e:
        exit_message(f"is_airport({airport}) ERROR:\n {str(e)}", 1)

    return(False)


def get_airport(provider, metro):
    try:
        cursor = cL.cursor()
        cursor.execute(f"SELECT airport FROM metros WHERE provider = '{provider}' AND metro = '{metro}'")
        data = cursor.fetchone()
        if data:
            return(str(data[0]))
    except Exception as e:
        exit_message(f"get_airport({provider}:{metro}) ERROR:\n {str(e)}", 1)

    return(None)


def airport_list(geo=None, country=None, airport=None, provider=None, json=False):
    wr = "1 = 1"
    if geo:
        wr = wr + f" AND geo = '{geo}'"
    if country:
        wr = wr + f" AND country = '{country}'"
    if airport:
        wr = wr + f" AND airport = '{airport}'"
    if provider:
        wr = wr + f" AND provider= '{provider}'"
    cols = "geo, country, airport, airport_area, lattitude, longitude, provider, metro, parent, locations"
    try:
        cursor = cL.cursor()
        cursor.execute(f"SELECT {cols} FROM v_airports WHERE {wr}")
        data = cursor.fetchall()
    except Exception as e:
        exit_message(str(e), 1)
    al = []
    for d in data:
        al.append([str(d[0]), str(d[1]), str(d[2]), str(d[3]), d[4], 
                   d[5], str(d[6]), str(d[7]), str(d[8]), str(d[9])])
    return (al)


# MAINLINE ################################################################
cL = sqlite3.connect("../conf/metadata.db", check_same_thread=False)


