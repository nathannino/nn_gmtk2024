class_name gmtk_tool
extends Resource

@export var sprite : CompressedTexture2D
@export var position_offset : Vector2
@export var scene : PackedScene

func _init(p_sprite=preload("res://pixelmora/wall.png"),p_position_offset=Vector2(0,0),p_scene=null):
	sprite = p_sprite
	position_offset = p_position_offset
	scene = p_scene
