extends Control

@export var recepies_list : VBoxContainer
@export var bag_contents : RichTextLabel

var bag_content_dict : Dictionary
var recepies_list_res : Dictionary
var selected = null

@export var back_button : HBoxContainer

@export var plat_inv : VBoxContainer
@export var plat_weight : Label

func add_item(rec : gmtk_crafting_recipes) :
	var hbox = HBoxContainer.new()
	var sprite = TextureRect.new()
	sprite.texture = Constants.empty_icon
	var newrec = RichTextLabel.new()
	newrec.fit_content = true
	newrec.autowrap_mode = TextServer.AUTOWRAP_OFF
	newrec.bbcode_enabled = true
	newrec.add_image(rec.result.shop_sprite,16,16)
	newrec.add_text(rec.result.name + " ")
	newrec.add_image(Constants.bag_limit_icon)
	newrec.add_text(str(rec.result.weight))
	newrec.newline()
	newrec.add_image(Constants.downleft_arrow_icon,16,16)
	newrec.add_text(":")
	for component in rec.components :
		newrec.add_image(component.sprite)
	hbox.add_child(sprite)
	hbox.add_child(newrec)
	recepies_list_res[rec] = hbox
	recepies_list.add_child(hbox)

func set_selected(rec : gmtk_crafting_recipes) :
	var sel = recepies_list_res[rec]
	var oldsel = recepies_list_res[selected]
	
	oldsel.get_child(0).texture = Constants.empty_icon
	sel.get_child(0).texture = Constants.selected_icon
	selected = rec

func sync(crafting_recepies : Array[gmtk_crafting_recipes]) :
	recepies_list_res.clear()
	for n in recepies_list.get_children() : # Oh, this will probably have to be updated lol
		recepies_list.remove_child(n)
		n.queue_free()
	
	recepies_list_res[null] = back_button
	for rec in crafting_recepies :
		add_item(rec)
	pass

func default_bag_content() :
	bag_contents.add_image(preload("res://pixelmora/bag.png"))
	bag_contents.add_text("=")
	
func add_bag_content(n : drop_instance) :
	bag_contents.add_text(str(n.amount))
	bag_contents.add_image(n.drop.sprite)

func inventory_sync(inv : Dictionary) :
	bag_contents.clear()
	bag_content_dict.clear()
	default_bag_content()
	for item in inv.values() :
		if item is drop_instance :
			add_bag_content(item)
			bag_content_dict[item.drop] = item.amount
	pass

func add_inventory_item(n : gmtk_tool) :
	var item = RichTextLabel.new()
	item.text_direction
	item.fit_content = true
	item.autowrap_mode = TextServer.AUTOWRAP_OFF
	item.bbcode_enabled = true
	item.push_paragraph(HORIZONTAL_ALIGNMENT_RIGHT)
	item.add_text("(" + str(n.weight))
	item.add_image(Constants.bag_limit_icon)
	item.add_text(")")
	item.add_image(n.shop_sprite)
	item.add_image(Constants.downright_arrow_icon)
	item.pop()
	
	plat_inv.add_child(item)

func sync_platformer_inventory(n : Node) :
	for nn in plat_inv.get_children() : # Oh, this will probably have to be updated lol
		plat_inv.remove_child(nn)
		nn.queue_free()
	
	plat_weight.text = str(n.current_weight) + "/" + str(n.weight_limit)
	for item in n.backpack :
		add_inventory_item(item)
