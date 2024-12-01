#!/usr/bin/env python3

from argparse import ArgumentParser
from pathlib import Path

def main():
    parser = ArgumentParser(prog='{{cookiecutter.program_name}}',
                            description='{{cookiecutter.project_description}}')
    parser.add_argument('-f', '--file', nargs='?', help='Input file', type=Path, required=True)
    args = parser.parse_args()
    print(f'Hello, world: {args.file}')

if __name__ == '__main__':
    main()
