extends KinematicBody

var path = []
var path_ind = 0
var move_speed = randf() * 2.5 + 0.5
var orig_speed = move_speed
const gravitiy = -0.5
var backtrack = false

onready var ray = $ray
onready var origin = global_transform.origin

var order_timer = service.order_time
var service_timer = service.service_time

func _ready():
	move_to(service.target1)

func _physics_process(delta):
	if path_ind < path.size():
		var move_vec
		if $ray.is_colliding():
			move_vec = (path[path_ind - 2] - global_transform.origin)
		else:
			move_vec = (path[path_ind] - global_transform.origin)
			if global_transform.origin.distance_to(path[path_ind]) > 0.2:
				look_at(Vector3(path[path_ind].x, global_transform.origin.y, path[path_ind].z), Vector3.UP)
		
		if move_vec.length() < 0.1:
			if $ray.is_colliding():
				path_ind += -1
			else:
				path_ind += 1
		else:
			move_and_slide_with_snap(move_vec.normalized() * move_speed + Vector3(0, gravitiy, 0), Vector3.UP)
	else:
			if global_transform.origin.distance_to(service.target1) < 0.5:
				if order_timer == 0:
					move_speed = 1.0
					move_to(service.target2)
					service.messages.text = "ordered. going to wait at pickup"
					service_timer += service.order_time
				else: order_timer -= 1
			elif global_transform.origin.distance_to(service.target2) < 0.5:
				if service_timer == 0:
					move_speed = orig_speed
					move_to(origin)
					service.messages.text = "picked up. going home"
				else: service_timer -= 1
			elif global_transform.origin.distance_to(origin) < 0.5:
				queue_free()

	
func move_to(t):
	path = service.nav.get_simple_path(global_transform.origin, t, true)
	path_ind = 0
