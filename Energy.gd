extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_character_energy_change():
	const ENERGY = preload("res://Scenes/GUI/energy.tscn")
	var new_energy = ENERGY.instantiate()
	add_child(new_energy)

	
