extends RayCast2D

# script that attaches to player and interacts with other objects
const Interactable = preload("res://scripts/Interactable.gd")

const RAY_LENGTH = 12

onready var player = $".." # gets reference to player_movement.gd

func _physics_process(_delta):
	cast_to = player.direction * RAY_LENGTH
		
func interact():
	if(is_colliding()):
		var collider = get_collider()
		if(collider is Interactable):
			var file_path = collider.get_file_path()
			if(file_path != ""):
				player.dialogue_system.read_from_file_path(collider.get_file_path())
			
			collider._on_interact()
