extends Control

@export var recepies_list : VBoxContainer

func add_item(rec : gmtk_crafting_recipes) :
	var newrec = RichTextLabel.new()
	newrec.fit_content = true
	newrec.autowrap_mode = TextServer.AUTOWRAP_OFF
	newrec.bbcode_enabled = true
	newrec.add_image(rec.result.sprite,16,16)
	newrec.add_text(rec.result.name + "  ")
	newrec.add_image(Constants.bag_limit_icon)
	newrec.add_text(str(rec.result.weight))
	newrec.newline()
	newrec.add_image(Constants.downleft_arrow_icon,16,16)
	for component in rec.components :
		newrec.add_image(component.sprite)
	
	recepies_list.add_child(newrec)

func sync(crafting_recepies : Array[gmtk_crafting_recipes]) : 
	for n in recepies_list.get_children() : # Oh, this will probably have to be updated lol
		recepies_list.remove_child(n)
		n.queue_free()
	for rec in crafting_recepies :
		add_item(rec)
	pass
