-- game-wide settings. anything you'd want to tweak without hunting through code goes here
return {
	-- user ids that can always use the F2 admin console
	Admins = {} :: { number },
	-- in a group game, this group rank and up are admins
	AdminRank = 254,

	-- UI is designed at this size and scaled to fit every screen
	DesignSize = Vector2.new(1920, 1080),
}
