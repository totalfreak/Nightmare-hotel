extends Area2D

var state = 0
var playerInside = false

var unlocked_sprite = preload("res://assets/sprites/Door/door_unlocked.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and playerInside and Globals.hasKey:
		if state == 0:
			unlock()
		elif state == 1:
			state = 2
			Globals.win()
	pass


func unlock():
	state = 1
	get_parent().texture = unlocked_sprite

func _on_Area2D_body_entered(body):
	if body == Globals.player:
		playerInside = true
		pass
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body == Globals.player:
		playerInside = false
		pass
	pass # Replace with function body.
