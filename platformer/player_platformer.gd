extends CharacterBody2D


var look_direction = Constants.look_direction_name.RIGHT

const SPEED = 50.0
const JUMP_VELOCITY = -130.0
var tool_preview
@export var debug_block : gmtk_tool
@export var pos_left : Node2D
@export var pos_right : Node2D
@export var toplevel_scene : Node

signal switch_mode(p_mode : Constants.horrible_idea)

signal tool_placed

func _ready():
	tool_preview = $pl_tool_preview
	
	tool_preview.set_toplevel(toplevel_scene)
	set_look_direction(Constants.look_direction_name.RIGHT)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _input(event):
	if event.is_action_pressed("pl_place") :
		if tool_preview.preview == null or tool_preview.tool == null :
			return
		tool_preview.place_preview()
		tool_placed.emit()
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
	var no_play = false
	if not is_on_floor():
		velocity.y += gravity * delta
		$Player.pause()
		no_play = true

	# Handle jump.
	if Input.is_action_just_pressed("pl_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ov_move_left", "ov_move_right")
	if direction:
		velocity.x = direction * SPEED
		if not no_play : $Player.play()
		if direction < 0 :
			set_look_direction(Constants.look_direction_name.LEFT)
			$Player.scale.x = -1
		else :
			set_look_direction(Constants.look_direction_name.RIGHT)
			$Player.scale.x = 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Player.stop()
		$Player.frame = 0

	move_and_slide()
	
	
	if global_position.x < 0 :
		switch_mode.emit(Constants.horrible_idea.GATHERER)
