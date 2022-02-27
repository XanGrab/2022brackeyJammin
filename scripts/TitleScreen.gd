extends Control

onready var play_button = $Menu/Buttons/PlayButton
onready var credit_button = $Menu/Buttons/CreditButton
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_CreditButton_pressed():
	GameManager.goto_scene(credit_button.scene_to_load)


func _on_PlayButton_pressed():
	GameManager.goto_scene(play_button.scene_to_load)
