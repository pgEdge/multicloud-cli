#!/usr/bin/env python3

#  Copyright 2023-2024 PGEDGE  All rights reserved. #

import os, sys, configparser, logging

import fire
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


def get_location(location):
    prvdr, conn, section, metro = get_connection()

    locations = conn.list_locations()
    for ll in locations:
        if ll.name.lower() == location.lower():
            return ll

    return None


def get_size(conn, p_size):
    sizes = conn.list_sizes()
    for s in sizes:
        if s.id == p_size:
            return s

    exit_message(f"Invalid size '{p_size}'")


def get_image(provider, conn, p_image):
    try:
        if provider == "ec2":
            images = conn.list_images(ex_image_ids={p_image})
        else:
            images = conn.list_images()
    except Exception as e:
        exit_message(str(e), 1)

    for i in images:
        if i.id == p_image:
            return i

    exit_message(f"Invalid image '{p_image}'")


def get_node_values(provider, metro, name):
    prvdr, conn, section, metro, project = get_connection(provider, metro)
    nd = get_node(conn, name)
    if not nd:
        return None, None, None, None, None
    try:
        name = str(nd.name)
        public_ip = str(nd.public_ips[0])
        status = str(nd.state)
        location = None
        size = None
        if provider == "eqnx":
            country = str(nd.extra["facility"]["metro"]["country"]).lower()
            az = str(nd.extra["facility"]["code"])
            location = str(f"{country}-{az}")
            size = str(nd.size.id)
        else:
            location = nd.extra["availability"]
            size = nd.extra["instance_type"]
    except Exception as e:
        exit_message(str(e), 1)

    return (name, public_ip, status, location, size)


def get_node(conn, name):
    nodes = conn.list_nodes()
    for n in nodes:
        if n.state in ("terminated", "unknown"):
            continue
        if name == n.name:
            return n

    return None


def destroy_node(provider, name, metro):
    """Destroy a node."""
    node_action("destroy", provider, name, metro)
    return


def node_action(action, provider, name, location):
    prvdr, conn, section, metro, project = get_connection(provider, location)

    nd = get_node(conn, name)
    if nd:
        try:
            if action == "destroy":
                message(f"Destroying node '{provider}:{name}:{location}'")
                rc = conn.destroy_node(nd)
            elif action == "stop":
                message(f"Stopping node '{provider}:{name}:{location}'")
                rc = conn.stop_node(nd)
            elif action == "start":
                message(f"Starting node '{provider}:{name}:{location}'")
                rc = conn.start_node(nd)
            elif action == "reboot":
                message(f"Rebooting node '{provider}:{name}:{location}'")
                rc = conn.reboot_node(nd)
            else:
                exit_message(f"Invalid action '{action}'")

        except Exception as e:
            exit_message(str(e), 1)

        return rc

    exit_message(f"Node '{provider}:{name}:{location}' not found", 1)


def is_node_unique(name, prvdr, conn, sect):
    if prvdr == "equinixmetal":
        project = sect["project"]
        nodes = conn.list_nodes(project)
    else:
        nodes = conn.list_nodes()

    for n in nodes:
        if n.name == name:
            return False

    return True


def create_node(
    provider, metro, name, size=None, image=None, ssh_key=None, project=None, json=False
):
    """Create a node."""

    prvdr, conn, sect, metro, project = get_connection(provider, metro, project)

    if not is_node_unique(name, prvdr, conn, sect):
        exit_message(f"Node '{name}' already exists in '{prvdr}:{metro}'")

    if prvdr == "equinixmetal":
        if size is None:
            size = sect["size"]
        if image is None:
            image = sect["image"]
        if project is None:
            project = sect["project"]

        create_node_eqnx(name, metro, size, image, project)

    elif prvdr == "ec2":
        if flavor is None:
            flavor = sect["flavor"]
        if image is None:
            my_image = f"image-{metro}"
            print(sect)
            image = sect[my_image]
        if keyname is None:
            keyname = sect["keyname"]
        if project:
            exit_message("'project' is not a valid AWS parm", 1)

        create_node_aws(name, metro, flavor, image, ssh_key)

    else:
        exit_message(f"Invalid provider '{prvdr}' (create_node)")

    return


def create_node_aws(name, metro, flavor, image, keyname):
    prvdr, conn, section, metro, project = get_connection("aws", metro)
    sz = get_size(conn, flavor)
    im = get_image("aws", conn, image)

    try:
        conn.create_node(name=name, image=im, size=flavor, ex_keyname=keyname)
    except Exception as e:
        exit_message(str(e), 1)

    return


def create_node_eqnx(name, location, flavor, image, project):
    prvdr, conn, section, metro, project = get_connection("eqnx")
    sz = get_size(conn, flavor)
    im = get_image("eqnx", conn, image)

    loct = get_location(location)

    try:
        conn.create_node(
            name=name, image=im, size=flavor, location=loct, ex_project_id=project
        )
    except Exception as e:
        exit_message(str(e), 1)

    return


def start_node(provider, name, metro):
    """Start a node."""
    node_action("start", provider, name, metro)
    return


def stop_node(provider, name, metro):
    """Stop a node."""
    node_action("stop", provider, name, metro)
    return


def reboot_node(provider, name, metro):
    """Reboot a node."""
    node_action("reboot", provider, name, metro)
    return


