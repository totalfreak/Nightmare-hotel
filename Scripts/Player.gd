extends RigidBody2D


# Member variables
var dead = false
var anim = ""
var siding_left = false
var jumping = false
var stopping_jump = false
var shooting = false
var inside_vent = false
var is_on_stair = false

var WALK_ACCEL = 2000.0
var WALK_DEACCEL = 2000.0
var WALK_MAX_VELOCITY = 150.0
var AIR_ACCEL = 1000.0
var AIR_DEACCEL = 500.0
var JUMP_VELOCITY = 300
var STOP_JUMP_FORCE = 300.0

var MAX_FLOOR_AIRBORNE_TIME = 0.05

var airborne_time = 1e20

var floor_h_velocity = 0.0

onready var jumpParticle = preload("res://Scenes/VFX/JumpDustParticle.tscn")

onready var player = get_node(".")
var entered_light = false
var amount_of_lights_entered = 0

export var knockbackDelay = 0.5

func _ready():
	Globals.player = player
	set_process_input(true)
	pass

func _input(event):
	
	pass



#func _Process_Input(var delta):
#	if Input.is_action_pressed("ui_right"):
#		direction.x = 1
#		$Sprite.flip_h = false
#		# If on floor, play run anim else do either fall or jump anim
#		_Move(delta, "right")
#	elif Input.is_action_pressed("ui_left"):
#		direction.x = -1
#		$Sprite.flip_h = true
#		# If on floor, play run anim else do either fall or jump anim
#		_Move(delta, "left")
#	elif not is_on_floor():
#		#Slow down in air if no direction is pressed
#		if not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
#			motion.x = lerp(motion.x, 0, dampSpeed/5 * delta)
#		#Play jump and fall animations
#		if motion.y < 0:
#			$Sprite.play("Jump")
#		elif motion.y > 0:
#			$Sprite.play("Fall")
#	else:
#		motion.x = lerp(motion.x, 0, dampSpeed * delta)
#		$Sprite.play("Idle")
#
#func _Move(var delta, var dir):
#	if is_on_floor():
#		$Sprite.play("Run")
#	else:
#		if motion.y < 0:
#			$Sprite.play("Jump")
#		else:
#			$Sprite.play("Fall")
#	if dir == "left":
#		motion.x = lerp(motion.x, -moveSpeed, dampSpeed * delta)
#	elif dir == "right":
#		motion.x = lerp(motion.x, moveSpeed, dampSpeed * delta)

func enter_light():
	amount_of_lights_entered += 1
	if amount_of_lights_entered >= 1:
		entered_light = true
		$Fire.visible = true
		print("Entered Light")
		print("Amount of lights: ", amount_of_lights_entered)

func leave_light():
	amount_of_lights_entered -= 1
	if amount_of_lights_entered < 1:
		entered_light = false
		print("Left Light")
		print("Amount of lights: ", amount_of_lights_entered)
		$Fire.visible = false


#func _Jump():
#	motion.y = -jumpSpeed
#	var particle = jumpParticle.instance()
#	$JumpParticleContainer/JumpParticlePoint.add_child(particle)


#func _Hit_Ledge(var body):
#	if not is_on_floor() and is_on_wall() and not grabbedLedge:
#		print($LedgeDetection/Area2D.get_overlapping_areas())
#		grabbedLedge = true
#		print("Got Ledge")
#	pass
#
#func _Lose_Ledge(var body):
#	if not is_on_wall() and grabbedLedge:
#		grabbedLedge = false
#		print("Lost Ledge")
#	pass


func _Die():
	dead = true
	
	pass

func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()
	
	var new_anim = anim
	var new_siding_left = siding_left
	
	# Get the controls
	var move_left = Input.is_action_pressed("ui_left")
	var move_right = Input.is_action_pressed("ui_right")
	var move_down = Input.is_action_pressed("ui_down")
	var jump = Input.is_action_pressed("Jump")
	
	
	# Deapply prev floor velocity
	lv.x -= floor_h_velocity
	floor_h_velocity = 0.0
	
	# Find the floor (a contact with upwards facing collision normal)
	var found_floor = false
	var floor_index = -1
	
	for x in range(s.get_contact_count()):
		var ci = s.get_contact_local_normal(x)
		if ci.dot(Vector2(0, -1)) > 0.6:
			found_floor = true
			floor_index = x
	
	
	if found_floor:
		airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air
	
	var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME

	# Process jump
	if jumping:
		if lv.y > 0:
			# Set off the jumping flag if going down
			jumping = false
		elif not jump:
			stopping_jump = true
		
		if stopping_jump:
			lv.y += STOP_JUMP_FORCE * step
	
	if on_floor:
		# Process logic when character is on floor
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= WALK_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += WALK_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= WALK_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv
		
		# Check jump
		if not jumping and jump and not is_on_stair:
			lv.y = -JUMP_VELOCITY
			jumping = true
			stopping_jump = false
			#$sound_jump.play()
	
		# Check siding
		if lv.x < 0 and move_left:
			new_siding_left = true
		elif lv.x > 0 and move_right:
			new_siding_left = false
		if jumping:
			new_anim = "Jump"
		elif abs(lv.x) < 0.1:
			new_anim = "Idle"
		else:
			new_anim = "Run"
	else:
		# Process logic when the character is in the air
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= AIR_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += AIR_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= AIR_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv
		
		if lv.y < 0:
			new_anim = "Jump"
		else:
			new_anim = "Fall"
	
	# Check siding
	if lv.x < 0 and move_left:
		new_siding_left = true
	elif lv.x > 0 and move_right:
		new_siding_left = false
	
	# Update siding
	if new_siding_left != siding_left:
		if new_siding_left:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
		
		siding_left = new_siding_left
	
	# Change animation
	if new_anim != anim:
		anim = new_anim
		$Sprite.play(anim)
	
	
	# Apply floor velocity
	if found_floor:
		floor_h_velocity = s.get_contact_collider_velocity_at_position(floor_index).x
		lv.x += floor_h_velocity
	
	
	# Move up on stair
	if is_on_stair and jump:
		lv.y -= WALK_ACCEL/5 * step
	# Move down on stair
	elif is_on_stair and move_down:
		lv.y += WALK_ACCEL/5 * step
	elif is_on_stair:
		lv.y = 0
	
	if is_on_stair:
		gravity_scale = 0
	else:
		gravity_scale = 2.5
	
	# Finally, apply gravity and set back the linear velocity
	lv += s.get_total_gravity() * step
	s.set_linear_velocity(lv)

func on_stair():
	print("Entered stair")
	is_on_stair = true

func left_stair():
	print("Left stair")
	is_on_stair = false