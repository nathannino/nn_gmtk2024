extends Button

func selected() :
	$"../../../..".request_rebind(self)

func _ready():
	connect("pressed",selected)
