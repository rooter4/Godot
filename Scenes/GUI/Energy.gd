extends HBoxContainer

const ENERGY = preload("res://Scenes/GUI/energy.tscn")
var stagger = 0

func _on_player_energy_change(number):
	for i in get_child_count() -1:
			get_child(get_child_count()-1-i).queue_free()
	for i in number:
		var new_energy = ENERGY.instantiate()
		new_energy.get_child(0).frame = stagger
		add_child(new_energy)
		stagger+=1
		if stagger >4: stagger = 0
