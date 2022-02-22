extends Control

onready var nameTagText : RichTextLabel = $"Name Tag/Text"
onready var nameTagPanel : Panel = $"Name Tag"

func _on_dialogue_advance(new_dialogue):
	if new_dialogue.name_tag == "NoTag":
		nameTagPanel.visible = false
	else:
		# if name unspecified, leave as is
		if new_dialogue.name_tag != "":
			nameTagPanel.visible = true
			nameTagText.bbcode_text = "[center]" + new_dialogue.name_tag + "[/center]"


func _on_display_options(_choices):
	visible = false


func _on_display_text():
	visible = true
