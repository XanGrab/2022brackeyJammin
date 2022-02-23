extends Node2D


onready var collision= $StaticBody2D/CollisionShape2D

var badge = GameManager.Item.BADGE

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect signal to listen for item_pick_up
	SignalBus.connect("item_picked_up", self, "on_item_picked_up")
	
	#check for badge flag
	if GameManager.inventory_flags[badge]:
		collision.set_deferred("disabled", true)
	else:
		collision.set_deferred("disabled", false)

func on_item_picked_up(type):
	#check badge flag at pick up
	if type == badge:
		collision.set_deferred("disabled", true)
	else:
		collision.set_deferred("disabled", false)
