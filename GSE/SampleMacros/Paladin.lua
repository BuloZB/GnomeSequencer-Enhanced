------------------------------------------------------------------------------------------
-- Dont edit this file.  It is regularily update when GS-E is updated and any
-- changes you have made may be lost.  Instead either use the GS-myMacros
-- plugin from http://www.wowinterface.com/downloads/info24062-GS-EmyMacrosAddinPack.html
-- or see the wiki on creating Macro Plugins
-- https://github.com/TimothyLuke/GnomeSequenced-Enhanced/wiki/Creating-Addon-Packs
------------------------------------------------------------------------------------------

local GNOME, Sequences = ...

------------------
----- Paladin
------------------

-------------------
-- Protection - 66
-------------------
Sequences['SAM_Prot_ST'] = {
author="LNPV",
specID=66,
helpTxt = 'Talents: 2332223',
icon=236264,
KeyPress=[[
/targetenemy [noharm][dead]
]],
"/cast Avenger's Shield",
"/cast Judgment",
"/cast Blessed Hammer",
"/cast Consecration",
"/cast Light of the Protector",
"/cast Shield of the Righteous",
KeyRelease=[[
/cast Avenging Wrath
/startattack
]],
}

Sequences['SAM_Prot_ST2'] = {
author="LNPV",
specID=66,
helpTxt = 'Talents: 2332223',
icon=236264,
KeyPress=[[
/targetenemy [noharm][dead]
]],
"/cast Avenger's Shield",
"/cast Judgment",
"/cast Blessed Hammer",
"/cast Consecration",
"/cast Light of the Protector",
KeyRelease=[[
/cast !Avenging Wrath
/startattack
]],
}

Sequences['SAM_Prot_AOE'] = {
author="LNPV",
specID=66,
helpTxt = 'Talents: 3332123',
icon=236264,
KeyPress=[[
/targetenemy [noharm][dead]
]],
"/cast Avenger's Shield",
"/cast Judgment",
"/xast Blessed Hammer",
"/cast Hammer of the Righteous",
"/cast Consecration",
"/cast Light of the Protector",
"/cast Shield of the Righteous",
"/cast Blinding Light",
KeyRelease=[[
/cast Avenging Wrath
/cast Eye of Tyr
/startattack
]],
}

Sequences['SAM_Palla_Sera'] = {
author="LNPV",
specID=66,
helpTxt = 'Talents: 2232222',
icon=236264,
KeyPress=[[
/targetenemy [noharm][dead]
]],
"/cast Avenger's Shield",
"/cast Judgment",
"/cast Blessed Hammer",
"/cast Consecration",
"/cast Light of the Protector",
"/cast Shield of the Righteous",
"/cast Blinding Light",
KeyRelease=[[
/cast Avenging Wrath
/cast Bastion of Light
/cast Seraphim
/cast Eye of Tyr
/startattack
]],
}

Sequences['SAM_Tank_Heal'] = {
author="LNPV",
specID=66,
helpTxt = 'Talents: 2332121',
icon=236264,
lang="enUS",
KeyPress=[[
/targetenemy [noharm][dead]
]],
"/cast Avenger's Shield",
"/cast Blessed Hammer",
"/cast Judgment",
"/cast Consecration",
"/cast Hand of the Protector",
"/cast Shield of the Righteous",
"/cast Blinding Light",
KeyRelease=[[
/cast Avenging Wrath
/cast Eye of Tyr
]],
}


-------------------
-- Retribution - 70
-------------------

Sequences['SAM_Ret'] = {
author="TimothyLuke",
specID=70,
helpTxt = "Talents: 1132212",
StepFunction = "Priority",
icon='INV_MISC_QUESTIONMARK',
lang="enUS",
KeyPress=[[
/targetenemy [noharm][dead]
/cast Avenging Wrath
/cast Shield of Vengeance
]],
"/cast [talent:5/1] Justicar's Vengeance; [talent:5/2]Eye for an Eye",
"/cast Templar's Verdict",
"/cast Judgment",
"/cast Blade of Justice",
"/cast Wake of Ashes",
"/cast Crusader Strike",
KeyRelease=[[
]],
}

Sequences['SAM_RetAoE'] = {
specID = 70,
author = "TimothyLuke",
helpTxt = "Retribution AoE macro - 1132212.",
StepFunction = "Priority",
icon = "Ability_Paladin_DivineStorm",
KeyPress=[[
/targetenemy [noharm][dead]
/cast Avenging Wrath
/cast Shield of Vengeance
]],
"/cast [talent:5/1] Justicar's Vengeance; [talent:5/2]Eye for an Eye",
"/cast Divine Storm",
"/cast Blade of Justice",
"/cast Judgment",
"/cast Crusader Strike",
"/cast Wake of Ashes",
KeyRelease=[[
/startattack
]],
}

Sequences['SAM_Ret_Raid'] = {
author="TimothyLuke",
specID=70,
helpTxt = "Talents: 1132212 - No Avenging Wrath or Shield of Vengeance",
StepFunction = "Priority",
icon='INV_MISC_QUESTIONMARK',
lang="enUS",
KeyPress=[[
/targetenemy [noharm][dead]
/cast Avenging Wrath
/cast Shield of Vengeance
]],
"/cast Templar's Verdict",
"/cast Judgment",
"/cast Blade of Justice",
"/cast Wake of Ashes",
"/cast Crusader Strike",
KeyRelease=[[
]],
}

Sequences['SAM_RetAoE_Raid'] = {
specID = 70,
author = "TimothyLuke",
helpTxt = "Retribution AoE macro - 1132212. No Avenging Wrath or Shield of Vengeance",
StepFunction = "Priority",
icon = "Ability_Paladin_DivineStorm",
KeyPress=[[
/targetenemy [noharm][dead]
]],
"/cast Divine Storm",
"/cast Blade of Justice",
"/cast Judgment",
"/cast Crusader Strike",
"/cast Wake of Ashes",
KeyRelease=[[
/startattack
]],
}


-------------------
-- Holy - 65
-------------------

Sequences['SAM_HolyDeeps'] = {
specID = 65,
author = "TimothyLuke",
helpTxt = "Holy DPS levelling macro - 3131123.",
icon = "Ability_Paladin_InfusionofLight",
KeyPress = [[
/targetenemy [noharm][dead]
]],
'/cast Judgment',
'/cast Crusader Strike',
'/cast Consecration',
'/cast [combat]!Avenging Wrath',
'/cast Blinding Light',
'/cast Holy Shock',
'/cast Divine Protection',
}
