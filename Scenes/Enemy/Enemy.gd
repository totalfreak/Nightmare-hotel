extends KinematicBody2D

const UP = Vector2(0, -1)

var motion = Vector2()
var speed = 70
var chasing = false

var direction = 1

var walkingRange = 200
var distanceWalked = 0

func _ready():
	set_process(true)
	$WalkingSound.playing = true
	pass

func _physics_process(delta):
	var enemy = self
	var player = Globals.player
	motion.x = speed * direction
	
	if not is_on_floor():
		motion.y += 200
	
	$EnemySprite.flip_h = false if direction == 1 else true
	
	if not chasing:
		$EnemySprite.play("Walk")
		if distanceWalked >= walkingRange:
			direction = direction * -1
			distanceWalked = 0
		distanceWalked += 1
	elif chasing:
		$DanAngry.play()
		#Stop chasing if player is inside the vent or in the shadows
		if Globals.player.inside_vent or Globals.player.hidden:
			chasing = false
		$EnemySprite.frames.set_animation_speed("Walk", 10)
		$WalkingSound.pitch_scale = 1.3
		if player.global_position.x < enemy.global_position.x:
			direction = -1
		elif player.global_position.x > enemy.global_position.x:
			direction = 1
		else: 
			$EnemySprite.play("Idle")
		motion.x = (speed * 2) * direction
	motion = move_and_slide(motion * speed * delta, UP)