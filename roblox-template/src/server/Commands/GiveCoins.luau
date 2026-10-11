return {
	Name = "givecoins",
	Aliases = { "coins" },
	Description = "Gives a player coins.",
	Group = "Admin",
	Args = {
		{ Type = "player", Name = "player", Description = "Who gets them" },
		{ Type = "integer", Name = "amount", Description = "How many" },
	},
}
