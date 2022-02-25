extends RayCast2D

# script that attaches to player and interacts with other objects
const Interactable = preload("res://scripts/Interactable.gd")

const RAY_LENGTH = 9
# const 

onready var player = $".." # gets reference to player_movement.gd

func _ready():
	enabled = false
	SignalBus.connect("item_picked_up", self, "_on_item_collection")
	

func _physics_process(_delta):
	cast_to = player.direction * RAY_LENGTH
	if(player._player_state_machine == player.PlayerState.PUSHPULL):
		var collider = get_collider()
		
		if(collider!= player.pushObject):
			player.stop_pushing()

func _input(event):
	if(Input.is_action_pressed("grab") && is_colliding()):
		var collider = get_collider()
			
		if(collider.is_in_group("Pushable")):
			player.start_pushing(collider)
			
func update_grab_ability():
	if(GameManager.inventory_flags[GameManager.Item.BRACELET]):
		enabled = true
	else:
		enabled = false

func _on_item_collection(item):
	update_grab_ability()
