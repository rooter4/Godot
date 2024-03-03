extends Node
var ability_double
var ability_dash
var ability_slash
var ability_wall_jump
var ability_shoot
var ability_pound
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
# Called every frame. 'delta' is the elapsed time since the previous frame.

func add_player(start):
	player.global_position = start

func check_ability(ability):
	return get(ability)
func save():
	var save_dict = {
		"object": get_path(),
		"ability_double": ability_double,
		"ability_dash": ability_dash,
		"ability_pound": ability_pound,
		"ability_shoot": ability_shoot,
		"ability_slash": ability_slash,
		"ability_wall_jump": ability_wall_jump
		}
	return save_dict
func load(data):
	print("loading")
	for key in data:
		set(key, data[key])
func set_abilities(data):
	print("set abilities")
	for key in  data:
		set(key,data[key])
func save_new():
	print("Initiating New Player Save")
	var save_dict = {
		"object": get_path(),
		"ability_double": false,
		"ability_dash": false,
		"ability_pound": false,
		"ability_shoot":false,
		"ability_slash": false,
		"ability_wall_jump": false
		}
	return save_dict


func ability_check(ability):
	return get(ability)


func _on_check_button_2_toggled(toggled_on):
	print(toggled_on)
	set("ability_double", toggled_on)


func _on_check_button_3_toggled(toggled_on):
	set("ability_dash", toggled_on)


func _on_check_button_toggled(toggled_on):
	set("ablity_shoot", toggled_on)


func _on_check_button_4_toggled(toggled_on):
	set("ability_pound",toggled_on)
