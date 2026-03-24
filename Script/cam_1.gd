extends Camera3D

@export var smooth := 30.0
@export var smooth_view := 0.14

@export var player : Node3D




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	ancla_follow(delta)
	gymbal_follow(delta)



func gymbal_follow(delta: float)-> void:
	
	#copy player gymbal rotation axis and vertical location

	rotation.x = lerp_angle(rotation.x,player.gymbal.rotation.x *-1.0,smooth_view)
	rotation.z = player.gymbal.rotation.z *0.1
	
	
	
	global_transform.origin = global_transform.origin.lerp(player.gymbal.global_position, delta * smooth )


	#otra medicina, before headake nausea, prevent gedeke
func ancla_follow(delta: float) -> void:
	
	#global_transform.origin = global_transform.origin.lerp(%ancla_player.global_transform.origin, delta * smooth ) 
	rotation.y = lerp_angle(rotation.y ,%ancla_player.rotation.y,smooth_view)
