extends Control

func _ready():
	visible = false
	$background.visible = false
	event_handler.connect("battle_started", self, "init")
	pass
	
func init(character_name, lvl):
	visible = true
	$AnimationPlayer.play("fade-in")
	$background/Panel/Label.text = "a wild %s lvl %s appears" %[character_name, lvl]
	get_tree().paused = true
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade-in":
		$AnimationPlayer.play("fade-out")
		$background.visible = true
		$background/Panel/fazer.grab_focus()
	pass


func _on_fazer_pressed():
	$background/Panel/Label.text = "voce esta sem arma"	
	pass


func _on_run_pressed():
	get_tree().paused = false
	visible = false
	$background.visible = false
	pass 
