extends Area2D

var player : CharacterBody2D
@export var tool_typer : String
func register_player(p_player : CharacterBody2D) :
	player = p_player

func enter_body(body) :
	if body is CharacterBody2D :
		print(tool_typer)
		player.register_current_tool_ground($"..",tool_typer)
		pass

func leave_body(body) :
	if body is CharacterBody2D :
		player.deregister_current_tool_ground($"..")

func _ready():
	connect("body_entered",enter_body)
	connect("body_exited",leave_body)
	#print(tool_typer)
