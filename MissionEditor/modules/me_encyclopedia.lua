local base = _G

module('me_encyclopedia')

local require = base.require
local pairs = base.pairs
local ipairs = base.ipairs
local string = base.string
local table = base.table

local Window = 			require('Window')
local U = 				require('me_utilities')
local i18n = 			require('i18n')
local lfs = 			require('lfs') 
local MainMenu = 		require('MainMenu')
local DemoSceneWidget 	= require('DemoSceneWidget')
local loadLiveries		= require('loadLiveries')
local DialogLoader		= require('DialogLoader')
local Gui               = require('dxgui')
local Analytics			= require("Analytics")  
local Static			= require("Static")  

local demosceneEnvironment  = require('demosceneEnvironment')
local ED_demosceneAPI 		= require('ED_demosceneAPI')

i18n.setup(_M)

local editBoxDetails
local buttonPrev
local buttonNext

local DSWidget

local cdata = {
		Encyclopedia = _('ENCYCLOPEDIA'),
		Plane = _('AIRCRAFTS'),
		Helicopter = _('HELICOPTERS'),
		Ship = _('SHIPS'),
		Tech = _('VEHICLES'),
		Weapon = _('WEAPONS'),
        SAM = _('AIR DEFENSE'),
		previous = _('previous'),
		next = _('next'),
		cancel = _('CLOSE'),
		Personnel = _('PERSONNEL ASSETS'),
		Miscellanious = _('MISCELLANIOUS'),
	}

function loadData()
    Encyclopedia = loadArticles()

	local container = window.containerMain.pButtons

    buttons = {
        { 
            name = 'radiobuttonAircraft',
            button = container.radiobuttonAircrafts,
            category = 'Plane',
            displayName = cdata.Plane
            },
        { 
            name = 'radiobuttonHelicopters',
            button = container.radiobuttonHelicopters,
            category = 'Helicopter',
            displayName = cdata.Helicopter
            },
        { 
            name = 'radiobuttonShips',
            button = container.radiobuttonShips,
            category = 'Ship',
            displayName = cdata.Ship
            },
        { 
            name = 'radiobuttonTech',
            button = container.radiobuttonTech,
            category = 'Tech',
            displayName = cdata.Tech
            },
        { 
            name = 'radiobuttonWeapon',
            button = container.radiobuttonWeapon,
            category = 'Weapon',
            displayName = cdata.Weapon
            },
        { 
            name = 'radiobuttonSAM',
            button = container.radiobuttonSAM,
            category = 'SAM',
            displayName = cdata.SAM
            },
		{ 
            name = 'radiobuttonPersonnel',
            button = container.radiobuttonPersonnel,
            category = 'Personnel',
            displayName = cdata.Personnel
            },
		{ 
            name = 'radiobuttonMiscellanious',
            button = container.radiobuttonMiscellanious,
            category = 'Miscellanious',
            displayName = cdata.Miscellanious
            },
    }
end

local function create_()
    window = DialogLoader.spawnDialogFromFile('MissionEditor/modules/dialogs/me_encyclopedia.dlg', cdata)
        
    containerMain = window.containerMain
    pLeft = containerMain.pLeft
	
    editBoxDetails = pLeft.editBoxDetails
    buttonPrev = pLeft.buttonPrev
    buttonNext = pLeft.buttonNext
    pTop = containerMain.pTop
    pDown = containerMain.pDown
    staticPicture = containerMain.staticPicture
    staticPictureSkin = staticPicture:getSkin()
    picture = staticPictureSkin.skinData.states.released[1].picture
    currentTabName = pLeft.currentTabName
    pButtons = containerMain.pButtons

    loadData()    
   
    buttons[1].button:setState(true)
    comboboxObject = containerMain.pLeft.comboboxObject
    fillObjects(buttons[1])
	
    resize()
    
	initDemoScene()
   
    setupCallbacks()
    showDetails()
end

