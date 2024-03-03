extends HBoxContainer

const HEART = preload("res://Scenes/GUI/heart.tscn")
# Called when the node enters the scene tree for the first time.
var stagger = 0
var hearts_displayed = 0

func _on_player_health_change(number):
	for i in get_child_count() -1:
		get_child(get_child_count()-1-i).queue_free()
		
	for i in number:
		var new_heart = HEART.instantiate()
		new_heart.get_child(0).frame = stagger
		add_child(new_heart)
		stagger+=1
		if stagger >4: stagger = 0

