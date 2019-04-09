extends Node

var bgmusic = preload("res://Scenes/BGMUSIC.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var newMusic = bgmusic.instance()
	get_tree().root.get_child(0).add_child(newMusic)
	newMusic.get_child(0).play()
	print(newMusic.get_child(0).is_playing())