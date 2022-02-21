extends Node2D

export(GameManager.Item) var type 


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass



func _on_Area2D_body_entered(body):
    SignalBus.emit_signal("item_picked_up", type)
    queue_free()
