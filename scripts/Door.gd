extends Node2D

export(String, FILE) var move_to 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var key = GameManager.Item.KEY

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Area2D_body_entered(body):
	if GameManager.inventory_flags[key]:
		GameManager.goto_scene(move_to)
