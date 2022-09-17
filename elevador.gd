extends Area2D

export(String, FILE) var next_scene_path = ""
onready var sprite = $Sprite
onready var anim_play = $AnimationPlayer


func _ready():
	sprite.visible = true
	var player = find_parent("currentscene").get_children().back().find_node("Player")
	player.connect("player_entering_door_signal", self, "enter_door")
	player.connect("player_entered_door_signal", self, "close_door")
	
func enter_door():
	anim_play.play("OpenDoor")
		
func close_door():
	anim_play.play("CloseDoor")
		
func door_closed():
	get_node(NodePath("/root/SceneManager/")).transition_to_scene(next_scene_path)
