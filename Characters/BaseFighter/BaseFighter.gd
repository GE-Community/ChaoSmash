extends KinematicBody2D

#Onready Vars
onready var ground_raycasts = $GroundRaycasts
onready var body = $Body
onready var baseFSM = $BaseFSM
onready var base_state_label = $BaseFSMlabel
#Constants
const MAX_SPEED : int = 580
const MAX_STRENGTH : int = 100
const MAX_DEFENSE : int = 100

#Checks
var is_sprinting = false

#Variables
var velocity : Vector2 = Vector2()
var is_grounded : bool = false
var current_jumps : int = 0
var move_direction : int

export var stats = {
	"speed" :  0, #make it 1-10
	"strength" : 0, #same as above, make it 1-10
	"defense" : 0
}

export var movement_settings = {
	"jump_velocity" : -620,
	"min_jump_velocity" : -200, #recommended -200
	"air_jumps" : 1,
	"air_control" : 0.05, #must be lower than 0.1
	"ground_friction" : 0.1, # must be lower than 0.3
	"sprint_multiplier" : 1.5 #The faster the fighter, the lower the multiplier should be
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

#Vertical Movement

func jump():
	velocity.y = movement_settings.jump_velocity

func _air_jump():
	if current_jumps > 0:
		jump()
		current_jumps -= 1


func _reset_air_jump():
	current_jumps = movement_settings.air_jumps

func _check_is_grounded():
	for raycast in ground_raycasts.get_children():
		if raycast.is_colliding():
			return true
	
	return false


func _apply_gravity(delta):
	velocity.y += Globals.gravity * delta


#Horizontal Movement


func _apply_movement():
		velocity = move_and_slide(velocity,Vector2.UP)
		is_grounded = _check_is_grounded()

func _run_movement():
		velocity.x = lerp(velocity.x, stats.speed * move_direction,_get_h_weight())

#Multiplies the fighter's speed with its speed multiplier
func _sprint_movement():
		velocity.x = lerp(velocity.x, stats.speed * movement_settings.sprint_multiplier * move_direction, _get_h_weight())

#Detects left and right inputs
func _left_right_input():
	move_direction = -int(Input.is_action_pressed("player_left")) +int(Input.is_action_pressed("player_right"))

#Updates the body's direction
func _update_facing():
	if move_direction != 0:
		body.scale.x = move_direction

#Gets the "friction" and applies it
func _get_h_weight():
	return movement_settings.ground_friction if is_grounded else movement_settings.air_control
