extends Area2D

var state = 0
var playerInside = false

var unlocked_sprite = preload("res://assets/sprites/Door/door_unlocked.png")

var interact_text

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and playerInside:
		if state == 1:
			state = 2
			Globals.win()
	pass


func unlock():
	state = 1
	get_parent().texture = unlocked_sprite
	$"Open Sound".play()


func _on_Area2D_body_entered(body):
	print(body.name)
	if body == Globals.player:
		playerInside = true
		if state == 1:
			Globals.apply_outline(self.get_parent())
			if not interact_text:
				Globals.apply_interact_text(self)
		pass
	if body.is_in_group("Key"):
		print("Key")
		if not body.isPickedUp and state == 0:
			unlock()
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body == Globals.player:
		playerInside = false
		Globals.remove_outline(self.get_parent())
		if interact_text:
			Globals.remove_interact_text(self)
		pass
	pass # Replace with function body.
