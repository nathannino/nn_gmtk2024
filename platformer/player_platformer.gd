extends CharacterBody2D


var look_direction = Constants.look_direction_name.RIGHT

const SPEED = 50.0
const JUMP_VELOCITY = -130.0
var tool_preview
@export var debug_block : gmtk_tool
@export var pos_left : Node2D
@export var pos_right : Node2D
@export var toplevel_scene : Node

func _ready():
	tool_preview = $pl_tool_preview
	
	tool_preview.set_toplevel(toplevel_scene)
	set_look_direction(Constants.look_direction_name.RIGHT)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _input(event):
	if event.is_action_pressed("pl_use_tool") :
		tool_preview.init_preview(debug_block)
	if event.is_action_pressed("pl_place") :
		tool_preview.place_preview()
	elif event.is_action_pressed("pl_cancel") :
		tool_preview.cancel_preview()

func set_look_direction(dir : Constants.look_direction_name):
	look_direction = dir
	if look_direction == Constants.look_direction_name.RIGHT :
		tool_preview.position = pos_right.position
	else :
		tool_preview.position = pos_left.position
	tool_preview.set_look_direction(dir)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("pl_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("pl_move_left", "pl_move_right")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0 :
			set_look_direction(Constants.look_direction_name.LEFT)
		else :
			set_look_direction(Constants.look_direction_name.RIGHT)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
