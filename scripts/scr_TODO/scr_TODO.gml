/*


TODO:
 - Recolor sprites so that the Body portion isn't pure white
   - Let's try making it additive drawing (color portion is BLACK, ouline is WHITE) 
     and then draw a second sprite underneath that replaces all non-white rgb with selected color 
	 (else, it doesn't draw it at all)
	 so bottom sprite draws just the custom color at ~40% alpha, then top sprite is ADDITIVTE WHITE OUTLINE
 - Enemy3 has a bug that is preventing it from being solved (happens randomly?)
 - Ultimate interface update
 - Ultimate strike particle effect update
 - Heal ultimate
   - functionality,
   - add more flare (particle effect) to the current wave pattern.
 - Ultimate availability HUD
 - Main Menu screen
   - Skip to wave option
   - High scores?
- Transition to the game start (animate zooming out and the player moving to center_
   - Might put Menu into the actual game room (spawns Hud and GameController, etc, when game starts)

*/
