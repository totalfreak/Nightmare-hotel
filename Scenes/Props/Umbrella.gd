extends RigidBody2D

var OGowner
var playerInside = false
var isPickedUp = false
var throwOffset = Vector2(0,0)
var throwForce = 30000


func _ready():
	OGowner = self.get_owner()
	print(OGowner)
	pass

func _process(delta):
	if Input.is_action_just_pressed("interact") and playerInside and not Globals.player.handsFull:
		#isPickedUp = true
		Globals.player.handsFull = true
		pickUpObject()

	if Input.is_action_just_pressed("throw") and Globals.player.handsFull: #isPickedUp == true:
		#isPickedUp = false
		Globals.player.handsFull = true
		throwObject(delta)

	pass

func throwObject(delta):
	var throwDir = (get_global_mouse_position() - self.global_position).normalized() * (throwForce * (mass )) * delta
	var tempGlobal = self.global_position
	Globals.player.get_node("ThrowableContainer").remove_child(self)
	OGowner.add_child(self)
	self.global_position = tempGlobal
	self.set_owner(OGowner)
	self.mode = RigidBody2D.MODE_RIGID
	apply_impulse(throwOffset, throwDir)
	set_collision_layer_bit(3, true)
	set_collision_mask_bit(3, true)
	set_collision_layer_bit(4, true)
	set_collision_mask_bit(4, true)
	get_node("Collide").set_collision_layer_bit(0, false)
	get_node("Collide").set_collision_mask_bit(0, false)
	pass

func pickUpObject():
	OGowner.remove_child(self)
	Globals.player.get_node("ThrowableContainer").add_child(self)
	self.set_owner(Globals.player.get_node("ThrowableContainer"))
	self.position = Vector2(0,0)
	self.mode = RigidBody2D.MODE_KINEMATIC
	set_collision_layer_bit(3, false)
	set_collision_mask_bit(3, false)
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(4, false)
	get_node("Collide").set_collision_layer_bit(0, true)
	get_node("Collide").set_collision_mask_bit(0, true)
	pass

func _on_PlayerEntered_body_entered(body):
	if body == Globals.player:
		playerInside = true
	pass


func _on_PlayerEntered_body_exited(body):
	if body == Globals.player:
		playerInside = false
	pass
