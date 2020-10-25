extends StateMachine
class_name BaseFSM

func _ready():
	add_state("idle")
	add_state("run")
	add_state("dash")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state",states.idle)

func _input(event):
	#Jumping
	if [states.idle,states.run, states.dash].has(state):
		if event.is_action_pressed("player_jump"):
			parent.jump()
	
	if [states.jump, states.fall].has(state):
		if event.is_action_pressed("player_jump"):
			parent._air_jump()
	
	if state == states.jump:
		if event.is_action_released("player_jump") && parent.velocity.y < parent.movement_settings.min_jump_velocity:
			parent.velocity.y = parent.movement_settings.min_jump_velocity
	
	#Dashing
	if event.is_action_pressed("temp_dash"):
		print("Shift Pressed")
		parent.is_sprinting = true
	if event.is_action_released("temp_dash"):
		parent.is_sprinting = false

func _state_logic(delta):
	#General Movement
	parent._apply_movement()
	parent._left_right_input()
	
	if [states.run,states.dash, states.jump, states.fall].has(state):
		parent._update_facing()
	#Horizontal Movement
	if [states.idle, states.run, states.jump, states.fall].has(state):
		parent._run_movement()
	
	if [states.dash].has(state):
		parent._sprint_movement()
	
	#if [states.dash].has(state):
	#	parent._sprint_movement()
	#Vertical Movement
	if parent.is_grounded && parent.current_jumps != parent.movement_settings.air_jumps:
		parent._reset_air_jump()
	parent._apply_gravity(delta)


func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.move_direction != 0:
				return states.run
		states.run :
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.move_direction == 0:
				return states.idle
			elif parent.is_sprinting:
				return states.dash
		states.dash:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.is_on_floor():
				if !parent.is_sprinting:
					return states.run
				elif abs(parent.velocity.x) <= parent.stats.speed / 0.9 && parent.move_direction == 0:
					return states.run
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
	
	return null

func _enter_state(new_state, old_state):
	parent.base_state_label.set_text(states.keys()[state])
	match new_state:
		states.idle:
			pass
		states.run:
			pass
		states.dash:
			pass
		states.jump:
			pass
		states.jump:
			pass
		states.fall:
			pass
	pass


func _exit_state(old_state, new_state):
	pass
