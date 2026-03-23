extends CharacterBody3D


const SPEED = 5.0

enum MOVESTATE{
	IDLE,
	CHASE,
	CHASEFAST,
	SHAKY,
	STOP
	  }

func _ai_process(delta: float) -> Vector3:
	
	var ai_vector := Vector3(randf_range(-1.0,1.0),0,randf_range(-1.0,1.0))
	
	return ai_vector

func _shakyshaky(delta: float) -> Vector3:
	
	var ai_vector := Vector3(randf_range(-1.0,1.0),0,randf_range(-1.0,1.0))
	
	return ai_vector



func _ai_movement(delta: float,vector) -> void:
	
	var custom_gravity := get_gravity() * Global.gravity_multiplier
	if not is_on_floor():
		velocity += custom_gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	var direction : Vector3 = vector
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _physics_process(delta: float) -> void:

	_ai_movement(delta,_ai_process(delta))
