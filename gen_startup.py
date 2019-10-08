#!/usr/bin/env python
# coding: utf-8

import argparse
from jinja2 import Environment, FileSystemLoader
import sys


def parse():
    parser = argparse.ArgumentParser('generate startup-script for SAKURA VPS')
    parser.add_argument('-u', '--user')
    parser.add_argument('-i', '--id_rsa_pub')
    args = parser.parse_args()
    if (args.user is None or args.id_rsa_pub is None):
        emsg = "USER and ID_RSA_PUB parameters are required."
        sys.stderr.write(emsg + "\n")
        sys.exit(1)
    return args.user, args.id_rsa_pub


def template(user, id_rsa_pub):
    env = Environment(loader=FileSystemLoader('./'))
    tmpl = env.get_template('startup.sh.j2')
    value = {
        "user": user,
        "id_rsa_pub": id_rsa_pub
    }
    return tmpl.render(value)


if __name__ == '__main__':
    user, id_rsa_pub = parse()
    print(template(user, id_rsa_pub))
