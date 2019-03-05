extends Node2D

const GRAVITY = 20

var ray

var result

var ray_draw_list = []

var global_mouse

var player

var angle = 0
var max_angle = 360
var angle_step = 5

func _ready():
	pass


func _physics_process(delta):
	global_mouse = get_global_mouse_position()


func check_if_player_in_light(position, length):
	var space_state = get_world_2d().direct_space_state
	#print((player.global_position - global_position).normalized())
	result = space_state.intersect_ray(position, player.global_position)
	#print(result)
	if result:
		if result.collider == player and position.distance_to(player.global_position)  / 20 < length:
			#print(result.position.distance_to(position))
			return result

func enter_ventilation(enter_pos):
	# Disabling the normal collision and mask to only be physics with vent
	player.set_collision_layer_bit(0, false)
	player.set_collision_mask_bit(0, false)
	player.set_collision_layer_bit(3, true)
	player.set_collision_mask_bit(3, true)
	player.global_position = enter_pos
	player.inside_vent = true

func exit_ventilation(exit_pos):
	# Applying the normal collision layer and mask
	player.set_collision_layer_bit(0, true)
	player.set_collision_mask_bit(0, true)
	player.set_collision_layer_bit(3, false)
	player.set_collision_mask_bit(3, false)
	player.global_position = exit_pos
	player.inside_vent = false

func _Change_Scene(var newScene):
	get_tree().change_scene(newScene)