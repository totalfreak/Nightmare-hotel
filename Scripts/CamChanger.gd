extends Area2D

onready var cam1 = get_node("Camera1")
onready var cam2 = get_node("Camera2")

func _ready():
	print(cam1)
	pass

func _process(delta):
	pass


#func _on_CamChanger1_body_entered(body):
#	if body == Globals.player:
#		currCam = cam2.make_current()
#	elif body == Globals.player and currCam == cam2:
#			currCam = cam1.make_current()
#	pass


func _on_CamChanger1_body_exited(body):
	var currCam = cam1
	if body == Globals.player and currCam == cam1:
		currCam = cam2.changeCam()
	elif body == Globals.player and currCam == cam2:
		currCam = cam1.changeCam()
	pass 
