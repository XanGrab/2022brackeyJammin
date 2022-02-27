extends "res://scripts/Interactable.gd"

export(String) var npc_name
export(Array, String, FILE, "*.txt") var filePaths

func _ready():
	if(!NpcManager.contains_data(npc_name)):
		NpcManager.register_npc(npc_name)

func _on_interact():
	var state : int = NpcManager.get_state(npc_name)
	
	# prevent IooB exception
	if(state >= filePaths.size()):
		state = filePaths.size() - 1
	
	if(check_file_existence(filePaths[state])):
		DialogueSystem.read_from_file_path(filePaths[state])
	
	if(npc_name == "vanessa" && state == 1):
		SignalBus.emit_signal("item_picked_up", GameManager.Item.BADGE)
		NpcManager.increment_state("vanessa")
	
	if(npc_name == "carmella" && state == 1):
		SignalBus.emit_signal("item_picked_up", GameManager.Item.LEMON)
		NpcManager.increment_state("carmella")
	
	if(npc_name == "josh" && state == 0):
		SignalBus.emit_signal("item_picked_up", GameManager.Item.BRACELET)
		NpcManager.increment_state("josh")

func increment_state():
	NpcManager.increment_state(npc_name)
