extends Node2D

# two arrays store the origins and collision data of rays to be drawn
onready var origins : Array = []
onready var hits : Array = []
onready var direction : Vector2 = Vector2()

# Should be vector2, can be null
onready var interactRayDirection = null
onready var interactRayOrigin = null
onready var interactRayColor : Color = Color.darkolivegreen

onready var collisionShape : CollisionShape2D = $"../CollisionShape2D"

func _draw():
	if(Debug.DEBUG_MODE):
		# draw collision box
		var extents : Vector2 = collisionShape.shape.extents
		var collisionBox : Rect2 = Rect2(collisionShape.position - extents, 2 * extents)
		draw_rect(collisionBox, Color.crimson, false, 1, true)
		
		
		# draw "squeeze" rays
		for i in range(0, origins.size()):
			var endpoint = origins[i] + direction
			var color = Color.cornflower
			if(hits[i]) :
				endpoint = hits[i].position
				color = Color.fuchsia
			
			draw_line(to_local(origins[i]), to_local(endpoint), color)
		
		# draw interaction ray
		if(interactRayOrigin != null && interactRayDirection != null):
			draw_line(interactRayOrigin, interactRayOrigin + interactRayDirection, interactRayColor)
		
		# ray fades color once no longer in effect
		interactRayColor = Color.darkolivegreen
		
		# clear the renderer so that rays don't linger
		origins = []
		hits = []

func _process(_delta):
	update()

func _on_debug_rays(new_origins, new_hits, usual_length):
	origins = new_origins
	hits = new_hits
	direction = usual_length


func _on_draw_interact_ray(origin, cast_to):
	interactRayOrigin = origin
	interactRayDirection = cast_to
	interactRayColor = Color.aquamarine
