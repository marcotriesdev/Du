extends Panel

var tiempo := 0.0
var alpha : float
@export var label_array : Array[Label]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	oscillate_color(delta)
	global_position = label_array[Global.menu_index].global_position


func oscillate_color(delta:float) -> void:
	tiempo += delta*15
	alpha = sin(tiempo) 
	self.modulate.a = alpha
