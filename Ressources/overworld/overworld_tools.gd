class_name gmtk_overworld_tool
extends Resource

@export var sprite : CompressedTexture2D
@export var position_offset : Vector2
@export var endless : bool
@export var type : Constants.over_tool


func _init(p_sprite=preload("res://pixelmora/wall.png"),p_position_offset=Vector2(0,0),p_endless=true,p_type=Constants.over_tool.AXE):
	sprite = p_sprite
	position_offset = p_position_offset
	endless = p_endless
	type = p_type