function resize()
    w, h = Gui.GetWindowSize()
    
    window:setBounds(0, 0, w, h)
    containerMain:setBounds(0, 0, w, h)
    
    local wP, hP = pLeft:getSize()
    
    pButtons:setPosition((w-767-wP)/2, 78)
    
    pTop:setBounds(0, 0, w, 50)
    pTop.btnClose:setPosition(w-32, 18)
    
    pDown:setBounds(0, h-50, w, 50)
    
    staticPicture:setBounds(0, 50, w, h-100)    
    pLeft:setBounds(w-wP, 50, wP, h-100)
    
    editBoxDetails:setSize(wP-6, h-213)
end

---------------------------------------------------------------	
function initDemoScene()

	if  guiSceneVR_Encyclopedia then
		DSWidget 		  = Static.new()
		DSWidget.getScene = function (self)
			return demosceneEnvironment.getInterface(guiSceneVR_Encyclopedia)
		end
		DSWidget.loadScript = function (self,filename)
			return ED_demosceneAPI.loadScript(guiSceneVR_Encyclopedia, filename)
		end
	else
		DSWidget = DemoSceneWidget.new()
	end

	local x, y, w, h = staticPicture:getBounds()
	DSWidget:setBounds(x, y, w, h)
	containerMain:insertWidget(DSWidget,0)
	DSWidget:loadScript('Scripts/DemoScenes/encyclopediaScene.lua')
	DSWidget.aspect = w / h --аспект для вычисления вертикального fov
	local sceneAPI = DSWidget:getScene()
	sceneAPI:setEnvironmentMap("Bazar/EffectViewer/envcubes/normandy01.dds")
		
	DSWidget.updateClipDistances = function()
		local dist = base.enc.cameraDistance*base.math.exp(base.enc.cameraDistMult)
		base.enc.scene.cam:setNearClip(base.math.max(dist-DSWidget.modelRadius*2.0, 0.1))
		base.enc.scene.cam:setFarClip(base.math.max(dist+DSWidget.modelRadius*2.0, 1000.0))
	end
    
	DSWidget:addMouseDownCallback(function(self, x, y, button)
		DSWidget.bEncMouseDown = true
		DSWidget.mouseX = x
		DSWidget.mouseY = y
		DSWidget.cameraAngH = base.enc.cameraAngH
		DSWidget.cameraAngV = base.enc.cameraAngV
		
		local sceneAPI = DSWidget:getScene()
		sceneAPI:setUpdateFunc('enc.encyclopediaSceneUpdateNoRotate')
		
		self:captureMouse()
	end)
	
	DSWidget:addMouseUpCallback(function(self, x, y, button)
		DSWidget.bEncMouseDown = false	
		self:releaseMouse()
	end)
	
   	DSWidget:addMouseMoveCallback(function(self, x, y)
		if DSWidget.bEncMouseDown == true then
			base.enc.cameraAngH = DSWidget.cameraAngH + (DSWidget.mouseX - x) * base.enc.mouseSensitivity
			base.enc.cameraAngV = DSWidget.cameraAngV - (DSWidget.mouseY - y) * base.enc.mouseSensitivity
			
			if base.enc.cameraAngV > base.math.pi * 0.48 then 
				base.enc.cameraAngV = base.math.pi * 0.48
			elseif base.enc.cameraAngV < -base.math.pi * 0.48 then 
				base.enc.cameraAngV = -base.math.pi * 0.48 
			end
		end
	end)
	
	DSWidget:addMouseWheelCallback(function(self, x, y, clicks)
		base.enc.cameraDistMult = base.enc.cameraDistMult - clicks*base.enc.wheelSensitivity
		local multMax = 2.3 - base.math.mod(2.3, base.enc.wheelSensitivity)
		if base.enc.cameraDistMult>multMax then base.enc.cameraDistMult = multMax end
		DSWidget.updateClipDistances()
		
		return true
	end)
end

function uninitialize()
	if DSWidget ~= nil then
        containerMain:removeWidget(DSWidget)
        DSWidget:destroy()
        DSWidget = nil
	end
end

function isVisible()
    if window then
        return window:isVisible()
    else
        return false
    end
end

function setupCallbacks()
    pDown.btnCancel.onChange = onButtonClose
    pTop.btnClose.onChange = onButtonClose
    for i = 1, #buttons do
        buttons[i].button.onChange = onButtonCategoryChange
    end
    comboboxObject.onChange = onChangeObject
    buttonPrev.onChange = onButtonPrev
    buttonNext.onChange = onButtonNext
	
    window:addHotKeyCallback('escape'	, onButtonClose)
    window:addHotKeyCallback('left'		, onButtonPrev)
    window:addHotKeyCallback('right'	, onButtonNext)
	window:addHotKeyCallback('home'		, onLiveryChange)
