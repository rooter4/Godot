extends Node
var ability_double
var ability_dash
var ability_slash
var ability_wall_jump
@onready var p = $player
# Called when the node enters the scene tree for the first time.
func _ready():
	p.set_abilities()
	print("set")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func load():
	
