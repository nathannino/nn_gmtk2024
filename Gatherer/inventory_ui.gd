extends Control

var inventory_content : Array
@export var list_root : Control

const selected_icon = preload("res://pixelmora/RIGHT_ARROW_MENU.png")
const unselected_icon = preload("res://pixelmora/empty.png")
var inventory_to_ui = {}

var current_selected = null

func _init():
	inventory_content = []
	
func _ready():
	_update_inventory()

func create_inventory_item(name:String,sprite:CompressedTexture2D,object) :
	var row = HBoxContainer.new()
	var spr = TextureRect.new()
	spr.texture = unselected_icon
	var labl = RichTextLabel.new()
	labl.fit_content = true
	labl.autowrap_mode = TextServer.AUTOWRAP_OFF
	labl.add_image(sprite)
	labl.add_text(name)
	row.add_child(spr)
	row.add_child(labl)
	list_root.add_child(row)
	inventory_to_ui[object] = row

func _update_inventory() :
	for n in list_root.get_children() : # Oh, this will probably have to be updated lol
		list_root.remove_child(n)
		n.queue_free()
	
	create_inventory_item("",preload("res://pixelmora/FIST.png"),null)
	for n in inventory_content :
		if n is drop_instance :
			create_inventory_item(str(n.amount),n.drop.sprite,n)
		elif n is gmtk_overworld_tool :
			create_inventory_item("",n.sprite,n)
	

func select_item(obj) :
	var old = inventory_to_ui[current_selected]
	old.get_child(0).texture = unselected_icon
	old.get_child(1).set("theme_override_colors/default_color",Color.KHAKI)
	current_selected = obj
	var newlabl = inventory_to_ui[obj]
	newlabl.get_child(0).texture = selected_icon
	newlabl.get_child(1).set("theme_override_colors/default_color",Color.GOLDENROD)

func update_inventory(p_inventory_content : Array) :
	inventory_content = p_inventory_content
	_update_inventory()
	
