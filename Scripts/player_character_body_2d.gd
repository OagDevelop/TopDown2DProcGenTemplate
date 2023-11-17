extends CharacterBody2D

signal pulse_global_position(p_global_position:Vector2)

var speed = 200

func _physics_process(delta):
	var _direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")#get a v2 of arrow keys
	velocity = _direction * speed #modify the velocity
	move_and_slide()#this function applies the new velocity

func _on_pulse_global_position_timeout():#called from timer node
	pulse_global_position.emit(global_position)#send out the global position via a signal
