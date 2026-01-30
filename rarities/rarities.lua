
--[[ NOTE: These weight values must be adjusted to the ratio of
    modded bamlatro jokers to vanilla jokers. Update "num_bam_jokers"!
]]--

-- TODO: calculate these programatically
--[[local num_bam_jokers = 10.0
local num_van_jokers = 145.0
local bam_ratio = num_bam_jokers/num_van_jokers]]--

--[[SMODS.Rarity {
    key = "bamboozler",
    loc_txt = {
        name = "bamboozler"
    },
    pools = {
        ["j_bam_2mas"] = {weight = 2000},
    },
    default_weight = 0.7, --* bam_ratio,
    badge_colour = HEX('009dff'),
    get_weight = function(self, weight, object_type)
        return weight --* self.config.extra.bonus
    end,
}]]--

--[[SMODS.Rarity {
    key = "BamUncommon",
    loc_txt = {
        name = "BUncommon"
    },
    config = {
        extra = {
            bonus = 1
        }
    },
    default_weight = 0.25, --* bam_ratio,
    badge_colour = HEX("4BC292"),
    get_weight = function(self, weight, object_type)
        return get_weight --* self.config.extra.bonus
    end,
}

SMODS.Rarity {
    key = "BamRare",
    loc_txt = {
        name = "BRare"
    },
    config = {
        extra = {
            bonus = 1
        }
    },
    default_weight = 0.05, --* bam_ratio,
    badge_colour = HEX('fe5f55'),
    get_weight = function(self, weight, object_type)
        return get_weight --* self.config.extra.bonus
    end,
}

SMODS.Rarity {
    key = "BamLegendary",
    loc_txt = {
        name = "BLegendary"
    },
    config = {
        extra = {
            bonus = 1
        }
    },
    default_weight = 0,
    badge_colour = HEX("b26cbb"),
    get_weight = function(self, weight, object_type)
        return get_weight --* self.config.extra.bonus
    end,
}]]--