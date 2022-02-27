extends "res://scripts/Interactable.gd"

export(String) var npc_name
export(Array, String, FILE, "*.txt") var filePaths

func _ready():
	if(!NpcManager.contains_data(npc_name)):
		NpcManager.register_npc(npc_name)

func _on_interact():
	print("hello!")
	var state : int = NpcManager.get_state(npc_name)
	
	# prevent IooB exception
	if(state >= filePaths.size()):
		state = filePaths.size() - 1
	
	if(check_file_existence(filePaths[state])):
		DialogueSystem.read_from_file_path(filePaths[state])

func increment_state():
	NpcManager.increment_state(npc_name)
	
func _input(_event):
	if(Input.is_key_pressed(KEY_2)):
		print("state incremented")
		increment_state()
