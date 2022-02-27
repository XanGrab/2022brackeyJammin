extends Node

enum Item {KEY, BRACELET, BADGE}

#inventory
#0-key, 1-bracelet, 2-badge
var inventory_flags = [false, false, false]
var dream_flag = false

#What does this do again lol
var current_scene = null

#store which scene we went to sleep in
var bed_return_scene = null
#store wake up position in relation to bed
var wake_up_global_pos = null

#declare door stuf
var door_to: String
var door =  null

# Called when the node enters the scene tree for the first time.
func _ready():
	#get root
	var root = get_tree().get_root()
	#set current to current scene
	current_scene = root.get_child(root.get_child_count() - 1)
	
	
# warning-ignore:return_value_discarded
	SignalBus.connect("item_picked_up", self, "on_item_picked_up")
	

func on_item_picked_up(type):
	inventory_flags[type] = true


#our function for switching scenes
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func spawn_to_door():	
	call_deferred("_deferred_spawn")

func respawn_to_bed():
	if !dream_flag:
		call_deferred("_deferred_respawn_to_bed")

func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	print(path)
	var s = ResourceLoader.load(path)

	# Instance the new scene.

	#if it crashes here you forgot to set .tscn for move_to export var
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

func _deferred_respawn_to_bed():
	var player = get_tree().get_current_scene().find_node("Player")
	player.global_position = GameManager.wake_up_global_pos

func _deferred_spawn():
	#find door node according to its name in door_to
	door = get_tree().get_current_scene().find_node(door_to)
	#grab player node and player's position to door spawn 
	var player = get_tree().get_current_scene().find_node("Player")
	player.global_position = door.spawn[door.current_spawn_side].global_position
