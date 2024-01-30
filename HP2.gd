extends HBoxContainer

const HEART = preload("res://Scenes/GUI/heart.tscn")
# Called when the node enters the scene tree for the first time.
var stagger = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _on_main_character_health_change():
	
	var new_heart = HEART.instantiate()
	new_heart.get_child(0).frame = stagger
	add_child(new_heart)
	stagger+=1
	if stagger >4: stagger = 0


func _on_player_damaged():
	pass
	#get_child(get_child_count()-1).queue_free()
