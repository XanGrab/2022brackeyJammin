extends Node2D

export(String, FILE) var move_to

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("wake_up"):
		GameManager.goto_scene(move_to)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
