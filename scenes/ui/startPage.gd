extends Control

var res_loader : ResourceInteractiveLoader = null
var loading_thread : Thread = null

signal quit
#warning-ignore:unused_signal
signal replace_main_scene # Useless, but needed as there is no clean way to check if a node exposes a signal

onready var ui = $Control
onready var loading = ui.get_node("Loading")
onready var loading_progress = loading.get_node("ProgressBar")
onready var loading_done_timer = loading.get_node("Timer")

onready var animPlayer = $AnimationPlayer

func _ready():
	$ColorRect2.visible = false
	$ColorRect.visible = false
	if GVariables.skipStartPage:
		$ColorRect2.visible = true
		_on_play_button_up()
		btns_disabled(true)

func loading_done(loader):
	loading_thread.wait_to_finish()
	emit_signal("replace_main_scene", loader.get_resource())
	res_loader = null
	btns_disabled(false)

func _on_Timer_timeout():
	loading_done(res_loader)

func btns_disabled(torf):
	$btnContainer/play.disabled = torf
	$btnContainer/settings.disabled = torf
	$btnContainer/info.disabled = torf
	$btnContainer/quit.disabled = torf

func _on_play_button_up():
	animPlayer.play("play")
	btns_disabled(true)
	GSignals.inst_sounds('click')
	loading.show()
	var path = GVariables.nextScenePath
	if ResourceLoader.has_cached(path):
		emit_signal("replace_main_scene", ResourceLoader.load(path))
	else:
		res_loader = ResourceLoader.load_interactive(path)
		loading_thread = Thread.new()
		#warning-ignore:return_value_discarded
		loading_thread.start(self, "interactive_load", res_loader)

func interactive_load(loader):
	while true:
		var status = loader.poll()
		if status == OK:
#			loading_progress.value = (loader.get_stage() * 100) / loader.get_stage_count()
#			print(loader.get_stage() * 100)
			continue
		elif status == ERR_FILE_EOF:
			loading_progress.value = 100
			loading_done_timer.start()
#			print(loader.get_stage() * 100, '     -----   ', loading_progress.value )
			break
		else:
			print("Error while loading level: " + str(status))
			loading.hide()
			break

func _on_settings_button_up():
	GSignals.inst_sounds('click')
	var s = load('res://scenes/ui/settings.tscn').instance()
	add_child(s)
	print('settings  page instt')

func _on_info_button_up():
	GSignals.inst_sounds('click')
	btns_disabled(true)
	animPlayer.play("infoPanel")

func _on_closeInfo_button_down():
	GSignals.inst_sounds('cancel')
	btns_disabled(false)
	animPlayer.play_backwards("infoPanel")

func _on_quit_button_up():
	GSignals.inst_sounds('cancel')
	get_tree().quit()
