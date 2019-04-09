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
var handsFull = false

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

# Death and light variables
var timeInLight = 0.0
export var maxTimeInLight = 1.0
export var canDie = true
var entered_light = false
var amount_of_lights_entered = 0

var hidden : bool


func _ready():
	Globals.player = player
	set_process_input(true)
	pass


func _input(event):
	
	pass


func enter_light():
	amount_of_lights_entered += 1
	if amount_of_lights_entered >= 1:
		entered_light = true
		$Fire.visible = true
		$Burning.play()
		print("Entered Light")
		print("Amount of lights: ", amount_of_lights_entered)	

func leave_light():
	amount_of_lights_entered -= 1
	if amount_of_lights_entered < 1:
		entered_light = false
		print("Left Light")
		print("Amount of lights: ", amount_of_lights_entered)
		$Fire.visible = false
		$Burning.stop()

func _process(delta):
	if entered_light:
		timeInLight += delta
	elif timeInLight > 0:
		timeInLight -= delta
	
	if timeInLight > maxTimeInLight:
		_Die()
	pass

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
	if not dead and canDie:
		dead = true
		Globals.player_death()
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
			var particle = jumpParticle.instance()
			
			$JumpParticleContainer/JumpParticlePoint.add_child(particle)
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
			if not $Running.is_playing():
				$Running._set_playing(true)
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
		
	if not new_anim == "Run":
			$Running._set_playing(false)
	
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
	# Set gravity when on and off a stair
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

func _on_TouchedByEnemy_body_entered(body):
	if body == Globals.enemy:
		_Die()
		$DeathByenemy.play()
	pass
