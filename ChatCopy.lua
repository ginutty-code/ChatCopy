-- Chat Copy
-- Allows copying all chat content from the chat window

local addonName, addon = ...

-- Create a frame to handle slash commands
local ChatCopyFrame = CreateFrame("Frame")
ChatCopyFrame:RegisterEvent("ADDON_LOADED")
ChatCopyFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "ChatCopy" then
        -- Register slash command
        SLASH_CHATCOPY1 = "/chatcopy"
        SLASH_CHATCOPY2 = "/cc"
        SlashCmdList["CHATCOPY"] = function()
            OpenChatCopyWindow()
        end

        -- Create the copy window
        CreateChatCopyWindow()
        
        -- Add chat command help
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00Chat Copy Addon loaded. Use /chatcopy or /cc to copy all chat content.|r")
    end
end)

-- Function to add backdrop template compatibility
local function addBackdrop(string)
    if (BackdropTemplateMixin) then
        if (string) then
            return "BackdropTemplate," .. string;
        else
            return "BackdropTemplate";
        end
    else
        return string;
    end
end

-- Global variables for the copy window
local copyWindow = nil

-- Create the chat copy window
function CreateChatCopyWindow()
    -- If window already exists, return
    if copyWindow then
        return
    end
    
    -- Create the main copy window
    copyWindow = CreateFrame("Frame", "ChatCopyWindow", nil, addBackdrop("BasicFrameTemplateWithInset"))
    copyWindow:SetSize(500, 400)
    copyWindow:SetPoint("CENTER", UIParent, 0, 0)
    copyWindow:SetFrameStrata("HIGH")
    copyWindow:SetFrameLevel(100)
    copyWindow:EnableMouse(true)
    copyWindow:SetMovable(true)
    copyWindow:SetResizable(true)
    copyWindow:SetResizeBounds(300, 200, 1200, 800)
    copyWindow:RegisterForDrag("LeftButton")
    copyWindow:SetScript("OnDragStart", function(self) self:StartMoving() end)
    copyWindow:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    
    -- Add to UI special frames for closing with Escape
    tinsert(UISpecialFrames, "ChatCopyWindow")
    
    -- Title
    local title = copyWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", copyWindow, "TOP", 0, -5)
    title:SetText("Chat Copy - Select and Copy Content")
    
    -- Close button
    local closeButton = CreateFrame("Button", nil, copyWindow, "UIPanelButtonTemplate")
    closeButton:SetSize(80, 25)
    closeButton:SetPoint("BOTTOM", copyWindow, "BOTTOM", 0, 10)
    closeButton:SetText("Close")
    closeButton:SetScript("OnClick", function()
        copyWindow:Hide()
    end)

    -- Resize button
    local resizeButton = CreateFrame("Button", nil, copyWindow)
    resizeButton:SetSize(16, 16)
    resizeButton:SetPoint("BOTTOMRIGHT", copyWindow, "BOTTOMRIGHT", -5, 5)
    resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    resizeButton:SetScript("OnMouseDown", function(self) copyWindow:StartSizing() end)
    resizeButton:SetScript("OnMouseUp", function(self) copyWindow:StopMovingOrSizing() end)
    
    -- Scroll frame for the edit box
    local scrollFrame = CreateFrame("ScrollFrame", "ChatCopyScrollFrame", copyWindow, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOP", copyWindow, "TOP", 0, -35)
    scrollFrame:SetPoint("BOTTOM", copyWindow, "BOTTOM", 0, 45)
    scrollFrame:SetPoint("LEFT", copyWindow, "LEFT", 25, 0)
    scrollFrame:SetPoint("RIGHT", copyWindow, "RIGHT", -25, 0)

    -- Edit box to display chat content
    local editBox = CreateFrame("EditBox", "ChatCopyEditBox", scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetAutoFocus(false)
    editBox:SetFontObject("ChatFontNormal")
    editBox:SetWidth(scrollFrame:GetWidth())
    editBox:SetMaxLetters(0)
    editBox:EnableMouse(true)
    editBox:SetScript("OnCursorChanged", function(self, x, y, w, h)
        local scrollFrame = self:GetParent()
        local scrollY = scrollFrame:GetVerticalScroll()
        local frameHeight = scrollFrame:GetHeight()
        local cursorTop = -y
        local cursorBottom = cursorTop + h
        if cursorBottom > scrollY + frameHeight then
            scrollFrame:SetVerticalScroll(cursorBottom - frameHeight)
        elseif cursorTop < scrollY then
            scrollFrame:SetVerticalScroll(cursorTop)
        end
    end)
    editBox:SetScript("OnKeyDown", function(self, key)
        if key == "ESCAPE" then
            copyWindow:Hide()
        end
    end)
    editBox:SetScript("OnEditFocusGained", function(self)
        self:HighlightText()
    end)

    -- Set the scroll frame child
    scrollFrame:SetScrollChild(editBox)

    -- Set resize script
    copyWindow:SetScript("OnSizeChanged", function(self, width, height)
        editBox:SetWidth(scrollFrame:GetWidth())
    end)

    -- Store references
    copyWindow.scrollFrame = scrollFrame
    copyWindow.editBox = editBox
    
    -- Hide initially
    copyWindow:Hide()
end

-- Function to clean up chat content (remove problematic escape sequences)
function CleanChatContent(message)
    if not message then
        return ""
    end
    
    -- Remove textures |T...|t
    message = string.gsub(message, "|T.-|t", "")
    
    -- Fix time format escapes |4...:...;
    local timeFormats = {
        {"year", "years"},
        {"day", "days"}, 
        {"hour", "hours"},
        {"minute", "minutes"},
        {"second", "seconds"}
    }
    
    for _, format in ipairs(timeFormats) do
        local singular, plural = format[1], format[2]
        local pattern = "(%d+) |4" .. singular .. ":" .. plural .. ";"
        if message:match(pattern) then
            local number = message:match(pattern)
            if number then
                local num = tonumber(number)
                local replacement
                if num == 0 or num == 1 then
                    replacement = number .. " " .. singular
                else
                    replacement = number .. " " .. plural
                end
                message = message:gsub(pattern, replacement)
            end
        end
    end
    
    return message
end

-- Function to calculate EditBox height based on content
local function CalculateEditBoxHeight(chatContent, editBox)
    -- Get font height
    local _, fontHeight = editBox:GetFont()
    if not fontHeight then fontHeight = 14 end
    
    -- Count newlines in content
    local lineCount = 1
    for _ in chatContent:gmatch("\n") do
        lineCount = lineCount + 1
    end
    
    -- Calculate height: lines * font height + padding
    local calculatedHeight = lineCount * fontHeight + 20
    
    -- Make sure it's at least as tall as the scroll frame
    local minHeight = editBox:GetParent():GetHeight()
    
    return math.max(calculatedHeight, minHeight)
end

-- Function to open the chat copy window with content
function OpenChatCopyWindow()
    local chatContent = ""
    local chatFrames = {
        ChatFrame1, ChatFrame2, ChatFrame3, ChatFrame4, ChatFrame5,
        ChatFrame6, ChatFrame7, ChatFrame8, ChatFrame9, ChatFrame10
    }

    -- Get content from all chat frames
    for frameIndex, frame in ipairs(chatFrames) do
        if frame and frame:IsVisible() then
            local numMessages = frame:GetNumMessages()
            if numMessages and numMessages > 0 then
                -- Limit to last 500 messages to avoid overwhelming the UI
                local startLine = math.max(1, numMessages - 500)
                
                if frameIndex > 1 and startLine < numMessages then
                    chatContent = chatContent .. "\n--- Chat Frame " .. frameIndex .. " ---\n"
                end
                
                for i = startLine, numMessages do
                    local success, message, r, g, b, id, _, _, messageType = pcall(frame.GetMessageInfo, frame, i)
                    if success and message and message ~= "" then
                        -- Clean up the message
                        message = CleanChatContent(message)

                        -- Add message type prefix if available
                        local prefix = ""
                        if messageType == "SYSTEM" then
                            prefix = "[SYSTEM] "
                        elseif messageType == "CHAT_MSG_SAY" then
                            prefix = "[SAY] "
                        elseif messageType == "CHAT_MSG_YELL" then
                            prefix = "[YELL] "
                        elseif messageType == "CHAT_MSG_PARTY" or messageType == "CHAT_MSG_PARTY_LEADER" then
                            prefix = "[PARTY] "
                        elseif messageType == "CHAT_MSG_RAID" or messageType == "CHAT_MSG_RAID_LEADER" then
                            prefix = "[RAID] "
                        elseif messageType == "CHAT_MSG_GUILD" then
                            prefix = "[GUILD] "
                        elseif messageType == "CHAT_MSG_WHISPER" or messageType == "CHAT_MSG_WHISPER_INFORM" then
                            prefix = "[WHISPER] "
                        elseif messageType == "CHAT_MSG_CHANNEL" then
                            prefix = "[CHANNEL] "
                        end

                        chatContent = chatContent .. prefix .. message .. "\n"
                    end
                end
            end
        end
    end

    if chatContent ~= "" and copyWindow then
        local editBox = copyWindow.editBox
        
        -- Calculate and set the proper height for the EditBox
        local properHeight = CalculateEditBoxHeight(chatContent, editBox)
        editBox:SetHeight(properHeight)
        
        -- Set the content in the edit box
        editBox:SetText(chatContent)

        -- Show the window
        copyWindow:Show()

        -- Reset scroll to top
        copyWindow.scrollFrame:SetVerticalScroll(0)

        -- Set focus to the edit box and highlight all text
        editBox:SetFocus()
        editBox:HighlightText()

        DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00Chat content loaded! Select all (Ctrl+A) and copy with Ctrl+C.|r")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000No chat content found to copy.|r")
    end
end
