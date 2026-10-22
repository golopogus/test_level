extends StaticBody2D

var starting_pt
var ending_pt
var scale_conversion = .00775
enum states {INSIDE,OUTSIDE}
var state = states.OUTSIDE


func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("right_click"):
		if state == states.INSIDE:
			queue_free()
	
func modify_shape(x,y,pos):
	
	
	position = pos
	
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$Area2D/CollisionShape2D.shape = $Area2D/CollisionShape2D.shape.duplicate()
	
	
	$CollisionShape2D.shape.size = Vector2(abs(x),abs(y))
	$Area2D/CollisionShape2D.shape.size = Vector2(abs(x),abs(y))
	#
	$Sprite2D.scale = $CollisionShape2D.shape.size * scale_conversion
	


func _on_area_2d_mouse_entered() -> void:
	state = states.INSIDE


func _on_area_2d_mouse_exited() -> void:
	state = states.OUTSIDE
