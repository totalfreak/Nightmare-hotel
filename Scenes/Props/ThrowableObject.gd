extends RigidBody2D

var OGowner
var playerInside = false
var isPickedUp = false
var throwOffset = Vector2(0,0)
var throwForce = 120000

var entered_light = false
var amount_of_lights_entered = 0
var result

var interact_text

var my_sprite : Sprite

func _ready():
	OGowner = self.get_owner()
	my_sprite = $Sprite
	print(OGowner)
	pass

func _process(delta):
	if Input.is_action_just_pressed("interact") and playerInside and not Globals.player.handsFull and not isPickedUp:
		isPickedUp = true
		Globals.player.handsFull = true
		pickUpObject()

	if Input.is_action_just_pressed("throw") and Globals.player.handsFull and isPickedUp:
		isPickedUp = false
		Globals.player.handsFull = false
		throwObject(delta)
	
	if self.is_sleeping():
		print("Sleeping")
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(1, false)
	
	

func throwObject(delta):
	var throwDir = (get_global_mouse_position() - self.global_position).normalized() * (throwForce * (mass )) * delta
	var tempGlobal = self.global_position
	Globals.player.get_node("ThrowableContainer").remove_child(self)
	OGowner.add_child(self)
	
	self.set_owner(OGowner)
	self.mode = RigidBody2D.MODE_RIGID
	self.global_position = tempGlobal + (get_global_mouse_position() - tempGlobal).normalized() * 40
	apply_impulse(throwOffset, throwDir)
	set_collision_layer_bit(3, true)
	set_collision_mask_bit(3, true)
	set_collision_layer_bit(1, true)
	set_collision_mask_bit(1, true)
	set_collision_layer_bit(4, true)
	set_collision_mask_bit(4, true)
	pass

func pickUpObject():
	self.get_parent().remove_child(self)
	Globals.player.get_node("ThrowableContainer").add_child(self)
	self.set_owner(Globals.player.get_node("ThrowableContainer"))
	self.position = Vector2(0,0)
	self.mode = RigidBody2D.MODE_KINEMATIC
	set_collision_layer_bit(3, false)
	set_collision_mask_bit(3, false)
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(4, false)
	pass

func _on_PlayerEntered_body_entered(body):
	if body == Globals.player:
		playerInside = true
		if not isPickedUp:
			Globals.apply_outline(my_sprite)
<<<<<<< HEAD
			if not interact_text:
				Globals.apply_interact_text(self)
=======
	
	if body == get_node("TileMap"):
		$AudioStreamPlayer.play()
>>>>>>> git told me to commit
	pass


func _on_PlayerEntered_body_exited(body):
	if body == Globals.player:
		playerInside = false
		Globals.remove_outline(my_sprite)
		if interact_text:
			Globals.remove_interact_text(self)
	pass 


func _on_ThrowableObject_sleeping_state_changed():
	if self.is_sleeping() and playerInside:
		print("Sleeping")
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(1, false)
