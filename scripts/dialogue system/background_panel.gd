# this code simply resizes the background panel when
# the options are displayed.
extends Panel

func _on_display_options(choices):
	rect_min_size.y = 30 + (choices.option_text.size() * 10)

func _on_display_text():
	rect_min_size.y = 50
