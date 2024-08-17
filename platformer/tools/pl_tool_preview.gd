extends Node2D

var tool : gmtk_tool
var preview : Sprite2D
var look_direction : Constants.look_direction_name
const alpha = 0.5
var toplevel_scene : Node

func set_toplevel(toplevel : Node) :
	toplevel_scene = toplevel

func init_preview(p_tool : gmtk_tool) :
	tool = p_tool
	if not preview == null :
		remove_child(preview)
		preview.queue_free() # lol hope this works =D
	
	preview = Sprite2D.new()
	add_child(preview)
	preview.texture = tool.sprite
	preview.modulate.a = alpha
	set_tool_position()

func clear_preview() :
	preview.queue_free()
	tool = null

func cancel_preview() :
	if preview == null or tool == null :
		return
	clear_preview()

func place_preview() :
	if preview == null or tool == null :
		return
	var scene = tool.scene.instantiate()
	scene.global_position = preview.global_position
	toplevel_scene.add_child(scene)
	clear_preview()

func set_tool_position() :
	if preview == null :
		return
	if look_direction == Constants.look_direction_name.RIGHT :
		preview.position = tool.position_offset
	else :
		preview.position = -tool.position_offset

func set_look_direction(dir : Constants.look_direction_name) :
	look_direction = dir
	set_tool_position()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
