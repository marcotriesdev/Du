extends Node2D

@onready var armor_label = $left_panel/ARMOR2
@onready var en_label = $left_panel/EN_BAR
@onready var speed_label = $left_panel/SPEED
@onready var speed = $left_panel/SPEEDNO

var init_armor_color
var red_color = Color(1.0,0.0,0.0,1.0) 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_armor_color = armor_label.get_theme_color("font_color")
	

func _ap_color(delta: float) -> void:
	
	if Global._ap_percentage() <= 30.0:
		armor_label.add_theme_color_override("font_color",red_color) 
	else:
		armor_label.add_theme_color_override("font_color",init_armor_color) 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	armor_label.text = str(Global.player_ap)
	
	en_label.value = Global._en_percentage()
	
	speed.text = str(snapped(Global.player_vel,0.01)*5, "KM/h")
	
	_ap_color(delta)
	
	#print(Global._en_percentage())
