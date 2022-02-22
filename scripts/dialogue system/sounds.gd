# "sounds.gd"
# Manages which sounds to play for the dialogue system.

extends Node2D

onready var dialogue_scroll : AudioStreamPlayer = $"Dialogue Scroll"
onready var option_select : AudioStreamPlayer = $"Select"
onready var option_change : AudioStreamPlayer = $"Change Option"
onready var dialogue_advance : AudioStreamPlayer = $"Advance"

func _trigger_scroll_sound():
	dialogue_scroll.play()

func _on_option_select():
	option_select.play()

func _on_option_change(_selection):
	option_change.play()

func _on_dialogue_advance(_new_dialogue):
	dialogue_advance.play()

func _on_display_options(_choices):
	dialogue_advance.play()

func _on_dialogue_close():
	dialogue_advance.play()
