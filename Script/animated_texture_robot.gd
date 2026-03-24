extends CharacterBody3D

@onready var b_timer = $boost_reload
@onready var qb_timer = $qboost_time
@onready var blur = $CanvasLayer2/radial_blur
@onready var blur2 = $CanvasLayer3/radial_blur2
@export var MechAnimated : Node3D 
@onready var gymbal : Node3D = MechAnimated.gymbal


var b_reload : bool = true
var qb_active : bool = false
var b_active : bool = false

var ZERO := 0.0
var ONE := 1.0
var SINE := randf_range(0.0,6.28)
var COSINE := randf_range(0.0,6.28)

@export var SPEED := 50.0
var init_speed = SPEED
@export var JUMP_VELOCITY := 40.0
var JUMP_VELOCITY_INIT := JUMP_VELOCITY
@export var JUMP_ACCEL := 2.0

@export var BOOST_EN := 15
@export var QBOOST_EN := 500
@export var BOOST_AIR_EN := 5
var BOOST_AIR_INIT = BOOST_AIR_EN

@export var walk_accel := 50
var walk_accel_init = walk_accel
@export var friction := 150.0
@export var air_friction := 20.0
var init_friction = friction
@export var rotation_friction := 35

@export var boost_acceleration := 50
@export var boost_friction := 100
var vertical_boost := 25
var vertical_boost_init = vertical_boost

@export var qboost_acceleration := 500
@export var qboost_friction := 200

@export var boost_multiplier := 1.0
@export var boost_multiplier_init := 2.0
@export var qboost_multiplier := 1.0
@export var qboost_multiplier_init = 3.0



@export var mouse_sens := 2.5
@export var max_look_up := deg_to_rad(80)
@export var max_look_down := deg_to_rad(-80)

var radial_blur_i := ZERO
var max_blur := 0.5
var blur_delta := 0.2
var blur_displacement_intensity := 1

func _ready() -> void:
	
	print("NOMBRE DE MESH, script de player: ", MechAnimated.gymbal)

func _look(delta: float) -> void:
	
	var look_input := Input.get_vector(
		"view_left",
		"view_right",
		"view_up",
		"view_down"
	)
	# Giro horizontal (Player)

	rotation.y -= look_input.x * mouse_sens * delta 

func _gravity(delta: float) -> void:
	var custom_gravity := get_gravity() * Global.gravity_multiplier
	
	if not is_on_floor(): 
		velocity.y += custom_gravity.y * delta	

func _friction_change(delta: float) -> void:
	
	if is_on_floor():
		friction = init_friction
		BOOST_AIR_EN = ZERO
	else:
		friction = air_friction	
		BOOST_AIR_EN = BOOST_AIR_INIT
		


func _jump(delta: float) -> void:
	
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
func _move(delta: float) -> void:
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var strength := input_dir.length()
	var dir := Vector3(input_dir.x,0,input_dir.y)
	
	if dir != Vector3.ZERO:
		dir = (transform.basis * dir.normalized())
		var newvelx = dir.x * SPEED * strength * boost_multiplier * qboost_multiplier
		var newvelz = dir.z * SPEED * strength * boost_multiplier * qboost_multiplier
		velocity.x = move_toward(velocity.x, newvelx, walk_accel * delta)
		velocity.z = move_toward(velocity.z, newvelz, walk_accel * delta)
	else:
		velocity.x = move_toward(velocity.x, ZERO, friction * delta)
		velocity.z = move_toward(velocity.z, ZERO, friction * delta)

	
	_display_speed(delta,velocity)
	move_and_slide()
			
		
func _boost(delta: float) -> void:
	
	if Global._en_percentage() < 100: #EN regeneration
		if b_reload:
			Global.player_en += Global.player_en_recovery
		
		
	if Input.is_action_pressed("boost"):

		if Global.player_en > 0:
			if not is_on_floor():
				velocity.y = vertical_boost
				Global.player_en -= BOOST_AIR_EN
			Global.player_en -= BOOST_EN 
			boost_multiplier = move_toward(boost_multiplier,boost_multiplier_init,boost_acceleration*delta)
		else:
			boost_multiplier = move_toward(boost_multiplier,ONE,boost_friction*delta)
	else:
		boost_multiplier = move_toward(boost_multiplier,ONE,boost_friction*delta)
		
	
	if Global.player_en < 0:  #limit to positives
		Global.player_en = 0		
		
	if Global.player_en <= 0 and b_reload: #b_reload is to recharge the boost
		b_reload = false
		Global.depleted_en = true
		b_timer.start()
			
func _qboost(delta: float) -> void:
	
	if Input.is_action_just_pressed("quick_boost") and not qb_active:
		if Global.player_en > 0:
			Global.player_en -= QBOOST_EN
			qb_active = true
			qb_timer.start()
	
	if qb_active:
		qboost_multiplier = move_toward(qboost_multiplier,qboost_multiplier_init,qboost_acceleration*delta)
		walk_accel = qboost_acceleration/2
	else:
		walk_accel = walk_accel_init

func _damage_cheat(delta: float) -> void:
	
	if Input.is_action_just_pressed("select"):
		Global.player_ap -= 100
	
func _ancla_angle(delta: float) -> void:
	
	$ancla_player.rotation.y = rotation.y
	
func qbglobal(delta: float) -> void:
	Global.qb_active = qb_active 	
	Global.player_speed = SPEED
	
func _display_speed(delta: float,vel: Vector3) -> void:
	
	Global.player_vel = abs(vel.x) + abs(vel.z)
	
func _physics_process(delta: float) -> void:


	_ancla_angle(delta)
	_look(delta)
	_friction_change(delta)
	_gravity(delta)
	_boost(delta)
	_qboost(delta)
	_jump(delta)
	_move(delta)
	_damage_cheat(delta)
	qbglobal(delta)

func _process(delta: float) -> void:
	
	_radial_blur()

func _on_boost_reload_timeout() -> void:
	b_reload = true
	Global.depleted_en = false


func _on_qboost_time_timeout() -> void:
	qb_active = false
	qboost_multiplier = 1.0

func _sin_gen() -> float:
	
	var value : float
	var sign := randi_range(-1,1)
	if SINE < 6.28 :
		SINE += 0.0001
	else:
		SINE = ZERO
	
	#print("SIN ",cos(SINE) * (blur_displacement_intensity * sign))
	value = sin(SINE) * (blur_displacement_intensity * sign)
	return clampf(value,-0.5,0.5)

func _cos_gen() -> float:
	var value : float
	var sign := randi_range(-1,1)
	if COSINE < 6.28 :
		COSINE += 0.0001
	else:
		COSINE = ZERO
	
	#print("COS ",cos(COSINE) * (blur_displacement_intensity * sign))
	value = cos(COSINE) * (blur_displacement_intensity * sign)
	
	return clampf(value,-0.5,0.5)



func _radial_blur() -> void:
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var dir := Vector3(input_dir.x,0,input_dir.y)	
	
	
	if qb_active:
		if dir != Vector3.ZERO:
			radial_blur_i = move_toward(radial_blur_i,max_blur,blur_delta)
	else:
		radial_blur_i = move_toward(radial_blur_i,ZERO,blur_delta)


	blur.get_material().set_shader_parameter("intensity",radial_blur_i*0.05)
	blur.get_material().set_shader_parameter("center",Vector2(_sin_gen(),_cos_gen()))
	
	blur2.get_material().set_shader_parameter("intensity",radial_blur_i*5)
