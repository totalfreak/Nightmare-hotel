extends Area2D


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Stair_Area_body_entered(body):
	if body == Globals.player:
		Globals.player.on_stair()
	pass # replace with function body


func _on_Stair_Area_body_exited(body):
	if body == Globals.player:
		Globals.player.left_stair()
	pass # replace with function body
