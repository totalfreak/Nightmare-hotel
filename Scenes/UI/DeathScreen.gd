extends Control


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Main_Menu_Button_pressed():
	Globals._Change_Scene("res://Scenes/UI/StartMenu.tscn")
	pass # replace with function body


func _on_Retry_Button_pressed():
	Globals._Change_Scene(Globals.old_scene)
	pass # replace with function body
