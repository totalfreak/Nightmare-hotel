extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):

	pass


func _on_Area2D_body_entered(body):
	if body == Globals.player:
		get_node("Camera2D").make_current()
	pass
