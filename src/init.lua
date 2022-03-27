local HttpService = game:GetService("HttpService")
local formdata = require(script.formdata)

local Neocities = {}
Neocities.__index = Neocities

function Neocities.new(ApiKey: string)
    local nc = {}
    setmetatable(nc, Neocities)
    nc.ApiKey = ApiKey
    
    return nc
end

function Neocities:Request(url, method, headers, body)
    headers = headers or {}
    
    if self.ApiKey then
        headers.Authorization = "Bearer "..self.ApiKey
    end
    local response = HttpService:RequestAsync({
        Url = "https://neocities.org"..url,
        Method = method or "GET",
        Headers = headers,
        Body = body
    })
    local response_json = HttpService:JSONDecode(response.Body)
    
    assert(response_json.result == "success", response_json.message)

    return response_json
end

function Neocities:GetSiteInfo(siteName)
    local url = "/api/info"
    if siteName then
        url = url.. "?sitename="..HttpService:UrlEncode(siteName)
    end
    return self:Request(url).info
end

function Neocities:ListFiles(path)
    local url = "/api/list"
    if path then
        url = url.. "?path="..HttpService:UrlEncode(path)
    end
    return self:Request(url).files
end

function Neocities:GetFileContent(filePath: string, siteName)
    return HttpService:GetAsync("https://"..(siteName or self:GetSiteInfo().sitename)..".neocities.org/"..filePath)
end

function Neocities:UploadFiles(files)
    local form = formdata.FormData.new()
    for path, content in pairs(files) do
        form:AddField(path, formdata.File.new(path, content))
    end
    return self:Request("/api/upload", "POST", {
        ["Content-Type"] = form.content_type
    }, form:build())
end

function Neocities:DeleteFiles(...)
    return self:Request("/api/delete", "POST", _, "filenames[]="..table.concat({...}, ","))
end


return Neocities