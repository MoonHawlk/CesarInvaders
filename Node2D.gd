extends Node2D

var next_scene = null
func _ready():
	pass

func transition_to_scene(New_scene: String):
	next_scene = New_scene
	$CanvasLayer/AnimationPlayer.play("fadetoblack")

func finished_fading():
	$currentscene.get_child(0).queue_free()
	$currentscene.add_child(load(next_scene).instance())
	$CanvasLayer/AnimationPlayer.play("fadetonormal")
