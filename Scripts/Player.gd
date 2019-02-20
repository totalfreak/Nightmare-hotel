extends KinematicBody2D

var motion = Vector2()
var direction = Vector2(1,0)

var dead = false
var jumpCount = 0

const UP_VECTOR = Vector2(0, -1)
export var moveSpeed = 150
export var jumpSpeed = 400
export var dampSpeed = 20

onready var jumpParticle = preload("res://Scenes/VFX/JumpDustParticle.tscn")

onready var player = get_node(".")
var entered_light = false


var grabbedLedge = false
export var knockbackDelay = 0.5

func _ready():
	Globals.player = player
	set_process_input(true)
	pass

func _input(event):
	
	pass


func _physics_process(delta):
	#Subtracting gravity
	if not grabbedLedge:
		motion.y += Globals.GRAVITY
	
	
	if not dead:
		# Handling input
		_Process_Input(delta)
	
	#Jumping when on floor
	if not dead and is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		_Jump()
	
	
	if grabbedLedge:
		motion = Vector2(0,0)
		if Input.is_action_just_pressed("ui_accept"):
			grabbedLedge = false
			_Jump()
	
	#Setting motion vector and moving
	motion = move_and_slide(motion, UP_VECTOR)

	pass

func _Process_Input(var delta):
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
		$Sprite.flip_h = false
		# If on floor, play run anim else do either fall or jump anim
		_Move(delta, "right")
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
		$Sprite.flip_h = true
		# If on floor, play run anim else do either fall or jump anim
		_Move(delta, "left")
	elif not is_on_floor():
		#Slow down in air if no direction is pressed
		if not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			motion.x = lerp(motion.x, 0, dampSpeed/5 * delta)
		#Play jump and fall animations
		if motion.y < 0:
			$Sprite.play("Jump")
		elif motion.y > 0:
			$Sprite.play("Fall")
	else:
		motion.x = lerp(motion.x, 0, dampSpeed * delta)
		$Sprite.play("Idle")

func _Move(var delta, var dir):
	if is_on_floor():
		$Sprite.play("Run")
	else:
		if motion.y < 0:
			$Sprite.play("Jump")
		else:
			$Sprite.play("Fall")
	if dir == "left":
		motion.x = lerp(motion.x, -moveSpeed, dampSpeed * delta)
	elif dir == "right":
		motion.x = lerp(motion.x, moveSpeed, dampSpeed * delta)

func enter_light():
	if not entered_light:
		entered_light = true
		print("Entered Light")
		$Fire.visible = true

func leave_light():
	if entered_light:
		entered_light = false
		print("Left Light")
		$Fire.visible = false


func _Jump():
	motion.y = -jumpSpeed
	var particle = jumpParticle.instance()
	$JumpParticleContainer/JumpParticlePoint.add_child(particle)


func _Hit_Ledge(var body):
	if not is_on_floor() and is_on_wall() and not grabbedLedge:
		print($LedgeDetection/Area2D.get_overlapping_areas())
		grabbedLedge = true
		print("Got Ledge")
	pass

func _Lose_Ledge(var body):
	if not is_on_wall() and grabbedLedge:
		grabbedLedge = false
		print("Lost Ledge")
	pass


func _Die():
	dead = true
	
	pass

