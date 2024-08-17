extends CharacterBody2D


const SPEED = 70.0
@export var tool : Area2D
@export var toolAnchor : Node2D
var current_tool : gmtk_overworld_tool

func _ready():
	set_tool(null)

func set_tool(p_tool : gmtk_overworld_tool) :
	current_tool = p_tool
	tool.position = Vector2(0,0)
	tool.rotation_degrees = 0
	if p_tool == null :
		tool.hide()
		tool.process_mode = Node.PROCESS_MODE_DISABLED
		return
	tool.show()
	tool.process_mode = Node.PROCESS_MODE_INHERIT
	tool.get_child(0).texture = current_tool.sprite

func _input(event):
	if event.is_action_pressed("ov_use_tool") :
		set_tool(preload("res://Ressources/overworld/Axe_res.tres"))

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = Input.get_axis("ov_move_left", "ov_move_right")
	velocity.y = Input.get_axis("ov_move_up", "ov_move_down")
	velocity = velocity.normalized() * SPEED

	move_and_slide()



func _on_tool_body_entered(body):
	body.we_colided_lol(current_tool.type)
	pass # Replace with function body.
