extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var key_label = $Panel/MarginContainer/GridContainer/Key
onready var bracelet_label = $Panel/MarginContainer/GridContainer/Bracelet
onready var badge_label = $Panel/MarginContainer/GridContainer/Badge
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("item_picked_up", self, "on_item_picked_up")
	get_tree().call_group("items", "hide")

func on_item_picked_up(type):
	match type:
		GameManager.Item.KEY:
			key_label.show()
		GameManager.Item.BRACELET:
			bracelet_label.show()
		GameManager.Item.BADGE:
			badge_label.show()          
