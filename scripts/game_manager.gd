extends Node

enum Item {KEY, BRACELET, BADGE}

#inventory
#0-key, 1-bracelet, 2-badge
var inventory_flags = [false, false, false]

var current_scene = null

# Called when the node enters the scene tree for the first time.
func _ready():
    var root = get_tree().get_root()
    current_scene = root.get_child(root.get_child_count() - 1)
    
    SignalBus.connect("item_picked_up", self, "on_item_picked_up")
    

func on_item_picked_up(type):
    inventory_flags[type] = true
    print(inventory_flags)

func goto_scene(path):
    call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
    # It is now safe to remove the current scene
    current_scene.free()

    # Load the new scene.
    var s = ResourceLoader.load(path)

    # Instance the new scene.
    current_scene = s.instance()

    # Add it to the active scene, as child of root.
    get_tree().get_root().add_child(current_scene)

    # Optionally, to make it compatible with the SceneTree.change_scene() API.
    get_tree().set_current_scene(current_scene)
