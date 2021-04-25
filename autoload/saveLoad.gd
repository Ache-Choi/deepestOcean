extends Node
#
const SAVE_PATH = 'res://save.json'
#const SAVE_PATH = 'user://saveFile.json'
var default_data = {
			 player = {
						gems          = 0,
						coins         = 0,
						depth          = [0,0,0]
							 },
			  settingsData = {
						musicOnOff = true,
						soundOnOff = true
							 }
				   }

var player_data = {}

func save_data():
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)

	save_data_function()

	save_file.store_line(to_json(player_data))
	save_file.close()


func save_data_function():
	for i in player_data:
		for j in player_data[i]:
###  PLAYER DATA
			if j == 'gems':
				player_data[i][j] = GVariables.gems
			if j == 'coins':
				player_data[i][j] = GVariables.coins
			if j == 'depth':
				player_data[i][j] = GVariables.depth
#			if j == 'playerPos':
#				player_data[i][j][0] = GVariables.playerPos.x
#				player_data[i][j][1] = GVariables.playerPos.y
#				player_data[i][j][2] = GVariables.playerPos.z


###  SETTINGS DATA
			if j == 'musicOnOff':
				player_data[i][j] = GVariables.musicOnOff
			if j == 'soundOnOff':
				player_data[i][j] = GVariables.soundOnOff


func load_data():
	var load_file = File.new()
	if not load_file.file_exists(SAVE_PATH):
		reset_data()
		return

	load_file.open(SAVE_PATH, load_file.READ)
	player_data = parse_json(load_file.get_as_text())
	load_data_function()

	load_file.close()

func reset_data():
	player_data = default_data.duplicate(true)

func load_data_function():
	for i in player_data:
		for j in player_data[i]:
###  PLAYER DATA
			if j == 'gems':
				GVariables.gems = player_data[i][j]
			if j == 'coins':
				GVariables.coins = player_data[i][j]
			if j == 'depth':
				GVariables.depth = player_data[i][j]
#			if j == 'playerPos':
#				GVariables.playerPos.x = float(player_data[i][j][0])
#				GVariables.playerPos.y = float(player_data[i][j][1])
#				GVariables.playerPos.z = float(player_data[i][j][2])

####  SETTINGS DATA
			if j == 'musicOnOff':
				GVariables.musicOnOff = player_data[i][j]
			if j == 'soundOnOff':
				GVariables.soundOnOff = player_data[i][j]


