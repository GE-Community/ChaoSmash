extends KinematicBody2D

#Onready Vars
onready var ground_raycasts = $GroundRaycasts
onready var body = $Body
onready var baseFSM = $BaseFSM

#Constants
const MAX_SPEED : int = 580
const MAX_STRENGTH : int = 100
const MAX_DEFENSE : int = 100

#Variables
var velocity : Vector2 = Vector2()
var is_grounded : bool = false
var current_jumps : int = 0
var move_direction

export var stats = {
	"speed" :  0, #make it 1-10
	"strength" : 0, #same as above, make it 1-10
	"defense" : 0,
	"jump_velocity" : -620,
	"min_jump_velocity" : -200, #reommended -200
	"air_jumps" : 1
}


#these "can" be negative but not zero




func error_start_check():
	#returns false if is missing key components
	for i in stats.values():
		if i == 0:
			print("stats can not be zero!")
			return false
	if !ground_raycasts:
		print("You must add ground raycasts to player. Use Node2d named 'GroundRaycasts' with raycast2ds as children")
	elif !body:
		print("Please Store all visual nodes such as sprites inside a Node2D named 'Body'")
		return false
	elif !baseFSM:
		print("Please create a node named BaseFSM that inherits from res://Characters/BaseFighter/BaseStateMachine.gd ")
	else:
		return true

func _ready():
	set_physics_process(false)
	if error_start_check():
		stats.speed = MAX_SPEED * stats.speed / 10
		stats.strength = MAX_STRENGTH * stats.strength / 10
		stats.defense = MAX_DEFENSE * stats.defense / 10
		set_physics_process(true)
	else:
		get_tree().quit()

func jump():
	velocity.y = stats.jump_velocity

func _air_jump():
	if current_jumps > 0:
		jump()
		current_jumps -= 1


func _reset_air_jump():
	current_jumps = stats.air_jumps

func _check_is_grounded():
	for raycast in ground_raycasts.get_children():
		if raycast.is_colliding():
			return true
	
	return false


func _apply_gravity(delta):
	velocity.y += Globals.gravity*delta







func _physics_process(delta):
	pass



func _apply_movement():
		velocity = move_and_slide(velocity,Vector2.UP)
		
		
		is_grounded = _check_is_grounded()


func _handle_sideways_movement():
	move_direction = -int(Input.is_action_pressed("player_left"))+int(Input.is_action_pressed("player_right"))
	velocity.x = lerp(velocity.x, stats.speed * move_direction,_get_h_weight())

	if move_direction != 0:
		body.scale.x = move_direction

func _get_h_weight():
	return 0.2 if is_grounded else 0.1
