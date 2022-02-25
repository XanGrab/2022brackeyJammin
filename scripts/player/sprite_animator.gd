extends AnimatedSprite

onready var parent = get_parent()

func _on_move(state, direction, input):
	var anim_name : String  = ""
	match(state):
		parent.PlayerState.IDLE:
			anim_name = "Idle"
		parent.PlayerState.MOVE:
			anim_name = "Walk"
		parent.PlayerState.DIALOGUE:
			anim_name = "Idle"
		parent.PlayerState.SCENETRANSITION:
			anim_name = "Walk"
		parent.PlayerState.PUSHPULL:
			if(isCardinal(input) && abs(input.x) == abs(direction.x)):
				if(input == direction):
					anim_name = "Push"
				else:
					anim_name = "Pull"
			else:
				anim_name = "Grab"
	
	anim_name += "_"
	
	if direction == Vector2(0, -1):
		flip_h = false
		anim_name += "up"
	elif direction == Vector2(0, 1):
		flip_h = false
		anim_name += "down"
	elif direction == Vector2(1, 0):
		flip_h = true
		anim_name += "side"
	else:
		flip_h = false
		anim_name += "side"
		
	play(anim_name)

func isCardinal(vector : Vector2) -> bool:
	vector = Vector2(abs(vector.x), abs(vector.y))
	
	return vector == Vector2(1, 0) || vector == Vector2(0, 1)
