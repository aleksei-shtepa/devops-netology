
def get_shop_list_by_dishes(dishes, person_count):
    cook_book = get_cook_book()
    foods = {}
    for dish in dishes:
        if dish in cook_book:
            ingredients = cook_book[dish]
            for ingredient in ingredients:
                name = ingredient['ingredient_name']
                quantity = ingredient['quantity'] * person_count
                if foods.get(name):
                    quantity += foods[name]['quantity']
                foods[name] = {'measure':ingredient['measure'], 'quantity':quantity}
    print(foods)
                



def get_cook_book():
    cook_book = {}
    with open("devpy/recipes.txt", "r") as f:
        line = f.readline().strip()
        while line != '':
            name = line
            amount = int(f.readline().strip())
            ingredients = []
            for i in range(amount):
                record = f.readline().split("|")
                ingredients.append({
                        "ingredient_name": record[0].strip(),
                        "quantity": int(record[1].strip()),
                        "measure": record[2].strip()
                    })
            f.readline()
            cook_book[name] = ingredients
            line = f.readline().strip()
    
    return cook_book

if __name__ == "__main__":
    # print(get_cook_book())
    get_shop_list_by_dishes(['Запеченный картофель', 'Омлет'], 2)