end

function onLiveryChange(self)
	if not DSWidget.modelObj or
	   not DSWidget.modelObj.valid or
	   not DSWidget.article then
		return
	end
	local liveries 		 = DSWidget.article.liveries or {}
	
	local liveries_count = #liveries

	if not DSWidget.article.lastLivery or 
	       DSWidget.article.lastLivery > liveries_count - 1 then
		   DSWidget.article.lastLivery  = 1
	else
		   DSWidget.article.lastLivery = DSWidget.article.lastLivery + 1
	end
	
	DSWidget.modelObj:setAircraftBoardNumber(base.string.format("%02d",10 + DSWidget.article.lastLivery))
		
	if liveries_count < 1 then
		return
	end

	local livery = liveries[DSWidget.article.lastLivery].itemId

	DSWidget.modelObj:setLivery(livery,DSWidget.article.liveryEntryPoint)
end

function onButtonNext(self)
	local selectedItem = comboboxObject:getSelectedItem()
	local nextItemIndex = comboboxObject:getItemIndex(selectedItem) + 1
	
	if nextItemIndex < comboboxObject:getItemCount() then
		comboboxObject:onChange(comboboxObject:getItem(nextItemIndex))
	end
end

function onButtonPrev(self)
	local selectedItem = comboboxObject:getSelectedItem()
	local prevItemIndex = comboboxObject:getItemIndex(selectedItem) - 1
	
	if prevItemIndex >= 0 then
		comboboxObject:onChange(comboboxObject:getItem(prevItemIndex))
	end   
end

function onChangeObject(self, item)
    self:setText(item:getText())
    updateDetails(getSelectedObjectParameters())
    updateButtons(item)
end

function onButtonClose()
    show(false)
	
    if not returnToEditor then
        MainMenu.show(true)
    else
		if base.MapWindow.isEmptyME() ~= true then
			base.MapWindow.show(true)
		else
			base.MapWindow.showEmpty(true)
		end	
    end
end

function onButtonCategoryChange(self)
    for k,v in pairs(buttons) do
        if v.button == self then 
            fillObjects(v)
            showDetails()
            return
        end
    end    
end

function fillObjects(button)
    local objects = {}
    local category = button.category
    if Encyclopedia[category] then
        for objectName, data in pairs(Encyclopedia[category]) do
            table.insert(objects, objectName)
        end
    end
    table.sort(objects)
    U.fill_combo_list(comboboxObject, objects)
    
    if objects[1] then
        comboboxObject:setText(objects[1])
    end
    
    updateButtons()
end


-- returns full path to image
function getImagePath(name)
    return 'MissionEditor/data/images/Encyclopedia/' ..  name
end


