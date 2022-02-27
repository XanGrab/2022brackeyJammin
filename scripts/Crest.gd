extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var button = $Button
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	GameManager.goto_scene(button.scene_to_load)
