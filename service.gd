extends Node

var order_time = 30 * Engine.target_fps

var arrivals_time = 240 * Engine.target_fps
var service_time = 180 * Engine.target_fps

var random_arrival_time = int(arrivals_time)

onready var main = $"/root/main"
onready var nav = $"/root/main/nav"
onready var input_arrivals = $"/root/main/menu/arrivals_time"
onready var input_service = $"/root/main/menu/service_time"
onready var messages = $"/root/main/menu/messages"

onready var target1 = $"/root/main/target1".global_transform.origin
onready var target2 = $"/root/main/target2".global_transform.origin

onready var start1 = $"/root/main/start1".global_transform.origin
onready var start2 = $"/root/main/start2".global_transform.origin
onready var start3 = $"/root/main/start3".global_transform.origin
onready var start4 = $"/root/main/start4".global_transform.origin

onready var starts = [start1, start2, start3, start4]


var tick = 0

func _physics_process(delta):
	if (tick % random_arrival_time == 0):
		randomize()
		random_arrival_time = randi() % int(arrivals_time) + 1 #randomized
		print(random_arrival_time)
		messages.text = "car placed. next one in " + str(random_arrival_time / Engine.target_fps) + " seconds"
		place_car()
	
	tick += 1

func place_car():
	var car = load("res://car.tscn").instance()
	car.global_transform.origin = starts[randi() % 4]
	main.add_child(car)

func _ready():
	input_arrivals.text = str(arrivals_time / Engine.target_fps)
	input_service.text = str(service_time / Engine.target_fps)
