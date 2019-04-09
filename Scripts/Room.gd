extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var hasBeenInRoom = false

var desiredDarkAlpha = 0.9


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _process(delta):
	$"Not In Room Dark".modulate.a = lerp($"Not In Room Dark".modulate.a, desiredDarkAlpha, delta * 2)
	pass


func _on_Area2D_body_entered(body):
	if body == Globals.player:
		#get_node("Camera2D").make_current()
		desiredDarkAlpha = 0.0
	pass



func _on_Area2D_body_exited(body):
	if body == Globals.player:
		desiredDarkAlpha = 0.65
	pass # replace with function body
