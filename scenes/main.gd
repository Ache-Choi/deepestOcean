extends Node

var ddbuug

func _ready():
	SaveLoad.load_data()
	SaveLoad.save_data()
	ddbuug = GSignals.connect('instSound', self, 'inst_sounds')
#	loadAds()
	go_to_main_menu()

func go_to_main_menu():
	var menu = ResourceLoader.load("res://scenes/ui/startPage.tscn")
	change_scene(menu)

func replace_main_scene(resource):
	call_deferred("change_scene", resource)

func change_scene(resource : Resource):
	var node = resource.instance()

	for child in get_children():
		remove_child(child)
		child.queue_free()
	add_child(node)

#	node.connect("quit", self, "go_to_main_menu")
	node.connect("replace_main_scene", self, "replace_main_scene")


func inst_sounds(soundName):
	if GVariables.soundOnOff == true:
		var s = preload('res://scenes/ui/sounds.tscn').instance()
		s.soundName = soundName
		self.add_child(s)
#func loadAds() -> void:
#	adGlobal.load_interstitial()
#	adGlobal.load_rewarded_video()
