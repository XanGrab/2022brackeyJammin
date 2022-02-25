extends RayCast2D

# script that attaches to player and interacts with other objects
const Interactable = preload("res://scripts/Interactable.gd")

const RAY_LENGTH = 8

onready var player = $".." # gets reference to player_movement.gd

signal draw_interact_ray(origin, cast_to)

func _physics_process(_delta):
	cast_to = player.direction * RAY_LENGTH
		
func interact():
	if(is_colliding()):
		var collider = get_collider()
		
		if(collider is Interactable):
			collider._on_interact()
