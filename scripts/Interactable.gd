# this class will hopefully provide a superclass that
# we can extend in case we want to add other features to
# interaction with any entity
#
# currently, the class allows for a piece of dialogue to be 
# played when the object is interacted with

extends CollisionObject2D

export(String, FILE, "*.txt") var dialogue_filename : String

const dialogue_foldername = "res://Dialogue Files"

func _ready():
	collision_layer = 2;
	
	var file_check = File.new()
	
	if (!file_check.file_exists(get_file_path()) && get_file_path() != ""):
		push_error("file \"" + get_file_path() + "\" does not exist.")

# this method should be overridden if any extra functionality
# is to be added when interacting with this entity
func _on_interact() :
	pass
	
func get_file_path() -> String:
	return dialogue_filename
