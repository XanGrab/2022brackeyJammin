extends VBoxContainer

var options : Array

onready var selectorNode = $"Option1/SelectorContainer/FreeRotate/Selector"

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, 4):
		options.append(get_child(i))

# called when the player uses arrow keys to select a different option
func _on_option_change(selected):
	move_selector(selected)

func _on_display_options(choices):
	visible = true
	move_selector(0)
	load_options(choices)
	

func _on_display_text():
	visible = false

# move selector to updated option
func move_selector(selected):
	selectorNode.get_parent().remove_child(selectorNode)
	options[selected].get_node("SelectorContainer/FreeRotate").add_child(selectorNode)
	selectorNode.rect_position = Vector2()

# iterates through all the options presented and loads them into the text nodes
func load_options(choices):
	var i = 0
	for option in choices.option_text:
		options[i].get_node("TextContainer/Text").bbcode_text = option
		options[i].visible = true
		i += 1
	
	while(i < 4):
		options[i].visible = false
		i += 1
