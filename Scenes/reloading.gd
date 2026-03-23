extends Label

var alpha 
var tiempo := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.depleted_en:
		self.visible = true
	else:
		self.visible = false
	tiempo += delta*15
	alpha = sin(tiempo) 
	self.modulate.a = alpha
