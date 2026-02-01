
SMODS.Edition {
    key = 'bamboozled',
    shader = 'booster',
    prefix_config = {
        -- This allows using the vanilla shader
        -- Not needed when using your own
        shader = false
    },
    in_shop = false,
    apply_to_float = false,
    badge_colour = HEX('7932C2'),
    disable_shadow = false,
    disable_base_shader = false,
    loc_txt = {
        name = 'Bamboozled',
        label = 'Bamboozled (Edition)',
        text = {
            [1] = 'Compatible with {X:legendary,C:white}Bamlatro{} Jokers only.',
            [2] = 'Supercharges Joker by {C:attention}raising/lowering{}',
            [3] = '{C:attention}constants{} in Joker description.',
            [4] = '{C:inactive}(\"6 cards\"->\"4 cards\", etc){}'
        }
    },
    unlocked = true,
    discovered = true,
    no_collection = false,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    
    on_apply = function(card)
        if string.find(card.config.center.key, "j_bam") then --is bamlatro joker
            card.ability.extra.bam_bonus = card.ability.extra.bam_bonus + 1

        end
    end,

    on_remove = function(card)
        if string.find(card.config.center.key, "j_bam") then --is bamlatro joker
            card.ability.extra.bam_bonus = card.ability.extra.bam_bonus - 1

        end
    end,
}