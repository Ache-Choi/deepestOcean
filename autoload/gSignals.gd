extends Node

signal instSound
func inst_sounds(soundName):
	emit_signal("instSound", soundName)

signal instHitFx
func inst_hit_fx(pos, scale):
	emit_signal("instHitFx", pos, scale)

signal spawnGotItem
func spawn_got_item(num, from, to):
	emit_signal("spawnGotItem", num, from, to)

signal chooseItemMiniGame
func end_mini_game(winLoss):
	emit_signal("chooseItemMiniGame",winLoss)

signal gotTreasureBox
func got_treasure_box():
	emit_signal("gotTreasureBox")

signal updateOxyValue
func update_oxy_value(amount):
	emit_signal("updateOxyValue", amount)

signal updateCoinsGems
func update_coins_gems():
	emit_signal("updateCoinsGems")

signal gameOver
func game_over():
	emit_signal("gameOver")

signal stopResume
func stop_resume(type):
	emit_signal('stopResume', type)

signal lifeTimer
func life_timer(type):
	emit_signal("lifeTimer", type)
