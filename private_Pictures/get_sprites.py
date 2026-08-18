# pokemon_sprites.py
#
# Usage:
#   python pokemon_sprites.py pikachu gengar charizard
#   python pokemon_sprites.py --cool100
#
# Requirements:
#   pip install requests

import argparse
import sys
import time
from pathlib import Path

import requests

SAVE_DIR = Path("pokemon_sprites")

# ------------------------------
# 100 visually cool Pokémon (fan favourites + modern designs)
# ------------------------------
COOL_POKEMON = [
    "charizard",
    "gengar",
    "dragonite",
    "mewtwo",
    "mew",
    "tyranitar",
    "lucario",
    "garchomp",
    "greninja",
    "rayquaza",
    "kyogre",
    "groudon",
    "darkrai",
    "arceus",
    "zoroark",
    "hydreigon",
    "haxorus",
    "volcarona",
    "genesect",
    "noivern",
    "goodra",
    "aegislash",
    "dragapult",
    "toxtricity",
    "corviknight",
    "grimmsnarl",
    "urshifu",
    "calyrex",
    "zacian",
    "zamazenta",
    "eternatus",
    "necrozma",
    "lunala",
    "solgaleo",
    "guzzlord",
    "xurkitree",
    "blacephalon",
    "naganadel",
    "kartana",
    "buzzwole",
    "nihilego",
    "mimikyu",
    "decidueye",
    "incineroar",
    "lycanroc",
    "salazzle",
    "golisopod",
    "kommo-o",
    "palossand",
    "bisharp",
    "kingambit",
    "annihilape",
    "tinkaton",
    "ceruledge",
    "armarouge",
    "meowscarada",
    "skeledirge",
    "quaquaval",
    "iron-valiant",
    "roaring-moon",
    "koraidon",
    "miraidon",
    "walking-wake",
    "raging-bolt",
    "gouging-fire",
    "iron-boulder",
    "iron-crown",
    "terapagos",
    "ogerpon",
    "pecharunt",
    "chi-yu",
    "ting-lu",
    "chien-pao",
    "wo-chien",
    "gholdengo",
    "dondozo",
    "tatsugiri",
    "baxcalibur",
    "clodsire",
    "farigiraf",
    "wugtrio",
    "toedscruel",
    "scovillain",
    "cetitan",
    "palafin",
    "cyclizar",
    "orthworm",
    "garganacl",
    "revavroom",
    "slither-wing",
    "sandy-shocks",
    "flutter-mane",
    "brute-bonnet",
    "great-tusk",
    "scream-tail",
][
    :100
]  # ensure exactly 100


# ------------------------------
# Helper functions
# ------------------------------
def get_gen5_static_sprite_url(pokemon_name: str) -> str | None:
    """
    Return URL of the Generation 5 (Black/White) static front sprite.
    """
    api_url = f"https://pokeapi.co/api/v2/pokemon/{pokemon_name.lower()}"
    try:
        response = requests.get(api_url, timeout=10)
        if response.status_code != 200:
            return None
        data = response.json()
        # Navigate to the Gen 5 static sprite URL
        # The path is: sprites.versions['generation-v']['black-white']['front_default']
        gen5_sprites = (
            data.get("sprites", {})
            .get("versions", {})
            .get("generation-v", {})
            .get("black-white", {})
        )
        static_sprite = gen5_sprites.get("front_default")
        if static_sprite:
            return static_sprite
        else:
            print(
                f"[!] No Gen 5 static sprite found for: {pokemon_name}. Falling back to default sprite."
            )
            return data.get("sprites", {}).get("front_default")
    except Exception as e:
        print(f"[!] Error fetching sprite for {pokemon_name}: {e}")
        return None


def download_sprite(pokemon_name: str):
    """Download a single Gen 5 static sprite and save to SAVE_DIR."""
    try:
        sprite_url = get_gen5_static_sprite_url(pokemon_name)
        if not sprite_url:
            print(f"[!] No sprite found for: {pokemon_name}")
            return
        img_data = requests.get(sprite_url, timeout=10).content
        SAVE_DIR.mkdir(exist_ok=True)
        out_path = SAVE_DIR / f"{pokemon_name.lower()}.png"
        with open(out_path, "wb") as f:
            f.write(img_data)
        print(f"[+] Saved -> {out_path}")
        time.sleep(0.2)  # be polite to the API
    except Exception as e:
        print(f"[!] Failed for {pokemon_name}: {e}")


# ------------------------------
# Main
# ------------------------------
def main():
    parser = argparse.ArgumentParser(
        description="Download Generation 5 static Pokémon sprites"
    )
    parser.add_argument("pokemon", nargs="*", help="Name(s) of Pokémon to download")
    parser.add_argument(
        "--cool100", action="store_true", help="Download 100 of the coolest Pokémon"
    )
    args = parser.parse_args()

    if args.cool100:
        print(f"Downloading 100 cool Pokémon to '{SAVE_DIR}/' ...")
        for name in COOL_POKEMON:
            download_sprite(name)
        print("Done!")
    elif args.pokemon:
        for name in args.pokemon:
            download_sprite(name)
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
