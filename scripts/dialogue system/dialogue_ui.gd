# This script manages the functions of the dialogue ui display

extends HBoxContainer

onready var textLabelNode : RichTextLabel = $"Text"
onready var portraitImageNode : TextureRect = $"Portrait Container/Portrait Image"
onready var continueButton : TextureRect = $"Continue Button"

var current_dialogue

# emits when the dialogue has finished scrolling
signal dialogue_scrolled

# emits when scrolling sfx needs to be played
signal scroll_sound

# method is called when scroll_text is emitted
func _on_scroll_text():
	scroll_one_char()

# method is called when scroll_text_fast is emitted
func _on_scroll_text_fast():
	if textLabelNode.visible_characters > 2 || textLabelNode.visible_characters == -1:
		scroll_one_char()
	scroll_one_char()

func _on_dialogue_advance(new_dialogue):
	current_dialogue = new_dialogue
	update_visuals()

# scrolls the text by one character (unless we are in the middle of a pause)
func _on_display_text():
	visible = true

func _on_display_options(_choices):
	visible = false

func scroll_one_char():
	var pauseMap = current_dialogue.pauseData
	var current_index = textLabelNode.visible_characters - 1
	
	# if pause hashmap says we need to pause, don't scroll text, and count down
	if pauseMap.has(current_index) && pauseMap[current_index] > 0:
		pauseMap[current_index] = pauseMap[current_index] - 1
	else:
		textLabelNode.visible_characters += 1
		emit_signal("scroll_sound")
		
		# emit signal when done
		if(is_text_finished()):
			emit_signal("dialogue_scrolled")
			continueButton.modulate.a = 1

# checks if the text is finished scrolling
func is_text_finished() -> bool :
	return textLabelNode.percent_visible >= 1 || textLabelNode.text.length() == 0

# updates the picture, text, and continue button to match the current_dialogue variable
func update_visuals():
	# read from the dialogue object
	textLabelNode.bbcode_text =  current_dialogue.message
	
	# reset text
	textLabelNode.visible_characters = 0
	
	# hide the continue button
	continueButton.modulate.a = 0
	
	# if new picture is specified, change it
	if current_dialogue.name_tag != "":
		portraitImageNode.texture = current_dialogue.picture

