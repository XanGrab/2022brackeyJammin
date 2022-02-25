extends Node2D

export(String, FILE) var move_to 

var key = GameManager.Item.KEY

func _on_Area2D_body_entered(body):
	if body.name == "Player" && GameManager.inventory_flags[key]:
		GameManager.goto_scene(move_to)
