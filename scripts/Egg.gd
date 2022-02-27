extends Node2D

export(Texture) var loaded_texture

onready var sprite = $Sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = loaded_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass



func _on_Area2D_body_entered(body):
	if(body.name == "Player"):
		SignalBus.emit_signal("egg_picked_up")
		queue_free()
