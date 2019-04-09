extends RigidBody2D

var OGowner
var playerInside = false
var isPickedUp = false
var throwOffset = Vector2(0,0)
var throwForce = 40000

var entered_light = false
var amount_of_lights_entered = 0
var result

var interact_text

var my_sprite : Sprite
var pos_array = []

func _ready():
	OGowner = self.get_owner()
	my_sprite = $Sprite
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
		#print("Sleeping")
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(1, false)
	
	if Globals.player.handsFull:
		Globals.remove_outline(my_sprite)
		if interact_text:
			Globals.remove_interact_text(self)
	
	if Globals.did_move(pos_array, self.position) and not isPickedUp:
		for body in get_colliding_bodies():
			if body.name == "TileMap":
				if not $ThumpSound.is_playing():
					$ThumpSound.play()
					Globals.player.camera.shake(0.2, 20, 2)
			if body.is_in_group("Enemy"):
				body.get_hit_by_box()
	

func throwObject(delta):
	var throwDir = (get_global_mouse_position() - self.global_position).normalized() * (throwForce * (mass )) * delta
	var tempGlobal = self.global_position
	Globals.player.get_node("ThrowableContainer").remove_child(self)
	OGowner.add_child(self)
	
	self.set_owner(OGowner)
	self.mode = RigidBody2D.MODE_RIGID
	# teleport a little towards target as to not move player when throw
	self.global_position = tempGlobal + (get_global_mouse_position() - tempGlobal).normalized() * 37
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
			if not interact_text:
				Globals.apply_interact_text(self)
		
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
		#print("Sleeping")
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(1, false)
