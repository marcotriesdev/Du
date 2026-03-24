
extends Camera3D

@export_range(0.01,1.0,0.01) var move_speed = 0.5
@export_range(0.01,1.0,0.01) var fov_speed = 0.5

@export var pose_array: Array[Node3D]
var index : int = 0
@onready var current_pose := pose_array[index]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_transform.origin = current_pose.global_transform.origin
	quaternion = current_pose.quaternion
	fov = current_pose.set_fov
	Global.current_menu_id = current_pose.pose_id

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	input_control(delta)


func change_pose(delta: float,ind: int) -> void:

	var new_pose := pose_array[ind]
	global_transform.origin = lerp(global_transform.origin,new_pose.global_transform.origin,move_speed)
	quaternion = quaternion.slerp(new_pose.quaternion,move_speed)
	fov = lerp(fov,new_pose.set_fov,fov_speed)
	Global.current_menu_id = new_pose.pose_id




func input_control(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_up"):
		if index > 0:
			index -= 1			
		else:
			index = pose_array.size()-1
	
	elif Input.is_action_just_pressed("ui_down"):
		if index < pose_array.size()-1:
			index += 1
		else:
			
			index = 0			
	Global.menu_index = index
	change_pose(delta,index)
