extends Node2D

export(String, FILE) var move_to
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _on_Area2D_body_entered(body):
    GameManager.goto_scene(move_to)
