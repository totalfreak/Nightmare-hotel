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
	player = get_tree().get_root().get_node("Player")
	pass


func _physics_process(delta):
	global_mouse = get_global_mouse_position()
	

func check_if_player_in_light(position):
	if not player:
		player = get_tree().get_root().get_node("Player")
		print(get_tree().root)
	var space_state = get_world_2d().direct_space_state
	
	result = space_state.intersect_ray(position, player.global_position)
	
	if result:
		ray_draw_list.append(result.position)
		print("Player is in light")
	update()

func _draw():
	if result:
		for ray in ray_draw_list:
			draw_line(Vector2(), ray, Color(255,0,0), 1)
			ray_draw_list.erase(ray)



func _Change_Scene(var newScene):
	get_tree().change_scene(newScene)