if (recoil_amount > 0.01) {
	recoil_amount = recoil_amount * 0.85
} else {
	recoil_amount = 0
}

enemy_step(self)