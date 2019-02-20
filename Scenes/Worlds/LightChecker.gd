extends Light2D



func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	Globals.check_if_player_in_light(global_position)
	pass
