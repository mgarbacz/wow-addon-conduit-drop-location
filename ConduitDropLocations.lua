local name,addon=...;

function GetConduitLevel(conduitLevelText)
    local startPos, endPos, level = string.find(conduitLevelText, "(%d+)")
    return tonumber(level);
end

function IsConduit(conduitTypeText)
    if conduitTypeText then
        return string.find(conduitTypeText, "Conduit");
    end
    return false;
end

function GetConduitType(conduitTypeText)
	if conduitTypeText then
		local startPos, endPos, type = string.find(conduitTypeText, "(%w+)%s")
		return type;
	end
    return nil;
end

function ConduitRankFromLevel(level)
    if level == 145 then
        return 1;
    elseif level == 158 then
        return 2;
    elseif level == 171 then
        return 3;
    elseif level == 184 then
        return 4;
    elseif level == 200 then
        return 5;
    elseif level == 213 then
        return 6;
    elseif level == 226 then
        return 7;
    elseif level == 239 then
        return 9;
    elseif level == 252 then
        return 9;
    elseif level == 265 then
        return 10;
    elseif level == 278 then
        return 11;
    elseif level == 291 then
        return 12;
    elseif level == 304 then
        return 13;
    elseif level == 317 then
        return 14;
    elseif level == 317 then
        return 15;
    end
end

function GetSourceFromNameAndIlevel(name, ilvl)
    if addon.CONDUIT_DB then
        if addon.CONDUIT_DB[name] then
            if addon.CONDUIT_DB[name][tostring(ilvl)] then
                return addon.CONDUIT_DB[name][tostring(ilvl)];
            end
        end
    end
end

function appendConduitDropLocation(tooltip)

    if _G["GameTooltipTextLeft2"] and IsConduit(_G["GameTooltipTextLeft2"]:GetText()) then

        local conduitName = _G["GameTooltipTextLeft1"] and _G["GameTooltipTextLeft1"]:GetText()
        local conduitType = _G["GameTooltipTextLeft2"] and GetConduitType(_G["GameTooltipTextLeft2"]:GetText())
        local conduitLevel = _G["GameTooltipTextLeft3"] and GetConduitLevel(_G["GameTooltipTextLeft3"]:GetText())

        local relevantConduitLevels = {145, 158, 171, 184, 200, 213, 226, 239, 252};
        local filteredConduitLevels = {};
        
        for index, level in ipairs(relevantConduitLevels) do
            if level > conduitLevel then
                table.insert(filteredConduitLevels, level);
            end
        end

        if #filteredConduitLevels == 0 then
            return;
        end

        tooltip:AddLine("\n");

        local multipleSources = false;

        for index, level in ipairs(filteredConduitLevels) do
            local rank = ConduitRankFromLevel(level);
            local source = GetSourceFromNameAndIlevel(conduitName, level);

            if source ~= nil and source ~= "--" then
                tooltip:AddLine("Rank " .. rank .. " (ilvl: " .. level .. "): " .. source);
            end

            local altSource = GetSourceFromNameAndIlevel("_" .. conduitName, level);
            if altSource ~= nil and altSource ~= "--" then
                tooltip:AddLine("Rank " .. rank .. " (ilvl: " .. level .. "): " .. altSource);
                multipleSources = true;
            end

        end

        if multipleSources then
            tooltip:AddLine("\nThis conduit is available from multiple sources");
        end

    end

end

GameTooltip:HookScript("OnTooltipSetItem", appendConduitDropLocation)
GameTooltip:HookScript("OnTooltipSetSpell", appendConduitDropLocation)
