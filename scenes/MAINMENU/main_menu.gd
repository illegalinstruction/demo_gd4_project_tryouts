#                          _                                      
#         ____ ___  ____ _(_)___       ____ ___  ___  ____  __  __
#        / __ `__ \/ __ `/ / __ \     / __ `__ \/ _ \/ __ \/ / / /
#       / / / / / / /_/ / / / / /    / / / / / /  __/ / / / /_/ / 
#      /_/ /_/ /_/\__,_/_/_/ /_/____/_/ /_/ /_/\___/_/ /_/\__,_/  
#                             /_____/                             
#-----------------------------------------------------------------------      

extends Node2D;

#-----------------------------------------------------------------------      
func _on_btn_quit_pressed() -> void:
	get_tree().quit();
	return;

#-----------------------------------------------------------------------      
func _on_btn_play_pressed() -> void:
	get_parent().notify_menu_done();
	pass # Replace with function body.
