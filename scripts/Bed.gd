extends Node2D

enum Side {RIGHT, LEFT}

onready var sprite = $Sprite
export(String, FILE) var move_to
export(Side) var respawn
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if(body.name == "Player"):
		#start dream flag as true
		GameManager.dream_flag = true
		#remember which scene we slept in
		GameManager.bed_return_scene = get_tree().current_scene.filename
		#store where to wake up 
		GameManager.wake_up_global_pos = global_position
		match respawn:
			Side.RIGHT:
				GameManager.wake_up_global_pos.x += sprite.texture.get_width() / 1.5
			Side.LEFT:
				GameManager.wake_up_global_pos.x -= sprite.texture.get_width() / 1.5
		GameManager.goto_scene(move_to)
