@tool
extends Node2D

@export var collision_shape : Shape2D
@export var extract_range : Shape2D
@export var sprite : CompressedTexture2D
@export var offset = Vector2(0,0)
@export var life : int
var current_life
@export var tool : Constants.over_tool
@export var drop : gmtk_overworld_drops

var delay = float(1)
var current_delay = float(0)

signal add_inventory_item(type : gmtk_overworld_drops)

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint() :
		return
	reset_values()
	current_life = life
	pass # Replace with function body.

func reset_values():
	$Area2D/CollisionShape2D.shape = extract_range
	$StaticBody2D/CollisionShape2D.shape = collision_shape
	$Sprite2D.texture = sprite
	$Sprite2D.position = offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_delay > 0 :
		current_delay = current_delay - delta
	if Engine.is_editor_hint():
		reset_values()
	pass


func tool_colided(p_tool : Constants.over_tool):
	if current_delay > 0 :
		return
	# For now, I think we can assume it is the tool
	current_life -= 1
	if current_life <= 0 :
		add_inventory_item.emit(drop)
		queue_free() # TODO : inventory system
		return
	
	current_delay = delay
	pass # Replace with function body.
