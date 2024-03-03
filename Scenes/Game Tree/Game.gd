extends Node

var save_path = "user://savegame.save"
# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	$PlayerManager.add_player($LevelManager.get_start())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		
func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		print(str(node_data))
		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		print("Missing Save File")
		save_new()
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()
	
		get_node(node_data["object"]).call("load",node_data)
		# Firstly, we need to create the object and add it to the tree and set its position.
func save_new():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		

		# Check the node has a save function.
		if !node.has_method("save_new"):
			print("persistent node '%s' is missing a save_new() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save_new")

		print(str(node_data))
		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
func _on_button_pressed():
	save_game()


func _on_button_2_pressed():
	load_game()