function updateDetails(category, object, displayName)
    local cat = Encyclopedia[category]
    local article
    
    if cat then
        article = cat[object]
    end

    local text
    
    if not article then
        text = ''
    else
        text = article.line
    end

    editBoxDetails:setText(text)
    currentTabName:setText(displayName)
    
    local filename
    
    if article and article.image then
        filename = article.image
    end
	
	local setStaticPicture = function (file)
	    picture.file = file
        staticPicture:setSkin(staticPictureSkin)
        staticPicture:setVisible(true)
	end

	local sceneAPI = DSWidget:getScene()	
	if DSWidget.modelObj ~= nil and DSWidget.modelObj.obj ~= nil then
		sceneAPI.remove(DSWidget.modelObj)
		DSWidget.modelObj = nil
	end
	
	-- если есть модель - показываем
	if article then
        if (article.model ~= "") then
            staticPicture:setVisible(false)
            base.print("Load model: "..article.model)
            DSWidget.modelObj 			= sceneAPI:addModel(article.model, 0, base.enc.objectHeight, 0)
            DSWidget.modelObjName		= nil
			sceneAPI:setEnable(DSWidget.modelObj.valid)--отключаем рисовалку если модель не загружена
			if	DSWidget.modelObj.valid == true then
				DSWidget.modelObjName		 = article.unit_type 
				if not DSWidget.modelObjName then
					   DSWidget.modelObjName = article.model
				end
				if not DSWidget.modelObjName then
					   DSWidget.modelObjName = object
				end
			    if not article.liveries then
					article.liveryEntryPoint = article.unit_type
					if not article.liveryEntryPoint then
						   article.liveryEntryPoint = DSWidget.modelObjName
					end
					article.liveries	= loadLiveries.loadSchemes(article.liveryEntryPoint)
					if #article.liveries < 1 then
						base.print("no liveries:",article.liveryEntryPoint)
					end
				end

				DSWidget.article			= article
                DSWidget.modelRadius 		= DSWidget.modelObj:getRadius()
				
                local x0,y0,z0,x1,y1,z1 = DSWidget.modelObj:getBBox()
				
				local dx = 0
				local dz = 0
				if category == 'Miscellanious' then
					dx = -(x0+x1)*0.5
					dz = -(z0+z1)*0.5
				end
				local dy = -(y0+y1)*0.5
				
                DSWidget.modelObj.transform:setPosition(dx, base.enc.objectHeight + dy, dz) --выравниваем по центру баундинг бокса
                -- считаем тангенс половины вертиального fov
                -- local vFovTan = base.math.tan(base.math.rad(base.enc.cameraFov*0.5)) / DSWidget.aspect
                -- base.enc.cameraRadius = DSWidget.modelRadius / vFovTan  --base.math.tan(vFov)
                base.enc.cameraDistMult = 0
                base.enc.cameraAngV = base.enc.cameraAngVDefault
                base.enc.cameraDistance = DSWidget.modelRadius / base.math.tan(base.math.rad(base.enc.cameraFov*0.5))

				onLiveryChange()
                if article.model == "MI-8MT_lod0" then
                    DSWidget.modelObj:setArgument(250,1) -- дверь
                    DSWidget.modelObj:setArgument(80,1) -- броня
                end

                DSWidget.updateClipDistances()
                sceneAPI:setUpdateFunc('enc.encyclopediaSceneUpdate')
            else
				setStaticPicture(filename)
            end
        else
            sceneAPI:setEnable(false)
			setStaticPicture(filename)
        end    
	else
		sceneAPI:setEnable(false)
	end	
end

function updateButtons(item)
	item = item or comboboxObject:getSelectedItem()
	
	if item then
		local itemIndex = comboboxObject:getItemIndex(item)
		
		buttonPrev:setEnabled(itemIndex > 0)
		buttonNext:setEnabled(itemIndex < comboboxObject:getItemCount() - 1)
	else
		buttonPrev:setEnabled(false)	
		buttonNext:setEnabled(false)
	end
end

function show(b, fromEdtitor)
    if b then
		guiSceneVR_Encyclopedia = base.switchVRSceneToEncyclopedia()
        returnToEditor = fromEdtitor
        if not window then    
            create_()
        end 
        
        if DSWidget == nil then
            initDemoScene()
        end    

        window:setVisible(true)
        showDetails()
		Analytics.pageview(Analytics.Encyclopedia)
    else
		base.switchVRSceneToMain()
        
        if window then
            window:setVisible(false)
        end
    end
end

function getSelectedObjectParameters()
    local category
    local displayName
    for k,v in pairs(buttons) do
        if v.button:getState() then 
            category = v.category
            displayName = v.displayName
            break
        end
    end    
    local object = comboboxObject:getText()
    return category, object, displayName
end

function showDetails()
    updateDetails(getSelectedObjectParameters())
end


-- returns list of files in directory best suited for current locale
function getBestLocalizedFiles(path)
    local files = { }

    for file in lfs.dir(path) do
        local fullPath = path .. '/' .. file
        if 'file' == lfs.attributes(fullPath).mode then
            local unllzedName, lang, country = i18n.getLocalizationInfo(file)
            local score = i18n.getLocaleScore(lang, country)
            if 0 < score then
                local choice = files[unllzedName]
                if not choice then
                    files[unllzedName] = { name = file, score = score }
                else
                    if choice.score < score then
                        choice.name = file
                        choice.score = score
                    end
                end
            end
        end
    end

    local res = { }
    for _k, v in pairs(files) do
        table.insert(res, path .. '/' .. v.name)
    end

    return res
