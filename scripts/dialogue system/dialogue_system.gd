
extends Control

# imports the Dialogue class defined in dialogue.gd
const Dialogue = preload("res://scripts/dialogue system/Dialogue.gd")
const OptionSet = preload("res://scripts/dialogue system/OptionSet.gd")

# how fast the dialogue gets typed out on screen (seconds per character)
const CHAR_TYPING_TIME = 0.02

# enum defines state possibilities
enum DialogueState {INACTIVE, OPTIONS, SCROLL_TXT, SCROLL_FIN}

# signals are sent to any other objects that are listening
signal on_dialogue_open
signal on_dialogue_close

# these signals are emitted when changing between text display or options choice display
signal display_options(choices)
signal display_text

# these signals are emitted for dialogue processes
signal scroll_text
signal scroll_text_fast
signal dialogue_advance(new_dialogue)

# these signnals are emitted for option processes
signal option_select
signal option_change(selected)

# typing timer
var typing_timer = 0

var _dialogue_queue = [] # queue of lines to say
var current_dialogue : Dialogue
var _dialogue_state_machine # is true when dialogue is being displayed

onready var _current_options : OptionSet = null
onready var selected : int = 0

# callback recieved when the dialogue system stops scrolling
func _on_dialogue_scrolled():
	set_state(DialogueState.SCROLL_FIN)

# callback method for initialization
func _ready():
	set_state(DialogueState.INACTIVE)

# callback method called every frame
func _process(delta):
	match _dialogue_state_machine:
		DialogueState.SCROLL_TXT:
			if typing_timer > CHAR_TYPING_TIME:
				if Input.is_action_pressed("dialogue_speed"):
					emit_signal("scroll_text_fast")
				else:
					emit_signal("scroll_text")
				typing_timer = 0
			typing_timer += delta

# callback method called on every key press
func _input(event):
	match _dialogue_state_machine:
		DialogueState.SCROLL_FIN:
			if event.is_action_pressed("dialogue_advance"):
				display_next_dialogue()
		
		DialogueState.OPTIONS:
			if(event.is_action_pressed("interact_select")):
				var next_dialogue = _current_options.dialogues[selected]
				if next_dialogue != null:
					_dialogue_queue.push_front(Dialogue.new(next_dialogue))
				
				emit_signal("option_select")
				display_next_dialogue()
			
			if(event.is_action_pressed("ui_down")):
				selected += 1
				if(selected >= _current_options.option_text.size()):
					selected = 0
				emit_signal("option_change", selected)
				
			if(event.is_action_pressed("ui_up")):
				selected -= 1
				if(selected < 0):
					selected = _current_options.option_text.size() - 1
				emit_signal("option_change", selected)
			
	if(Input.is_key_pressed(KEY_2) && _dialogue_queue.empty()):
		read_from_file_path("res://sample_dialogue.txt")

# method used to initiate a dialogue sequence from a filename
func read_from_file_path(fileName : String) -> void:
	if(!_dialogue_queue.empty()):
		push_warning("Dialogue queue was not empty when more dialogue was pushed")
	
	var file = File.new()
	file.open(fileName, File.READ)
	
	# if file not found, do not proceed
	if !file.is_open():
		push_error("File \"" + fileName + "\" was not found.")
		return
		
	var lines = file.get_as_text().strip_edges().split("\n", false)
	file.close()
	
	var i : int = 0
	while(i < lines.size()):
		var new_dialogue : Dialogue = Dialogue.new(lines[i])
		
		if new_dialogue.name_tag == "option" && new_dialogue.message.ends_with("{"):
			i += 1
			var options_array : Array = []
			while(lines[i] != "}"):
				options_array.append(lines[i])
				i += 1
			
			var options : OptionSet = OptionSet.new(options_array)
			_dialogue_queue.append(options)
		else:
			_dialogue_queue.append(new_dialogue)
		
		i += 1
	
	display_next_dialogue()
	set_state(DialogueState.SCROLL_TXT)

# activates the dialogue system by changing the state
# also emits signals to be recieved by other scripts
func set_state(state : int) -> void:
	match(state):
		DialogueState.INACTIVE:
			visible = false
			
		DialogueState.SCROLL_TXT:
			emit_signal("display_text")
			
			if(_dialogue_state_machine == DialogueState.INACTIVE):
				visible = true
				emit_signal("on_dialogue_open")
		
		DialogueState.OPTIONS:
			emit_signal("display_options", _current_options)
			selected = 0
	
	_dialogue_state_machine = state

# dequeues next dialogue from the queue
func display_next_dialogue() -> void:
	# shift queue
	if(!_dialogue_queue.empty()):
		if(_dialogue_queue[0] is Dialogue):
			current_dialogue = _dialogue_queue[0]
			_dialogue_queue.remove(0)
			
			emit_signal("dialogue_advance", current_dialogue)
			set_state(DialogueState.SCROLL_TXT)
		elif(_dialogue_queue[0] is OptionSet):
			# dequeue
			_current_options = _dialogue_queue[0]
			_dialogue_queue.remove(0)
			set_state(DialogueState.OPTIONS)
		else:
			push_error("Something that is not a Dialogue made its way into the dialogue queue")
			
	else:
		# this is when the queue is empty
		emit_signal("on_dialogue_close")
		set_state(DialogueState.INACTIVE)
