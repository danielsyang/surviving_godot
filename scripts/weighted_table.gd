class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum: int = 0

func add_item(item, weight: int) -> void:
    items.append({"item": item, "weight": weight})
    weight_sum += weight

func remove_item(item_to_remove):
    items = items.filter(func(item: Dictionary):
        return item["item"] != item_to_remove
    )

    for item in items:
        weight_sum += item["weight"]

func pick_random_item(exclude: Array = []):
    var adjusted_items: Array[Dictionary] = items
    var adjusted_weight_sum = weight_sum

    if exclude.size() > 0:
        adjusted_items = []

        for item in items:
            if item["item"] in exclude:
                continue
            adjusted_items.append(item)
            adjusted_weight_sum += item["weight"]

    var chosen_weight = randi_range(1, adjusted_weight_sum)
    var iteration_sum = 0

    for item in adjusted_items:
        iteration_sum += item["weight"]
        if chosen_weight <= iteration_sum:
            return item["item"]

    return null
