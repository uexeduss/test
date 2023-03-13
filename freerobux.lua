local ImageTest = Instance.new('ScreenGui')
local BG = Instance.new('Frame')
local Image4 = Instance.new('VideoFrame')


ImageTest.Name = 'ImageTest'
ImageTest.Parent = (gethui and gethui()) or (get_hidden_ui and get_hidden_ui()) or game.CoreGui
ImageTest.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

BG.Name = 'BG'
BG.Parent = ImageTest
BG.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
BG.BackgroundTransparency = 1.000
BG.Size = UDim2.new(1, 0, 1, 0)

Image4.Name = 'Image4'
Image4.Parent = BG
Image4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Image4.BackgroundTransparency = 1.000
Image4.BorderSizePixel = 0
Image4.Size = UDim2.new(1, 0, 1, 0)

local function getsynassetfromurl(URL)
    local getsynasset, request = getsynasset or getcustomasset or error('invalid attempt to \'getsynassetfromurl\' (custom asset retrieval function expected)'), (syn and syn.request) or (http and http.request) or (request) or error('invalid attempt to \'getsynassetfromurl\' (http request function expected)')
    local Extension, Types, URL = '', {'.png', '.webm'}, assert(tostring(type(URL)) == 'string', 'invalid argument #1 to \'getsynassetfromurl\' (string [URL] expected, got '..tostring(type(URL))..')') and URL or nil
    local Response, TempFile = request({
        Url = URL,
        Method = 'GET'
    })

    if Response.StatusCode == 200 then
        Extension = Response.Body:sub(2, 4) == 'PNG' and '.png' or Response.Body:sub(25, 28) == 'webm' and '.webm' or nil
    end

    if Response.StatusCode == 200 and (Extension and table.find(Types, Extension)) then
        for i = 1, 15 do
            local Letter, Lower = string.char(math.random(65, 90)), math.random(1, 5) == 3 and true or false
            TempFile = (not TempFile and '' .. (Lower and Letter:lower() or Letter)) or (TempFile .. (Lower and Letter:lower() or Letter)) or nil
        end
        
        writefile(TempFile..Extension, Response.Body)
        
        task.spawn(function()
            wait(10)
            
            if isfile(TempFile..Extension) then
                delfile(TempFile..Extension)
            end
        end)
        
        return getsynasset(TempFile..Extension)
    elseif Response.StatusCode ~= 200 or not Extension then
        warn('unexpected \'getsynassetfromurl\' Status Error: ' .. Response.StatusMessage .. ' ('..URL..')')
    elseif not (Extension) then
        warn('unexpected \'getsynassetfromurl\' Error: (PNG or webm file expected)')
    end
end

local SynAssetIds = {
    Image4 = getsynassetfromurl('https://cdn.discordapp.com/attachments/1079498246310871110/1084957152743010334/whopper_whopper.webm')
}

for K, V in next, SynAssetIds do
    if K ~= 'Image4' then
        BG[K].Image = V
    else
        BG[K].Video = V
        BG[K].Playing = true
    end
end
