#        ___                                      __ 
#       /   |  ____  ____       _________  ____  / /_
#      / /| | / __ \/ __ \     / ___/ __ \/ __ \/ __/
#     / ___ |/ /_/ / /_/ /    / /  / /_/ / /_/ / /_  
#    /_/  |_/ .___/ .___/____/_/   \____/\____/\__/  
#          /_/   /_/   /_____/                       
#-----------------------------------------------------------------------

extends Node2D;

var MAIN_MENU_PARENT = load("res://scenes/MAINMENU/main_menu.tscn");
var GAMEPLAY_PARENT  = load("res://scenes/GAMEPLAY/gameplay.tscn");

var curr_scene : Node = null;

#-----------------------------------------------------------------------
func _ready() -> void:
	curr_scene = MAIN_MENU_PARENT.instantiate()
	add_child(curr_scene);
	$LBL_prev_score.hide();

#-----------------------------------------------------------------------
func notify_menu_done():
	# throw away main menu...
	remove_child(curr_scene);
	curr_scene.queue_free();

	#...and spin up a new game
	curr_scene = GAMEPLAY_PARENT.instantiate();
	add_child(curr_scene);
	print_debug()
	
	# only show this on main menu
	$LBL_prev_score.hide();
		
	return;
	
#-----------------------------------------------------------------------
func notify_game_done(score : int):
	# update this
	$LBL_prev_score.text = "Previous play session: got " + str(score) + " coins!";
	$LBL_prev_score.show();
	
	# throw away gameplay...
	remove_child(curr_scene);
	curr_scene.queue_free();

	#...and spin up a fresh main menu
	curr_scene = MAIN_MENU_PARENT.instantiate();
	add_child(curr_scene);
	
	return;
