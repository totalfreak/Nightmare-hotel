extends KinematicBody2D

const UP = Vector2(0, -1)

var motion = Vector2()
var speed = 50
var chasing = false
var dazed = false

var direction = 1

var walkingRange = 200
var distanceWalked = 0
onready var enemy = get_node(".")

onready var daze_timer = $"Daze Timer"

func _ready():
	set_process(true)
	$WalkingSound.playing = true
	daze_timer.connect("timeout", self, "get_not_dazed")
	pass

func _physics_process(delta):
	Globals.enemy = enemy
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
	elif chasing and not dazed:
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
	if not dazed:
		motion = move_and_slide(motion * speed * delta, UP)
	else:
		$EnemySprite.play("Idle")
		motion = Vector2()

func get_hit_by_box():
	if not dazed:
		get_dazed()


func get_dazed():
	dazed = true
	daze_timer.start(2)

func get_not_dazed():
	dazed = false
	daze_timer.stop()