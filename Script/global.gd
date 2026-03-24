extends Node

var gravity_multiplier := 5.2

var player_ap_max = 5000.00
var player_ap = player_ap_max

var player_speed : float
var player_vel : float

var  player_en_max := 2000.00
var  player_en := player_en_max

var player_en_recovery := 10.0
var depleted_en : bool = false

var qb_active : bool


var current_menu_id : String
var menu_index : int

func _en_percentage():
	var percentage = (player_en/player_en_max) * 100.00
	return percentage

func _ap_percentage():
	var percentage = (player_ap/player_ap_max) * 100.00
	return percentage
