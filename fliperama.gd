extends Area2D

var character_name : String = "Péricles"
var lvl : int = 49
func _ready():
	pass

func _on_fliperama_body_entered(body):
	get_tree().change_scene("res://battle.tscn")
