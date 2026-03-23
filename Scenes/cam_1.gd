extends Camera3D

@export var smooth := 30.0
@export var smooth_view := 0.14

@export var player : Node3D
@onready var player_gymbal : Node3D = player.gymbal



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	ancla_follow(delta)
	gymbal_follow(delta)



func gymbal_follow(delta: float)-> void:
	
	#copy player gymbal rotation axis and vertical location
	
	rotation.x = lerp_angle(rotation.x,player_gymbal.rotation.x *-1.0,smooth_view)
	rotation.z = player_gymbal.rotation.z *0.1
	
	
	print(player_gymbal.global_position.y)
	global_transform.origin = global_transform.origin.lerp(player_gymbal.global_position, delta * smooth )


	#otra medicina, before headake nausea, prevent gedeke
func ancla_follow(delta: float) -> void:
	
	#global_transform.origin = global_transform.origin.lerp(%ancla_player.global_transform.origin, delta * smooth ) 
	rotation.y = lerp_angle(rotation.y ,%ancla_player.rotation.y,smooth_view)
