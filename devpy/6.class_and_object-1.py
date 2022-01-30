'''
Вы приехали помогать на ферму Дядюшки Джо и видите вокруг себя множество разных животных:

гусей "Серый" и "Белый"
корову "Маньку"
овец "Барашек" и "Кудрявый"
кур "Ко-Ко" и "Кукареку"
коз "Рога" и "Копыта"
и утку "Кряква"
Со всеми животными вам необходимо как-то взаимодействовать:

кормить
корову и коз доить
овец стричь
собирать яйца у кур, утки и гусей
различать по голосам(коровы мычат, утки крякают и т.д.)

Задача №1
Нужно реализовать классы животных, не забывая использовать наследование, определить
общие методы взаимодействия с животными и дополнить их в дочерних классах, если потребуется.

Задача №2
Для каждого животного из списка должен существовать экземпляр класса.
Каждое животное требуется накормить и подоить/постричь/собрать яйца, если надо.

Задача №3
У каждого животного должно быть определено имя(self.name) и вес(self.weight).

Необходимо посчитать общий вес всех животных(экземпляров класса);
Вывести название самого тяжелого животного.

'''


class Animals():
    sound = ""
    name = ""

    def __init__(self, name, weight=0):
        self.name = name
        self.weight = weight

    def feed(self):
        print(f"{self.name}: Nyam-nyam")

    def voice(self):
        print(f"{self.name}: {self.sound}")

class Bird(Animals):
    def get_egg(self):
        print("Take one egg.")

class Milked(Animals):
    def milk(self):
        print("Take the bottle of milk.")

class Sheared(Animals):
    def shear(self):
        print("Take wool.")

class Goos(Bird):
    def __init__(self, name, weight=0):
        super().__init__(name, weight)
        self.sound = "Ga-ga-ga"

class Cow(Milked):
    def __init__(self, name, weight=0):
        super().__init__(name, weight)
        self.sound = "Muu, muuu"

class Sheep(Sheared):
    def __init__(self, name, weight=0):
        super().__init__(name, weight)
        self.sound = "Beeeeee"


class Chicken(Bird):
    def __init__(self, name, weight=0):
        super().__init__(name, weight)
        self.sound = "Ko-koo-ko"


class Goat(Bird):
    def __init__(self, name, weight=0):
        super().__init__(name, weight)
        self.sound = "Meeee, meeeee"

class Duck(Bird):
    def __init__(self, name, weight=0):
        super().__init__(name, weight)
        self.sound = "Krya-krya"


goos1 = Goos("Серый")
goos2 = Goos("Белый")
cow1 = Cow("Манька")
sheep1 = Sheep("Барашек")
sheep2 = Sheep("Кудрявый")
chicken1 = Chicken("Ко-Ко")
chicken2 = Chicken("Кукареку")
goat1 = Goat("Рога")
goat1 = Goat("Копыта")
duck1 = Duck("Кряква")

goos1.voice()
goos1.feed()