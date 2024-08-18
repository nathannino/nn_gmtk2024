extends Control

var inventory_content : Array
@export var list_root : Control

var inventory_to_ui = {}

var current_selected = null

func _init():
	inventory_content = []
	
func _ready():
	_update_inventory()

func create_inventory_item(name:String,object) :
	var labl = Label.new()
	labl.text = name
	list_root.add_child(labl)
	inventory_to_ui[object] = labl

func _update_inventory() :
	for n in list_root.get_children() : # Oh, this will probably have to be updated lol
		list_root.remove_child(n)
		n.queue_free()
	
	create_inventory_item("None",null)
	for n in inventory_content :
		if n is drop_instance :
			create_inventory_item(n.drop.name + " - " + str(n.amount),n)
		elif n is gmtk_overworld_tool :
			create_inventory_item(n.name,n)
	

func select_item(obj) :
	var old = inventory_to_ui[current_selected]
	old.set("theme_override_colors/font_color",Color.WHITE)
	current_selected = obj
	var newlabl = inventory_to_ui[obj]
	newlabl.set("theme_override_colors/font_color",Color.RED)

func update_inventory(p_inventory_content : Array) :
	inventory_content = p_inventory_content
	_update_inventory()
	
