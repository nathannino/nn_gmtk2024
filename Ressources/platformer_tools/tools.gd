class_name gmtk_tool
extends Resource

@export var sprite : CompressedTexture2D
@export var shop_sprite : CompressedTexture2D
@export var position_offset : Vector2
@export var scene : PackedScene
@export var weight : int
@export var name : String

func _init(p_sprite=preload("res://pixelmora/wall.png"),p_position_offset=Vector2(0,0),p_scene=null,p_weight=1,p_name="block"):
	sprite = p_sprite
	shop_sprite = p_sprite
	position_offset = p_position_offset
	scene = p_scene
	weight = p_weight
	name = p_name
