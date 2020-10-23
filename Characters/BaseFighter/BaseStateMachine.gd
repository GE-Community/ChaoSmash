extends StateMachine


func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state",states.idle)

func _input(event):
	if [states.idle,states.run].has(state):
		if event.is_action_pressed("player_jump"):
			parent.jump()
		
		
	if state == states.jump:
		if event.is_action_released("player_jump") && parent.velocity.y < parent.min_jump_velocity:
			parent.velocity.y = parent.min_jump_velocity

func _state_logic(delta):
	parent._handle_sideways_movement()
	parent._apply_gravity(delta)
	parent._apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y >0:
					return states.fall
			elif parent.move_direction != 0:
				return states.run
		states.run :
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y >0:
					return states.fall
			elif parent.move_direction == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >=0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y <0:
				return states.jump
	
	return null

func _enter_state(new_state, old_state):
	pass


func _exit_state(old_state, new_state):
	pass
