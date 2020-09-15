extends KinematicBody2D

#Variables
var velocity : Vector2 = Vector2(0, 0)
var target_velocity : Vector2 = Vector2(0, 0)
var gravity : float
var max_jump_velocity : float
var min_jump_velocity : float

#Export Variables
export var Speed : float = 150
export var max_jump_height : float
export var min_jump_height : float
export var jump_duration : float

#Signals
signal move
signal jump

func _ready():
	#Stuff That I Copied from GE's Code LOL
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)

func _input(event):
	var right : float = Input.get_action_strength("player_right") #getting right input
	var left : float = Input.get_action_strength("player_left") #getting left input
	var move_direction : float = right - left #right - left
	var direction = "Right" if move_direction > 0 else "Left" if move_direction < 0 else "Idle" #setting the direction variable
	
	if event.is_action_pressed("player_jump") and is_on_floor(): #Jump
		velocity.y += max_jump_velocity  * Speed #Setting Jump Velocity
		emit_signal("jump")#Emiting Jump Signal
	if event.is_action_released("player_jump") and velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity# Minimum Jump Velocity
	
	target_velocity.x = move_direction * Speed#Setting the target velocity
	
	emit_signal("move", direction)#Emitting Move Signal

func _physics_process(delta):
	velocity = velocity.linear_interpolate(target_velocity, 0.1) #interpolating the velocity
	velocity.y += gravity * Speed * delta #Adding Gravity
	velocity = move_and_slide(velocity , Vector2.UP)
