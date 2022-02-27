extends Node2D

enum Side {BOTTOM, TOP, RIGHT, LEFT}

export(String, FILE) var move_to 
export(String) var door_to_name
export(Side) var current_spawn_side


onready var spawn = [$Bottom, $Top, $Right, $Left]

var key = GameManager.Item.KEY

func _on_Area2D_body_entered(body):
	if move_to != null:
		if body.name == "Player" && (GameManager.inventory_flags[key] || !GameManager.dream_flag):
			GameManager.door_to = door_to_name
			GameManager.goto_scene(move_to)
			GameManager.spawn_to_door()