def cluster_nodes(cluster_name, providers, metros, node_names):
    """Create a Cluster definition json file from a set of nodes."""

    message(
        f"\n# cluster-nodes(cluster_name={cluster_name}, providers={providers}, metros={metros}, node_names={node_names})"
    )

    if not isinstance(providers, list) or len(providers) < 2:
        exit_message(
            f"providers parm '{providers}' must be a square bracketed list with two or more elements",
            1,
        )

    if not isinstance(metros, list) or len(metros) < 2:
        exit_message(
            f"metros parm '{metros}' must be a square bracketed list with two or more elements",
            1,
        )

    if not isinstance(node_names, list) or len(node_names) < 2:
        exit_message(
            f"node_names parm '{node_names}' must be a square bracketed list with two or more elements",
            1,
        )

    if (not len(providers) == len(metros)) or (not len(providers) == len(node_names)):
        s1 = f"providers({len(providers)}), metros({len(metros)}), and node_names({len(node_names)})"
        exit_message(f"{s1} parms must have same number of elements")

    if len(node_names) != len(set(node_names)):
        exit_message(f"node_names ({node_names}) must be unique")

    node_kount = len(providers)
    i = 0
    while i < node_kount:
        message(f"\n## {providers[i]}, {metros[i]}, {node_names[i]}")
        prvdr, conn, section = get_connection(providers[i], metros[i])

        name, public_ip, status, metro, size = get_node_values(
            providers[i], metros[i], node_names[i]
        )
        if not name:
            exit_message(
                f"Node ({providers[i]}, {metros[i]}, {node_names[i]}) not available"
            )

        message(f"### {name}, {public_ip}, {status}, {metro}, {size}")

        i = i + 1

    return


def list_sizes(provider, metro=None, project=None, json=False):
    """List available node sizes."""
    prvdr, conn, sect, metro, project = get_connection(provider, metro, project)

    sizes = conn.list_sizes()
    sl = []
    for s in sizes:
        price = s.price
        if price is None:
            price = 0
        ram = s.ram
        if ram is None:
            ram = 0
        bandwidth = s.bandwidth
        if bandwidth is None or str(bandwidth) == "0":
            bandwidth = ""
        sl.append([s.id, round(ram/1024), s.disk, bandwidth, round(price, 1)])

    p = PrettyTable()
    p.field_names = ["ID", "RAM", "Disk", "Bandwidth", "Hourly Price"]
    p.add_rows(sl)
    output_table(p, json)


def list_locations(provider, metro=None, project=None, json=False):
    """List available locations."""
    prvdr, conn, sect, metro, project = get_connection(provider, metro, project, json)

    locations = conn.list_locations()
    for ll in locations:
        print(f"{ll.name.ljust(15)} {ll.id}")


def list_nodes(provider, metro=None, project=None, json=False):
    """List nodes."""
    prvdr, conn, sect, metro, project = get_connection(provider, metro, project)

    nl = []
    if prvdr in ("equinixmetal"):
        nl = eqnx_node_list(conn, metro, project, json)
    elif prvdr in ("ec2"):
        nl = aws_node_list(conn, metro, project, json)
    else:
        exit_message(f"Invalid provider '{prvdr}' (list_nodes)")

    p = PrettyTable()
    p.field_names = ["Provider", "Name", "Status", "Size", "Country", "Metro", "Location", "Public IP", "Private IP"]
    p.align["Name"] = "l"
    p.align["Size"] = "l"
    p.align["Public IP"] = "l"
    p.align["Private IP"] = "l"
    p.add_rows(nl)
    output_table(p, json)

    return


def aws_node_list(conn, metro, project, json):
    try:
        nodes = conn.list_nodes()
    except Exception as e:
        exit_message(str(e), 1)

    nl = []
    for n in nodes:
        name = n.name
        try:
            public_ip = n.public_ips[0]
        except Exception:
            public_ip = ""
        try:
            private_ip = n.private_ip[0]
        except Exception:
            private_ip = ""
        status = n.state
        location = n.extra["availability"]
        size = n.extra["instance_type"]
        country = metro[:2]
        metro = metro
        key_name = n.extra['key_name']
        nl.append(["ec2", name, status, size, country, metro, location, public_ip, private_ip])

    return(nl)


def eqnx_node_list(conn, metro, project, json):
    nodes = conn.list_nodes(project)

    nl = []
    for n in nodes:
        name = n.name
        public_ip = n.public_ips[0]
        private_ip = n.private_ips[0]
        size = str(n.size.id)
        country = str(n.extra["facility"]["metro"]["country"]).lower()
        metro = f"{n.extra['facility']['metro']['name']} ({n.extra['facility']['metro']['code']})"
        location = n.extra["facility"]["code"]
        status = n.state
        nl.append(["equinixmetal", name, status, size, country, metro, location, public_ip, private_ip])

    return(nl)


def list_providers(metro=None, project=None, json=False):
    """List supported cloud providers."""

    p = PrettyTable()

    p.field_names = ["Provider", "Description"]
    p.add_rows(PROVIDERS)
    output_table(p, json)
    return


def output_table(tbl, json):
    if json:
        print(tbl.get_json_string())
    else:
        print(tbl)

    return


if __name__ == "__main__":
    fire.Fire(
        {
            "list-providers": list_providers,
            "list-nodes":     list_nodes,
            "list-locations": list_locations,
            "list-sizes":     list_sizes,
            "create-node":    create_node,
            "start-node":     start_node,
            "stop-node":      stop_node,
            "reboot-node":    reboot_node,
            "destroy-node":   destroy_node,
        }
    )
