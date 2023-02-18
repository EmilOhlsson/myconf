#!/usr/bin/env python

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
            "Council Keleres",
        ]

def main():
    parser = argparse.ArgumentParser(description="Randomize TI4 factions")
    parser.add_argument('--new_players', nargs='+', help='Only give these players base factions')
    parser.add_argument('--players', nargs='+', help='list of players (excluding new players)')
    parser.add_argument('--use_pok', action='store_true', help='Use POK factions')
    parser.add_argument('--options', type=int, default=2, help='Number of options per player')
    args = parser.parse_args()

    rosters = dict()
    random.shuffle(base)
    if args.new_players is not None:
        assert len(args.new_players) * args.options <= len(base), \
                "Not enough factions to deal to new players"
        for player in args.new_players:
            rosters[player] = [ base.pop() for _ in range(args.options) ]

    factions.extend(base)
    if args.use_pok: factions.extend(expansion_factions)
    random.shuffle(factions)

    if args.players is not None:
        assert len(args.players) * args.options <= len(factions), \
                "Not enough factions to deal to players"
        for player in args.players:
            rosters[player] = [factions.pop() for _ in range(args.options)]

    assert len(rosters) > 0, "No players got any roster"

    # Print dealing
    for (player, roster) in rosters.items():
        print(f'{player}: {roster}')


if __name__ == '__main__':
    try:
        main()
    except AssertionError as e:
        print(f'Error creating rosters: {e}')
