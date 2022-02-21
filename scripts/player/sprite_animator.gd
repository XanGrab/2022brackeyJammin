extends AnimatedSprite

onready var parent = get_parent()

func _on_move(state, direction):
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
