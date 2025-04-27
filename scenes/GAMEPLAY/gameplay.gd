#                                       __           
#     ____ _____ _____ ___  ___  ____  / /___ ___  __
#    / __ `/ __ `/ __ `__ \/ _ \/ __ \/ / __ `/ / / /
#   / /_/ / /_/ / / / / / /  __/ /_/ / / /_/ / /_/ / 
#   \__, /\__,_/_/ /_/ /_/\___/ .___/_/\__,_/\__, /  
#  /____/                    /_/            /____/   
#            
#-----------------------------------------------------------------------  

extends Node2D;

#------------------------------------------------------------------------
var   coin_starting_life_span     : int = 180; # in frames
var   coin_lifespan               : int = coin_starting_life_span
const TICKS_LOST_PER_COIN         : int = 2;
const TIME_ADDED_PER_COIN         : int = 15; # 1/4 sec

const TICKS_TO_NEXT_COIN          : int = 180;
var coin_clock                    : int = 1; # make a coin happen right away
var score                         : int = 0;
var time_remaining                : int = 2400;

#------------------------------------------------------------------------
# particle effect
var HEARTBURST = load("res://scenes/HEART_PARTICLE/heart_burst_effect.tscn");

#------------------------------------------------------------------------
func _ready() -> void:
	score = 0;

#------------------------------------------------------------------------
func notify_coin_gotten(arg_where : Vector2) -> void:
	var heart_burst = HEARTBURST.instantiate();
	heart_burst.position = arg_where;
	heart_burst.emitting = true;
	add_child(heart_burst);
	
	$HEART_BURST_EFFECT.position = arg_where;
	$HEART_BURST_EFFECT.emitting = true;
	coin_clock              -= TICKS_TO_NEXT_COIN / 2.0; # so the user isn't unfairly forced to wait
	coin_starting_life_span -= TICKS_LOST_PER_COIN;
	score += 1;
	$LBL_score.text = "Coins gotten: " + str(score);
	
	# every ten coins, change the background a bit
	if ((score % 10) == 0):
		$STAR_BACKGROUND.set_galaxy(randi_range($STAR_BACKGROUND.MIN_GALAXY, $STAR_BACKGROUND.MAX_GALAXY));
	
	return;

#------------------------------------------------------------------------
func advance_coin_logic():
	coin_clock -= 1;
	
	# time to hide the coin?
	if ((TICKS_TO_NEXT_COIN - coin_clock) > coin_lifespan):
		$COIN.hide();
	
	# time for next coin to spawn?
	if (coin_clock < 1):
		$COIN.spawn();
		coin_lifespan = coin_starting_life_span;
		coin_clock = TICKS_TO_NEXT_COIN;

#------------------------------------------------------------------------
func _process(delta: float) -> void:
	# coin management
	advance_coin_logic();

	# timer management
	time_remaining -= 1;
	
	$LBL_time.text = "Time remaining: " + str("%0.2f" % float(time_remaining / Engine.get_frames_per_second())) +\
		" seconds";
	if (time_remaining < 1):
		# out of time, the player's dead
		# go back to main menu
		get_parent().notify_game_done(score);
	
	# update timer text
