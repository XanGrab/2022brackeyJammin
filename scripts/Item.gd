extends Node2D

export(GameManager.Item) var type 
export(Texture) var loaded_texture

onready var sprite = $Sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = loaded_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass



func _on_Area2D_body_entered(body):
	SignalBus.emit_signal("item_picked_up", type)
	queue_free()
