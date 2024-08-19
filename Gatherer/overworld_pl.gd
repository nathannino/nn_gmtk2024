extends CharacterBody2D


const SPEED = 70.0
@export var tool : Area2D
@export var toolAnchor : Node2D
@export var toolSpeed = 400
var current_tool : gmtk_overworld_tool
var is_using_tool = false

signal switch_mode(p_mode : Constants.horrible_idea)

func _ready():
	unset_tool()

func set_tool(p_tool : gmtk_overworld_tool) :
	if is_using_tool :
		return
	current_tool = p_tool
	is_using_tool = true
	tool.show()
	tool.process_mode = Node.PROCESS_MODE_INHERIT
	tool.get_child(0).texture = current_tool.sprite

func unset_tool() :
	is_using_tool = false
	current_tool = null
	toolAnchor.rotation = 0
	tool.hide()
	tool.process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = Input.get_axis("ov_move_left", "ov_move_right")
	velocity.y = Input.get_axis("ov_move_up", "ov_move_down")
	velocity = velocity.normalized() * SPEED
	
	if velocity == Vector2.ZERO :
		$Player.stop()
	else :
		$Player.play()
		if (velocity.x < 0) :
			$Player.scale.x = -1
		else :
			$Player.scale.x = 1
	
	if is_using_tool :
		toolAnchor.rotation_degrees -= toolSpeed * delta
		if toolAnchor.rotation_degrees < -180 or toolAnchor.rotation_degrees > 180 :
			unset_tool()
		

	move_and_slide()
	
	if position.x > 0 :
		switch_mode.emit(Constants.horrible_idea.PLATFORMER)



func _on_tool_body_entered(body):
	body.we_colided_lol(current_tool.type)
	print("bang")
	pass # Replace with function body.
