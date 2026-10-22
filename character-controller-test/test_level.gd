extends Node2D

var starting_pt
var ending_pt
var shape_preload = preload("res://ground.tscn")


func _ready() -> void:
	$Label.visible = Globals.label_visible
	
func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("left_click"):
		starting_pt = get_global_mouse_position()
	
	if Input.is_action_just_released("left_click"):
		ending_pt = get_global_mouse_position()
		spawn_shape()
	
		
func spawn_shape():
	
	var x_length = ending_pt.x - starting_pt.x
	var y_length = ending_pt.y - starting_pt.y
	var spawn_position = Vector2(starting_pt.x + x_length/2,starting_pt.y + y_length/2)
	var shape = shape_preload.instantiate()
	add_child(shape)
	shape.modify_shape(x_length,y_length,spawn_position)
	
	


func _on_hide_pressed() -> void:
	if $Label.visible:
		Globals.label_visible = false
		$Label.visible = false
	else:
		Globals.label_visible = true
		$Label.visible = true
		


func _on_reset_pressed() -> void:
	get_tree().change_scene_to_file("res://test_level.tscn")



func _on_h_slider_value_changed(value: float) -> void:
	
	$menu/gravity_label.text = 'gravity: ' + str(value)
	$peepee.change_value('gravity',value)


func _on_c_slider_value_changed(value: float) -> void:
	$menu/coyote_timing.text = 'coyote timing: ' + str(value) + ' s'
	$peepee.change_value('coyote',value)


func _on_hs_value_changed(value: float) -> void:
	$menu/horizontal_speed_label.text = 'horizontal speed: ' + str(value)
	$peepee.change_value('horizontal_speed',value)


func _on_ha_value_changed(value: float) -> void:
	$menu/horizontal_acceleration_label.text = 'horizontal speed: ' + str(value)
	$peepee.change_value('horizontal_acceleration',value)


func _on_h_slider_3_value_changed(value: float) -> void:
	$menu/jump_label.text = 'jump force: ' + str(value)
	$peepee.change_value('jump',value)


func _on_h_slider_4_value_changed(value: float) -> void:
	$menu/short_jump_label.text = 'short jump brake: ' + str(value)
	$peepee.change_value('short_jump',value)


func _on_h_slider_5_value_changed(value: float) -> void:
	$menu/friction_label.text = 'friction: ' + str(value)
	$peepee.change_value('friction',value)


func _on_h_slider_6_value_changed(value: float) -> void:
	$menu/horizontal_air_speed_label.text = 'horizontal air speed: ' + str(value)
	$peepee.change_value('horizontal_air_speed',value)


func _on_h_slider_7_value_changed(value: float) -> void:
	$menu/horizontal_air_velocity_label.text = 'horizontal air friction: ' + str(value)
	$peepee.change_value('air_friction',value)
	

func _on_check_box_toggled(toggled_on: bool) -> void:
	$peepee.change_value('double_jump',toggled_on)
