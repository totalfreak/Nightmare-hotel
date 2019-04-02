extends Node2D


const GRAVITY = 20

var ray

var result

var ray_draw_list = []

var global_mouse

var player

var current_scene
var old_scene

func _ready():
	pass


func _physics_process(delta):
	global_mouse = get_global_mouse_position()


func check_if_player_in_light(position, length):
	var space_state = get_world_2d().direct_space_state
	
	#print((player.global_position - global_position).normalized())
	# Fire ray from the light position towards player position, at the player physics layer
	result = space_state.intersect_ray(position, player.global_position, [], 1)
	
	#print(result)
	if result:
		if result.collider == player and position.distance_to(player.global_position)  / 30 < length:
			ray_draw_list.append([result.position, position])
			update()
			#print(result.position.distance_to(position))
			return result


func _draw():
	var i = 0
	for ray in ray_draw_list:
		
		draw_line(ray[0], ray[1], Color(1, 0, 0))
		ray_draw_list.remove(i)
		i += 1
		

func enter_ventilation(enter_pos):
	# Disabling the normal collision and mask to only be physics with vent
	player.set_collision_layer_bit(0, false)
	player.set_collision_mask_bit(0, false)
	player.set_collision_layer_bit(3, true)
	player.set_collision_mask_bit(3, true)
	player.get_node("Camera2D").current = true
	player.global_position = enter_pos
	player.inside_vent = true
	player.get_node("Ventilation Light2D").visible = true
	#player.gravity_scale = 0

func exit_ventilation(exit_pos):
	# Applying the normal collision layer and mask
	player.set_collision_layer_bit(0, true)
	player.set_collision_mask_bit(0, true)
	player.set_collision_layer_bit(3, false)
	player.set_collision_mask_bit(3, false)
	player.global_position = exit_pos
	player.inside_vent = false
	player.get_node("Ventilation Light2D").visible = false
	#player.gravity_scale = 2.5


func door_entered(exitPos):
	player.global_position = exitPos


func _Change_Scene(var newScene):
	# Save the prior scene
	old_scene = get_tree().current_scene.get_filename()
	current_scene = newScene
	get_tree().change_scene(newScene)
	pass


func player_death():
	_Change_Scene("res://Scenes/UI/DeathScreen.tscn")

func apply_outline(sprite):
	sprite.get_material().set_shader_param("shouldOutline", true)

func remove_outline(sprite):
	sprite.get_material().set_shader_param("shouldOutline", false)
