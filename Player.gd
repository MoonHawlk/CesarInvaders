extends KinematicBody2D

export var walk_speed = 8.0
export var jump_speed = 4.0
const TILE_SIZE = 16

signal player_entering_door_signal
signal player_entered_door_signal

onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var ray = $RayCast2D
onready var door_ray = $DoorRayCast2D

enum PlayerState{IDLE, TURNING, WALKING}
enum FacingDirection{LEFT, RIGHT, UP, DOWN}

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN

var initial_position = Vector2(0, 0)
var input_direction = Vector2(0, 0)
var is_moving = false
var stop_input: bool = false
var frog
var percent_moved_to_next_tile = 0.0

func _ready():
	$Sprite.visible = true
	anim_tree.active = true
	initial_position = position


func _physics_process(delta):
	if player_state == PlayerState.TURNING or stop_input:
		return
	elif is_moving == false:
		process_player_input()
	elif input_direction != Vector2.ZERO:
		move(delta)
		anim_state.travel("Walk")
	else:
		anim_state.travel("Idle")
		is_moving = false
		
func process_player_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))	
		
	if input_direction != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Walk/blend_position", input_direction)
		anim_tree.set("parameters/Turn/blend_position", input_direction)
		
		if need_to_turn():
			player_state = PlayerState.TURNING
			anim_state.travel("Turn")
		else:
			initial_position = position
			is_moving = true
	else:
		anim_state.travel("Idle")	
	
func need_to_turn():
	var new_facing_direction
	if input_direction.x < 0:
		new_facing_direction = FacingDirection.LEFT
	elif input_direction.x > 0:
		new_facing_direction = FacingDirection.RIGHT
	elif input_direction.y < 0:
		new_facing_direction = FacingDirection.UP
	elif input_direction.y > 0:
		new_facing_direction = FacingDirection.DOWN
	
	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true
	facing_direction = new_facing_direction
	return false
	
func finished_turning():
	player_state = PlayerState.IDLE
	
func entered_door():
	emit_signal("player_entered_door_signal")
	
func move(delta):
	percent_moved_to_next_tile += walk_speed * delta
	var desired_step: Vector2 = input_direction * TILE_SIZE / 2
	ray.cast_to = desired_step
	ray.force_raycast_update()
	
	door_ray.cast_to = desired_step
	door_ray.force_raycast_update()
	
	if door_ray.is_colliding() and frog == 1:
		if percent_moved_to_next_tile == 0.0:
			emit_signal("player_entering_door_signal")
			percent_moved_to_next_tile += walk_speed * delta
		if  percent_moved_to_next_tile >= 1.0:
			position = initial_position + (input_direction * TILE_SIZE)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			stop_input = true
			$AnimationPlayer.play("Disappear")
			$Camera2D.clear_current()
			
		else:
			position = initial_position + (input_direction * TILE_SIZE * percent_moved_to_next_tile)
			
	if !ray.is_colliding():
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * input_direction)
			percent_moved_to_next_tile = 0.0
			is_moving = false
		else:
			position = initial_position + (TILE_SIZE * input_direction * percent_moved_to_next_tile)
	else:
		is_moving = false


func _on_sapo_body_entered(body):
	frog = 1
	
