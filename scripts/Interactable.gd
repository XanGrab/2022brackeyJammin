# this class will hopefully provide a superclass that
# we can extend in case we want to add other features to
# interaction with any entity
#
# currently, the class allows for a piece of dialogue to be 
# played when the object is interacted with

extends CollisionObject2D

export(String, FILE, "*.txt") var dialogue_filename : String

const INTERACTION_COLLISION_LAYER = 2

onready var root = get_tree().get_root()
onready var dialogue_system = $"/root".get_child(root.get_child_count() - 1).get_node("CanvasLayer/Dialogue System")

func _ready():
    collision_layer = INTERACTION_COLLISION_LAYER;
    
    # warning-ignore:return_value_discarded
    check_file_existence()

# this method should be overridden if any extra functionality
# is to be added when interacting with this entity
func _on_interact() :
    queue_dialogue()

func check_file_existence() -> bool:
    if(dialogue_filename == ""):
        return false
    
    var file_check = File.new()
    
    if (!file_check.file_exists(dialogue_filename)):
        push_error("file \"" + dialogue_filename + "\" does not exist.")
        return false
    
    return true



func queue_dialogue():
    if(check_file_existence()):
        dialogue_system.read_from_file_path(dialogue_filename)
