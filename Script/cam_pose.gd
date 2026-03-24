@tool
extends Node3D

@export_range(10.0,120.0,10.0) var set_fov := 90.0
@onready var guide : Node3D = $Guide

@export var pose_id : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		guide.visible = true
	else:
		guide.visible = false
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
