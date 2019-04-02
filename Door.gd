extends Node2D


var within_door_area = false
export(NodePath) var other_door_path
var other_door
onready var exitPos = $Exit

func _ready():
	#exitPos = get_node("Exit")
	other_door = self.get_node(other_door_path)
	print("My Name: " + str(self.name) + " Other door name: " + str(other_door.name))

func _process(delta):
	if within_door_area and Input.is_action_just_pressed("interact"):
		Globals.door_entered(other_door.exitPos.global_position)
		$Area2D/AudioStreamPlayer2D.play()



func _on_Area2D_body_entered(body):
	if body == Globals.player:
		within_door_area = true
		Globals.apply_outline($Sprite)



func _on_Area2D_body_exited(body):
	if body == Globals.player:
		within_door_area = false
		Globals.remove_outline($Sprite)
