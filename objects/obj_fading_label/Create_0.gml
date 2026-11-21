/// @description Quickly fade out a label
// Left behind by a power item when it's hit, so its label fades out instead of vanishing with it.
// Expects: text, color. Optional: follow (an instance to track while it exists)
if (!variable_instance_exists(id, "follow")) {
	follow = noone
}
elapsed = 0 // seconds
duration = 0.15 // seconds to fully fade
alpha = 1
