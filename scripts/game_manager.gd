extends Node

enum Item {KEY, BRACELET, BADGE}

#inventory
#0-key, 1-bracelet, 2-badge
var inventory_flags = [false, false, false]

# Called when the node enters the scene tree for the first time.
func _ready():
    SignalBus.connect("item_picked_up", self, "on_item_picked_up")
    

func on_item_picked_up(type):
    inventory_flags[type] = true
    print(inventory_flags)

