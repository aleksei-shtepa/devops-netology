import requests

superhero = ["Hulk", "Captain America", "Thanos"]

if __name__ == "__main__":
    ihero_name = ""
    ihero = 0

    for name in superhero:
        res = requests.get(f"https://superheroapi.com/api/2619421814940190/search/{name}")
        h = res.json()
        for hero in h['results']:
            print(f"{hero['name']} {hero['powerstats']['intelligence']} {'+' if name == hero['name'] else '-'}")
            intelligence = int(hero['powerstats']['intelligence'])
            if name == hero['name'] and intelligence > ihero:
                ihero = intelligence
                ihero_name = hero['name']
    print(f"Самый умный: {ihero_name} ({ihero})")

