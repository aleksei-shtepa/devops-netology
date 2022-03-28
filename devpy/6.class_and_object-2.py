'''
Задача №2 "Аудиоколлекция"
Необходимо уметь хранить информацию по альбомам и трекам в них. Это можно сделать, используя классы Album и Track.
У класса Track есть поля:

Название;
Длительность в минутах(используется тип данных int). И метод show, выводящий информацию по треку в виде <Название-Длительность>.
У класса Album есть поля:

Название альбома
Группа
Список треков И три метода:
get_tracks - выводит информацию по всем трекам(используется метод show).
add_track - добавление нового трека в список треков.
get_duration - выводит длительность всего альбома.
Задание:
Создать 2 альбома с 3 треками. Для каждого вывести его длительность.
'''

class Track:
    def __init__(self, name:str, amount:int=0):
        self.name = name
        self.amount = amount
    
    def show(self):
        print(f"{self.name} - {self.amount}")

class Album:
    def __init__(self, name:str, tracks:list=list()):
        self.name = name
        self.tracks = tracks
    
    def get_tracks(self):
        for tr in self.tracks:
            tr.show()

    def add_track(self, track:Track):
        if isinstance(track, Track):
            self.tracks.append(track)

    def get_duration(self):
        amount = 0
        for tr in self.tracks:
            amount += tr.amount
        print(f"Общая длительность альбома: {amount}")

album1 = Album("New album")
album1.add_track(Track("new_track-1", 14))
album1.add_track(Track("new_track-2", 10))
album1.add_track(Track("new_track-3", 26))

album2 = Album("Old album", [Track("old_track-1", 14), Track("old_track-2", 24), Track("old_track-3", 34)])

album1.get_tracks()
album1.get_duration()

print()

album2.get_tracks()
album2.get_duration()
