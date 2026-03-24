extends Node3D

@onready var animation = $AnimationTree
var shootR = false
var shootL = false
var smooth_dir := Vector2.ZERO
var smooth_viewdir := Vector2.ZERO
@export var gymbal := Node3D

var look_value : float


func _ready() -> void:
	animation.active = true


func _process(delta: float) -> void:
	
	walk_animation(delta)
	look_animation(delta)
	

func walk_animation(delta:float) -> void:
	
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")	
	#smoothing to prevent snappy movement:
	smooth_dir = smooth_dir.lerp(dir,8*delta)
	animation["parameters/Legs/blend_position"] = smooth_dir
	animation["parameters/Core/blend_position"] = smooth_dir	
	
func look_animation(delta:float) -> void:
	
	var lookdir = Input.get_vector("view_left","view_right","view_up","view_down")
	#smooth_viewdir = smooth_viewdir.lerp(lookdir,8*delta)
	if lookdir.y != 0:
		look_value += lookdir.y * 0.07 # adds the input to the current Y component of the view angle and the 0.07 smoothens it
	look_value = clampf(look_value,-1.0,1.0) # clamps the vertical view to a limit 
	
	animation["parameters/lookanim/blend_position"] = look_value * -1 #inverted the value, gave me trouble
	
	#walk animation while turning
	animation["parameters/turnwalk/blend_position"] = smooth_viewdir.x
