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
        print(f"{self.name}: Take one egg.")

class Milked(Animals):
    def milk(self):
        print(f"{self.name}: Take the bottle of milk.")

class Sheared(Animals):
    def shear(self):
        print(f"{self.name}: Take wool.")

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


class Goat(Milked):
    def __init__(self, name, weight=0):
        super().__init__(name, weight)
        self.sound = "Meeee, meeeee"

class Duck(Bird):
    def __init__(self, name, weight=0):
        super().__init__(name, weight)
        self.sound = "Krya-krya"


goos1 = Goos("Серый", 5)
goos2 = Goos("Белый", 5)
cow1 = Cow("Манька", 250)
sheep1 = Sheep("Барашек", 50)
sheep2 = Sheep("Кудрявый", 50)
chicken1 = Chicken("Ко-Ко", 3)
chicken2 = Chicken("Кукареку", 3)
goat1 = Goat("Рога", 50)
goat2 = Goat("Копыта", 50)
duck1 = Duck("Кряква", 3)

ani = [goos1, goos2, cow1, sheep1, sheep2, chicken1, chicken2, goat1, goat2, duck1]

print("Всех покормить:")
for a in ani:
    a.feed()

print("\nВсе кричат:")
for a in ani:
    a.voice()

print("\nСбор урожая:")
for a in ani:
    if isinstance(a, Milked):
        a.milk()
    elif isinstance(a, Bird):
        a.get_egg()
    elif isinstance(a, Sheared):
        a.shear()

weight_all = 0
max_animal = ani[0]

for a in ani:
    weight_all += a.weight
    if a.weight > max_animal.weight:
        max_animal = a

print()
print(f"Вес всех животных: {weight_all}кг.")
print(f"Самое тяжёлое животное: {max_animal.name} ({max_animal.weight}кг.)")