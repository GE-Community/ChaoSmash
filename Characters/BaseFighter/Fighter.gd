extends KinematicBody2D

var velocity = Vector2(0, 0)
var target_velocity = Vector2(0, 0)

func _input(event):
	target_velocity.x = -Input.get_action_strength("player_left") + Input.get_action_strength("player_right")
	target_velocity.x *= 100

func _physics_process(delta):
	velocity = velocity.linear_interpolate(target_velocity, 0.1)

	velocity = move_and_slide(velocity, Vector2.UP)
