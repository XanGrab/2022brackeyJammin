extends Node

# this autoload class stores the data of all NPCs in the game
# so that the data persists across scenes.

var _npc_state_data : Dictionary = {}


# gets the state of an npc (assuming it is stored)
func get_state(npc_name : String) -> int:
	return _npc_state_data.get(npc_name)

# increases the state of an npc by 1
func increment_state(npc_name : String) -> void:
	_npc_state_data[npc_name] += 1

# registers the state of npc in the dict
func register_npc(npc_name : String) -> void:
	_npc_state_data[npc_name] = 0

# checks if an npc's state is stored
func contains_data(npc_name : String) -> bool:
	return _npc_state_data.has(npc_name)