end

-- remove trailing and leading whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(8programming)
local function trim(s)
  -- from PiL2 20.4
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- load article from text file.
function loadArticle(fileName, pluginPath)
    local f = base.io.open(fileName)

    if not f then
        return nil
    end

    local lineNo = 1
    local article = { line = "" }
	local imageName
	
	local 	stringNormalize = function (str)
		return string.gsub(str,string.char(13), '')-- в конце строки откуда-то берется символ с кодом 13, его надо отрезать
	end
	
    for line in f:lines() do
        if 1 == lineNo then
            article.name = line
        elseif 2 == lineNo then
            article.image 	  	= stringNormalize(line)
			imageName 			= article.image
			if (pluginPath) then
				article.image = pluginPath.."/"..article.image
			else
				article.image = getImagePath(article.image)
			end
		elseif 3 == lineNo then
			article.model 	  = stringNormalize(line)
		elseif 4 == lineNo then
  			article.unit_type = stringNormalize(line)
			trim(article.unit_type)
			if article.unit_type == '' then
			   article.unit_type = nil
			end
		elseif 5 < lineNo then
            article.line = article.line .. line .. '\n'
        end		
        lineNo = lineNo + 1
    end
	
	--если нету модели - берем имя картинки, ибо часто совпадает с названием модели
	if article.model == nil or article.model == "" then 
		base.print("no model")
		local s, e = base.string.find(imageName, '/')
		if s == nil then s=0 end
		local s1, e1 = base.string.find(imageName, '%.', s+1)				
		if s1 == nil then article.model = base.string.sub(imageName, s+1)
		else article.model = base.string.sub(imageName, s+1, s1-1) end
		-- base.print('modelName by imageName: ', article.model)
		-- base.print(base.tostring(s)..'/'..base.tostring(s1))
	end

    f:close()

    return article
end


-- load articles for specified category best matching current locale
function loadCategory(path, a_category, pluginPath)
    local category = a_category or {}

    local files = getBestLocalizedFiles(path)
    for _k, name in pairs(files) do
		if   string.sub(name,-4) == '.txt' then 
			local article = loadArticle(name, pluginPath)
			if (not article) or (not article.name) then
				base.print('Error loading article', name)
			else		
				category[article.name] = article
			end
		end
    end
    return category
end


-- load articles for encyclopedia
-- articles splited to categories, each stored in its own directory
function loadArticles()
	local enc = { }
	local path = 'MissionEditor/data/scripts/Enc'	
	
	local function load(a_path, pluginPath)		
		for file in lfs.dir(a_path) do
			if '.' ~= string.sub(file, 1, 1) then
				local fullPath = a_path .. '/' .. file
				if 'directory' == lfs.attributes(fullPath).mode then
					enc[file] = loadCategory(fullPath, enc[file], pluginPath)
				end
			end
		end
	end
	
	load(path)
	if (base.plugins) then
		for i, plugin in ipairs(base.plugins) do
			if (plugin.encyclopedia_path) then
				load(plugin.encyclopedia_path,plugin.encyclopedia_path)
			end
		end
	end	
	
	------------------------------------------------------------
	-- auto create articles for static land objects 
	if not enc['Miscellanious'] then 
		enc['Miscellanious'] = {}
	end
	local Miscellanious = enc['Miscellanious']
	local MiscellaniousCat = { base.db.Units.Fortifications.Fortification,
						   base.db.Units.GroundObjects.GroundObject,
						   base.db.Units.Warehouses.Warehouse,
						   base.db.Units.Cargos.Cargo}

	for i,cat in ipairs(MiscellaniousCat) do
		for j,obj in ipairs(cat) do
			if obj.ShapeName and obj.DisplayName 
				and not enc['Personnel'][obj.DisplayName]
				and not enc['Miscellanious'][obj.DisplayName] then
				local article = {
					model 	  	= obj.ShapeName,
					unit_type 	= obj.ShapeName,
					line 		= "",
				}
				Miscellanious[obj.DisplayName] = article
			end
		end
	end
	
	------------------------------------------------------------

    return enc
end


