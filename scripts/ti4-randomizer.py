#!/usr/bin/env python3

import random
import argparse

base = [
            "Xxcha kingdom",
            "Barony of Letnev",
            "Federation of Sol",
            "Emirates of Hacan",
            "Sardakk N'orr",
            "Universities of Jol-Nar",
        ]

factions = [
            "Arborec",
            "Clan of Saar",
            "Embers of Muaat",
            "Ghosts of Creuss",
            "L1Z1X Mindnet",
            "Mentak coalition",
            "Naalu collective",
            "Nekro virus",
            "The Winnu",
            "Yin brotherhood",
            "Yssaril tribes",
        ]

expansion_factions = [
            "Argent flight",
            "Empyrean",
            "Mahact gene sorceres",
            "Naaz-Rokha Alliance",
            "Nomad",
            "Titans of UI",
            "Vuil'Raith Cabal",
        ]

def main():
    parser = argparse.ArgumentParser(description="Randomize TI4 factions")
    parser.add_argument('--new_players', nargs='+', help='Only give these players base factions')
    parser.add_argument('--players', required=True, nargs='+', help='list of players (excluding new players)')
    parser.add_argument('--use_pok', action='store_true', help='Use POK factions')
    parser.add_argument('--options', type=int, default=2, help='Number of options per player')
    args = parser.parse_args()
    players = list(args.players)
    new_players = list(args.new_players) if args.new_players is not None else list()
    assert args.options * len(players + new_players) < len(base + factions + expansion_factions)

    random.shuffle(base)
    for player in new_players:
        dealt = [ base.pop() for _ in range(args.options) ]
        print(f'{player}: {dealt}')

    factions.extend(base)
    if args.use_pok: factions.extend(expansion_factions)
    random.shuffle(factions)

    for player in players:
        dealt = [factions.pop() for _ in range(args.options)]
        print(f'{player}: {dealt}')

if __name__ == '__main__': main()
