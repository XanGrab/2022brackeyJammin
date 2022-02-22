extends KinematicBody2D

# speed at which the player moves. Try changing it for different results!
const SPEED = 70

# avoid modifying these
const RAYCAST_LENGTH = 4
const RAYCAST_LEEWAY = 1
const SQUEEZE_SPEED = 30

onready var shapeNode : CollisionShape2D = $"CollisionShape2D"
onready var interactor : RayCast2D = $"InteractRay"
onready var playerShape : RectangleShape2D = shapeNode.shape;
onready var rayDebugger : Node2D = $"DebugRayDraw"
signal debug_rays(origins, hits, direction)

onready var root = get_tree().get_root()
# onready var dialogue_system = $"/root".get_child(root.get_child_count() - 1).get_node("CanvasLayer/Dialogue System")

enum PlayerState {SCENETRANSITION, DIALOGUE, IDLE, MOVE}

onready var _player_state_machine = PlayerState.IDLE

onready var direction : Vector2 = Vector2(0, 1)
onready var input: Vector2 = Vector2()

signal on_move(state, direction)

func _ready():
    pass

func set_state(new_state : int):
    _player_state_machine = new_state

func _on_dialogue_open():
    _player_state_machine = PlayerState.DIALOGUE
    interactor.enabled = false

func _on_dialogue_close():
    _player_state_machine = PlayerState.IDLE
    interactor.enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
    match _player_state_machine:
        PlayerState.IDLE:
            read_input()
            move()
        PlayerState.MOVE:
            read_input()
            move()
        PlayerState.SCENETRANSITION:
            move()
    emit_signal("on_move", _player_state_machine, direction)
func _input(event):
    match _player_state_machine:
        PlayerState.IDLE:
            if(event.is_action_pressed("interact_select")):
                interactor.interact()
        PlayerState.MOVE:
            if(event.is_action_pressed("interact_select")):
                interactor.interact()

func read_input() -> void:
    # read inputs
    var inputX = float(Input.is_action_pressed("playermove_right"))
    inputX -= float(Input.is_action_pressed("playermove_left"))

    var inputY = float(Input.is_action_pressed("playermove_down"))
    inputY -= float(Input.is_action_pressed("playermove_up"))
    
    # convert to vector2, normalize vector (for diagonals)
    input = Vector2(inputX, inputY)
    
    # What does normalizing a vector mean?
        # "normalizing" is to take the "normal" of the vector,
        # which essentially takes it and scales it down to a
        # magnitude of 1
    
    # note: zero vector remains unchanged
    input = input.normalized()

func move() -> void: 
    if _player_state_machine == PlayerState.IDLE || _player_state_machine == PlayerState.MOVE:
        if input.length_squared() == 0:
            _player_state_machine = PlayerState.IDLE
        else:
            _player_state_machine = PlayerState.MOVE
    
    # move the character automatically factors in delta
    # warning-ignore:return_value_discarded
    move_and_slide(SPEED * input)
    
    if(isCardinal(input)):
        direction = input

        squeezeIntoSpace()
    
    # special case where the player is facing one way
    # and begins moving diagonally in opposite direction
    elif(direction.dot(input) < 0):
        direction *= -1
        
    
func roundPosition() -> void:
    position.x = floor(position.x)
    position.y = floor(position.y)

func isCardinal(vector : Vector2) -> bool:
    vector = Vector2(abs(vector.x), abs(vector.y))
    
    return vector == Vector2(1, 0) || vector == Vector2(0, 1)

# method is used to slightly move player when they "trip" on level geometry
func squeezeIntoSpace() -> void:
    var extents = Vector2(playerShape.extents.x + RAYCAST_LEEWAY, 
        playerShape.extents.y + RAYCAST_LEEWAY)
    var colliderCenter = position + shapeNode.position
    
    var centerRayOrigin = colliderCenter
    
    var rayOriginOffset = Vector2(abs(input.y * extents.x), abs(input.x * extents.y))
    
    var positiveRayOrigin = centerRayOrigin + rayOriginOffset
    var negativeRayOrigin = centerRayOrigin - rayOriginOffset
    
    # raycast!
    var space_state = get_world_2d().direct_space_state # global coordinates
    
    # cast ray from each origin through the edge of the collider
    
    # Vector2(...) gets us to the edge, and the (input * RAYCAST...
    var ray_direction = Vector2(input.x * extents.x, input.y * extents.y) + (input * RAYCAST_LENGTH)
    
    var centerCastResult = space_state.intersect_ray(centerRayOrigin, 
        centerRayOrigin + ray_direction, [self]);
    var positiveCastResult = space_state.intersect_ray(positiveRayOrigin, 
        positiveRayOrigin + ray_direction, [self]);
    var negativeCastResult = space_state.intersect_ray(negativeRayOrigin, 
        negativeRayOrigin + ray_direction, [self]);
    
    if(Debug.DEBUG_MODE) :
        var origins = [centerRayOrigin, positiveRayOrigin, negativeRayOrigin]
        var hits = [centerCastResult, positiveCastResult, negativeCastResult]
        emit_signal("debug_rays", origins, hits, ray_direction)
    
    # player got caught on something on positve side, move negative
    if(!centerCastResult && positiveCastResult && !negativeCastResult):	
        # warning-ignore:return_value_discarded
        move_and_slide(-SQUEEZE_SPEED * Vector2(abs(input.y), abs(input.x)))
        
    
    # player got caught on something on negative side, move positive
    if(!centerCastResult && negativeCastResult && !positiveCastResult):
        # warning-ignore:return_value_discarded
        move_and_slide(SQUEEZE_SPEED * Vector2(abs(input.y), abs(input.x)))
