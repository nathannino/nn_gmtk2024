extends Node



var overworld_inventory : Dictionary
var platformer_inventory : Dictionary
@export var overworld_ui : Control
var current_selection = null
@export var overworld_node : Node2D
var current_mode = Constants.horrible_idea.GATHERER #TODO : Should be platformer
@export var platformer_node : Node2D
@export var crafter_ui : Control
# I hate inventories why do I have two of them???? :crying emoji:
# It got worse... overworld_inventory is now the root gameplay node

func _disable_root_ish_node(obj : Node) :
	obj.disable_camera()
	obj.process_mode = Node.PROCESS_MODE_DISABLED
	obj.hide()

func _enable_root_ish_node(obj : Node,move_pl : bool) :
	obj.enable_camera()
	if move_pl : obj.reset_player_pos()
	obj.process_mode = Node.PROCESS_MODE_INHERIT
	obj.show()
	
func _disable_all() :
	_disable_root_ish_node(overworld_node)
	_disable_root_ish_node(platformer_node)
	overworld_ui.hide()
	crafter_ui.hide()
	

func set_mode(p_mode : Constants.horrible_idea) :
	var old_mode = current_mode
	current_mode = p_mode
	_disable_all()
	match p_mode :
		Constants.horrible_idea.GATHERER:
			if old_mode == Constants.horrible_idea.CRAFTER :
				_enable_root_ish_node(overworld_node,false)
			else :
				_enable_root_ish_node(overworld_node,true)
			overworld_ui.show()
			pass
		Constants.horrible_idea.CRAFTER :
			crafter_ui.show()
			pass
		Constants.horrible_idea.PLATFORMER:
			_enable_root_ish_node(platformer_node,true)
			pass

func _ready(): # https://forum.godotengine.org/t/how-to-get-all-children-from-a-node/18587/4
	#overworld
	var waiting_ov := overworld_node.get_children()
	while not waiting_ov.is_empty():
		var node := waiting_ov.pop_back() as Node
		waiting_ov.append_array(node.get_children())
		if node.scene_file_path == "res://Gatherer/resources/overworld_resource.tscn" : 
			var signals = node.get_signal_list()
			for sign in signals :
				if sign["name"] == "add_inventory_item" :
					node.connect("add_inventory_item",add_overworld_item)
		elif node.scene_file_path == "res://platformer/player_platformer.tscn" or node.scene_file_path == "res://Gatherer/overworld_pl.tscn" :
			node.connect("switch_mode",set_mode)
	# Platformer
	var waiting_pl := platformer_node.get_children()
	while not waiting_pl.is_empty():
		var node := waiting_pl.pop_back() as Node
		waiting_pl.append_array(node.get_children())
		if node.scene_file_path == "res://platformer/player_platformer.tscn" :
			node.connect("switch_mode",set_mode)
		if node.scene_file_path == "res://platformer/platformer_upgrades.tscn" :
			node.connect("add_tool",add_overworld_tool)
	#afterwards
	_new_selection(null)
	set_mode(Constants.horrible_idea.PLATFORMER)
	

func _input(event):
	if current_mode == Constants.horrible_idea.GATHERER :
		if event.is_action_pressed("ov_item_next") :
			select_next()
		if event.is_action_pressed("ov_item_previous") :
			select_previous()
		if event.is_action_pressed("ov_use_tool") :
			overworld_use_item()
		if event.is_action_pressed("ov_interact") :
			if overworld_node.inside_crafter_radius :
				set_mode(Constants.horrible_idea.CRAFTER)
		return
	if current_mode == Constants.horrible_idea.CRAFTER :
		if event.is_action_pressed("ui_up") :
			print("ui_up")
		if event.is_action_pressed("ui_down") :
			print("ui_down")

func overworld_use_item() :
	if current_selection == null :
		return
	var current_item = overworld_inventory[current_selection]
	if current_item is gmtk_overworld_tool :
		overworld_node.player.set_tool(current_item)

func select_previous() :
	var list = overworld_inventory.keys();
	if current_selection == null :
		_new_selection(list.back())
		return
	if current_selection == list.front() :
		_new_selection(null)
		return
	
	var pos = list.find(current_selection)
	_new_selection(list[pos-1])


func select_next() :
	var list = overworld_inventory.keys();
	if current_selection == null :
		_new_selection(list.front())
		return
	if current_selection == list.back() :
		_new_selection(null)
		return
	
	var pos = list.find(current_selection)
	_new_selection(list[pos+1])

func _new_selection(hi) :
	if hi == null :
		overworld_ui.select_item(null) 
		current_selection = null
	else :
		overworld_ui.select_item(overworld_inventory[hi])
		current_selection = hi

#this should mostly be ran in platformer mode
func add_overworld_tool(p_tool : gmtk_overworld_tool) :
	if overworld_inventory.has(p_tool.name) :
		print("wtf why. " + p_tool.name + " is already in the inventory")
		return
	overworld_inventory[p_tool.name] = p_tool
	overworld_ui.update_inventory(overworld_inventory.values())
	_new_selection(current_selection)

func add_overworld_item(drop : gmtk_overworld_drops) :
	if overworld_inventory.has(drop.name) :
		overworld_inventory[drop.name].amount += 1
	else :
		var new_item = preload("res://Gatherer/drop_instance.gd").new(drop)
		new_item.amount += 1
		overworld_inventory[drop.name] = new_item
	overworld_ui.update_inventory(overworld_inventory.values())
	_new_selection(current_selection)
