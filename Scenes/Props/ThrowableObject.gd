extends RigidBody2D

var OGowner
var playerInside = false
var isPickedUp = false
var throwOffset = Vector2(0,0)
var throwForce = 30000


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
	pass

func pickUpObject():
	
	self.get_parent().remove_child(self)
	Globals.player.get_node("ThrowableContainer").add_child(self)
	self.set_owner(Globals.player.get_node("ThrowableContainer"))
	self.position = Vector2(0,0)
	self.mode = RigidBody2D.MODE_KINEMATIC
	set_collision_layer_bit(3, false)
	set_collision_mask_bit(3, false)
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(4, false)
	pass

func _on_PlayerEntered_body_entered(body):
	if body == Globals.player:
		playerInside = true
		if not isPickedUp:
			my_sprite.get_material().set_shader_param("shouldOutline", true)
	pass


func _on_PlayerEntered_body_exited(body):
	if body == Globals.player:
		playerInside = false
		my_sprite.get_material().set_shader_param("shouldOutline", false)
	pass 
