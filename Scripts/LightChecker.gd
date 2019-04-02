extends Light2D

var player_result
var player_in_light = false

func _ready():
	set_physics_process(true)
	pass

func _physics_process(delta):
	player_result = Globals.check_if_player_in_light(global_position, texture_scale)
	if player_result:
		if not player_in_light:
			player_in_light = true
			Globals.player.enter_light()
	else: 
		if player_in_light:
			player_in_light = false
			Globals.player.leave_light()
