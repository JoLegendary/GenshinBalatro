SMODS.Atlas{
    key = 'Furina',
    path = "furina_balatro.png",
    px = 71,
    py = 95
}
SMODS.Atlas{
    key = 'OusiaFurina',
    path = "ousia_furina_balatro.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = 'furinatr',
    loc_txt = {
        name = 'Furina',
        text = {
            "Copies ability of",
            "{C:attention}2 Jokers{} to the right",
        }
    },
    atlas = 'Furina',
    pos = {x=0, y=0},
    blueprint_compat = true,
    rarity = 3,
    cost = 10,
    unlocked = true,
    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local other_joker1
            local other_joker2
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then other_joker1 = G.jokers.cards[i + 1] end
                if G.jokers.cards[i] == card then other_joker2 = G.jokers.cards[i + 2] end
            end
            if not other_joker2 then other_joker2 = other_joker1 end
            local compatible1 = other_joker1 and other_joker1 ~= card and other_joker1.config.center.blueprint_compat
            local compatible2 = other_joker2 and other_joker2 ~= card and other_joker2.config.center.blueprint_compat
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible1 and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible1 and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        },
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible2 and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible2 and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { main_end = main_end }
        end
    end,
    calculate = function(self, card, context)
        local other_joker1 = nil
        local other_joker2 = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then other_joker1 = G.jokers.cards[i + 1] end
            if G.jokers.cards[i] == card then other_joker2 = G.jokers.cards[i + 2] end
        end
        if not other_joker2 then other_joker2 = other_joker1 end
        local compatible1 = other_joker1 and other_joker1 ~= card and other_joker1.config.center.blueprint_compat
        local compatible2 = other_joker2 and other_joker2 ~= card and other_joker2.config.center.blueprint_compat
        if not compatible1 and compatible2 then
            other_joker1 = other_joker2
        elseif not compatible2 and compatible1 then
            other_joker2 = other_joker1
        end
        local val1 = SMODS.blueprint_effect(card, other_joker1, context) or {}
        local val2 = SMODS.blueprint_effect(card, other_joker2, context) or {}
        return SMODS.merge_effects({val1, val2})
    end,
    check_for_unlock = function(self, args)
        return args.type == 'win_custom'
    end
}
SMODS.Joker{
    key = 'ousiafurinatr',
    loc_txt = {
        name = 'Ousia Furina',
        text = {
            "{C:blue}#1#{} hand each round",
            "Every remaining hand at the end",
            "of the round adds {X:mult,C:white} X#2# {} Mult",
            "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)",
        }
    },
    atlas = 'OusiaFurina',
    pos = {x=0, y=0},
    blueprint_compat = true,
    rarity = 3,
    cost = 10,
    unlocked = true,
    config = { extra = { h_plays = -1, xmult_gain = 0.25, xmult = 1 } },    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.h_plays, card.ability.extra.xmult_gain, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if G.GAME.current_round.hands_left > 0 then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain * G.GAME.current_round.hands_left
            end
            return { message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } } }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.h_plays
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.h_plays
    end,
}
SMODS.Joker{
    key = 'fischltr',
    loc_txt = {
        name = 'Fischl',
        text = {
            "{C:mult}+#1#{} mult everytime",
            "a scoring card",
            "gets retriggered",
        }
    },
    atlas = 'OusiaFurina',
    pos = {x=0, y=0},
    blueprint_compat = true,
    rarity = 3,
    cost = 10,
    unlocked = true,
    config = { extra = { score_buffer = 1, card_buffer = 1, mult = 20 } },
    loc_vars = function(self,info_queue,card)
        return {vars = { card.ability.extra.mult }}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            for i = 1, #context.scoring_hand do
                if context.other_card == context.scoring_hand[card.ability.extra.card_buffer] then 
                    break 
                end
                if context.scoring_hand[i] == context.other_card then 
                    card.ability.extra.card_buffer = i
                    card.ability.extra.score_buffer = 1
                    break 
                end
            end
            if card.ability.extra.score_buffer > 0 and not context.blueprint then
                card.ability.extra.score_buffer = card.ability.extra.score_buffer - 1
            else
                return {
                    mult = card.ability.extra.mult
                }
            end
        elseif context.joker_main then
            card.ability.extra.score_buffer = 1
        end
    end,
}