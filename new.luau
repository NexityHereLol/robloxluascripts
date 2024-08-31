-- survival odyssey
local roblo_lib = {}

function roblo_lib:CreateLib(name)
	
	local createtab = {}

	local uis = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")

	local roblo = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")

	local uis = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")

	-- Create UI elements
	local roblo = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 400, 0, 300)  -- Set the size of the Frame
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)  -- Initial position (centered)
	Main.AnchorPoint = Vector2.new(0.5, 0.5)  -- Center the Frame around its anchor point
	Main.BackgroundTransparency = 0  -- Fully opaque background
	Main.Visible = true  -- Initially visible
	Main.Parent = roblo
	roblo.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")  -- Add the ScreenGui to the PlayerGui

	-- Define off-screen position (left of the viewport)
	local offScreenPosition = UDim2.new(-0.5, 0, 0.5, 0)  -- Move completely off the left side of the screen

	-- Tween information
	local tweenTime = 0.5  -- Time in seconds for the animation
	local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

	-- Variables to track positions and tween progress
	local originalPosition = Main.Position
	local lastPosition = originalPosition  -- Start with the initial position
	local tweenInProgress = false  -- Track if a tween is currently playing
	local isVisible = true  -- Initially visible

	-- Create tweens for position transitions
	local moveInTween = TweenService:Create(Main, tweenInfo, {Position = lastPosition})
	local moveOutTween = TweenService:Create(Main, tweenInfo, {Position = offScreenPosition})

	-- Function to toggle visibility with position transition
	local function toggleVisibility()
		if tweenInProgress then
			return  -- Exit if a tween is already in progress
		end

		tweenInProgress = true

		if isVisible then
			-- Move out of the screen to the left and save the current position
			lastPosition = Main.Position
			moveOutTween:Play()
			moveOutTween.Completed:Connect(function()
				Main.Visible = false
				tweenInProgress = false
			end)
		else
			-- Make visible and move in from the last position
			Main.Visible = true
			moveInTween = TweenService:Create(Main, tweenInfo, {Position = lastPosition})
			moveInTween:Play()
			moveInTween.Completed:Connect(function()
				tweenInProgress = false
			end)
		end
		isVisible = not isVisible
	end

	-- Connect input event
	uis.InputBegan:Connect(function(key, chat)
		if key.KeyCode == Enum.KeyCode.RightControl then
			toggleVisibility()
		end
	end)

	--uis.InputBegan:Connect(function(key, chat)
	--	if key.KeyCode == Enum.KeyCode.RightControl then
	--		if Main.Visible == true then
	--			Main.Visible = false
	--		else
	--			Main.Visible = true
	--		end
	--	end
	--end)

	roblo.Name = "roblo"
	roblo.IgnoreGuiInset = false
	roblo.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	roblo.ResetOnSpawn = false

	Main.Name = "Main"
	Main.Parent = roblo
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
	Main.BorderColor3 = Color3.new(0, 0, 0)
	Main.BorderSizePixel = 0
	Main.Active = true
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = UDim2.new(0, 400, 0, 300)

	local DropShadowHolder = Instance.new("Frame")
	local DropShadow = Instance.new("ImageLabel")
	local TopBar = Instance.new("Frame")
	local Extension = Instance.new("Frame")
	local ui_name = Instance.new("TextLabel")
	local UIPadding_7 = Instance.new("UIPadding")
	local Line = Instance.new("Frame")
	local close_button = Instance.new("ImageButton")

	DropShadowHolder.Name = "DropShadowHolder"
	DropShadowHolder.Parent = Main
	DropShadowHolder.BackgroundTransparency = 1
	DropShadowHolder.BorderSizePixel = 0
	DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
	DropShadowHolder.ZIndex = 0

	DropShadow.Name = "DropShadow"
	DropShadow.Parent = DropShadowHolder
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 0
	DropShadow.Image = "rbxassetid://6015897843"
	DropShadow.ImageColor3 = Color3.new(0, 0, 0)
	DropShadow.ImageTransparency = 0.5
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	Extension.Name = "Extension"
	Extension.Parent = TopBar
	Extension.AnchorPoint = Vector2.new(0, 1)
	Extension.BackgroundColor3 = Color3.fromRGB(33, 149, 27)
	Extension.BorderColor3 = Color3.new(0, 0, 0)
	Extension.BorderSizePixel = 0
	Extension.Position = UDim2.new(0, 0, 1, 0)
	Extension.Size = UDim2.new(1, 0, 0.5, 0)

	ui_name.Name = "ui_name"
	ui_name.Parent = TopBar
	ui_name.BackgroundColor3 = Color3.new(1, 1, 1)
	ui_name.BackgroundTransparency = 1
	ui_name.BorderColor3 = Color3.new(0, 0, 0)
	ui_name.BorderSizePixel = 0
	ui_name.Size = UDim2.new(0.5, 0, 1, 0)
	ui_name.Font = Enum.Font.ArialBold
	ui_name.Text = name or "untitled LIB"
	ui_name.TextColor3 = Color3.new(1, 1, 1)
	ui_name.TextSize = 15
	ui_name.TextXAlignment = Enum.TextXAlignment.Left

	UIPadding_7.Parent = ui_name
	UIPadding_7.PaddingLeft = UDim.new(0, 4)

	Line.Name = "Line"
	Line.Parent = TopBar
	Line.AnchorPoint = Vector2.new(0, 1)
	Line.BackgroundColor3 = Color3.new(1, 1, 1)
	Line.BorderColor3 = Color3.new(0, 0, 0)
	Line.BorderSizePixel = 0
	Line.Position = UDim2.new(0, 0, 1, 0)
	Line.Size = UDim2.new(1, 0, 0, 1)

	close_button.Name = "close_button"
	close_button.Parent = TopBar
	close_button.AnchorPoint = Vector2.new(1, 0)
	close_button.BackgroundColor3 = Color3.new(1, 1, 1)
	close_button.BackgroundTransparency = 1
	close_button.BorderColor3 = Color3.new(0, 0, 0)
	close_button.BorderSizePixel = 0
	close_button.Position = UDim2.new(1, -5, 0, 5)
	close_button.Size = UDim2.new(0, 20, 0, 20)
	close_button.Image = "rbxassetid://18114937392"

	TopBar.Name = "TopBar"
	TopBar.Parent = Main
	TopBar.BackgroundColor3 = Color3.fromRGB(33, 149, 27)
	TopBar.BorderColor3 = Color3.new(0, 0, 0)
	TopBar.BorderSizePixel = 0
	TopBar.Size = UDim2.new(1, 0, 0, 30)

	local ContentHolder = Instance.new("Frame")
	
	ContentHolder.Name = "ContentHolder"
	ContentHolder.Parent = Main
	ContentHolder.AnchorPoint = Vector2.new(1, 0)
	ContentHolder.BackgroundColor3 = Color3.new(1, 1, 1)
	ContentHolder.BackgroundTransparency = 1
	ContentHolder.BorderColor3 = Color3.new(0, 0, 0)
	ContentHolder.BorderSizePixel = 0
	ContentHolder.Position = UDim2.new(1, -6, 0, 36)
	ContentHolder.Size = UDim2.new(1, -132, 1, -42)

	-- Instances

	local tabname = Instance.new("Frame")
	local tab_name = Instance.new("TextLabel")
	local UIPadding = Instance.new("UIPadding")

	-- Properties

	tabname.Name = "tabname"
	tabname.Parent = ContentHolder
	tabname.BackgroundColor3 = Color3.new(1, 1, 1)
	tabname.BackgroundTransparency = 1
	tabname.BorderColor3 = Color3.new(0, 0, 0)
	tabname.BorderSizePixel = 0
	tabname.Size = UDim2.new(0, 92, 0, 30)

	tab_name.Name = "tab_name"
	tab_name.Parent = tabname
	tab_name.Active = true
	tab_name.BackgroundColor3 = Color3.new(1, 1, 1)
	tab_name.BackgroundTransparency = 1
	tab_name.BorderColor3 = Color3.new(0, 0, 0)
	tab_name.BorderSizePixel = 0
	tab_name.Position = UDim2.new(0, 0, 0.333333343, 0)
	tab_name.Size = UDim2.new(2.8585763, 0, 0.400000006, 0)
	tab_name.Font = Enum.Font.ArialBold
	tab_name.Text = "script: " .. "'" .. tostring(name) .. "'" .. " loaded!"
	tab_name.TextColor3 = Color3.new(1, 1, 1)
	tab_name.TextSize = 15
	tab_name.TextXAlignment = Enum.TextXAlignment.Left

	UIPadding.Parent = tab_name
	UIPadding.PaddingBottom = UDim.new(0, 6)
	UIPadding.PaddingLeft = UDim.new(0, 6)
	UIPadding.PaddingRight = UDim.new(0, 6)
	UIPadding.PaddingTop = UDim.new(0, 6)

	-- Scripts

	local function LXMIO_fake_script() -- close_button.LocalScript 
		local script = Instance.new('LocalScript', close_button)

		close_button.MouseButton1Click:Connect(function()
			game.Players.LocalPlayer.PlayerGui:FindFirstChild("roblo"):Destroy()
		end)
		
		close_button.MouseEnter:Connect(function()
			local tweenservice = game:GetService('TweenService')
			local animspeed = 0.2
			local tweenfunc = TweenInfo.new(animspeed, Enum.EasingStyle.Linear , Enum.EasingDirection.Out, 0)
			local entered = 0.5
			game:GetService('TweenService'):Create(script.Parent, TweenInfo.new(animspeed), {ImageTransparency = entered}):Play()
		end)	

		close_button.MouseLeave:Connect(function()
			local tweenservice = game:GetService('TweenService')
			local animspeed = 0.2
			local tweenfunc = TweenInfo.new(animspeed, Enum.EasingStyle.Linear , Enum.EasingDirection.Out, 0)
			local left = 0
			game:GetService('TweenService'):Create(script.Parent, TweenInfo.new(animspeed), {ImageTransparency = left}):Play()
		end)
	end
	coroutine.wrap(LXMIO_fake_script)()

--
	local Navigation = Instance.new("Frame")
	local Holder = Instance.new("ScrollingFrame")
	local UIPadding = Instance.new("UIPadding")
	local UIListLayout = Instance.new("UIListLayout")
	local tabpage = Instance.new("ImageButton")
	local tab_title = Instance.new("TextLabel")
	local UIPadding_2 = Instance.new("UIPadding")

	-- Properties

	Navigation.Name = "Navigation"
	Navigation.Parent = Main
	Navigation.BackgroundColor3 = Color3.new(0.247059, 0.247059, 0.247059)
	Navigation.BorderColor3 = Color3.new(0, 0, 0)
	Navigation.BorderSizePixel = 0
	Navigation.Position = UDim2.new(0, 0, 0, 31)
	Navigation.Size = UDim2.new(0, 120, 1, -31)

	Holder.Name = "Holder"
	Holder.Parent = Navigation
	Holder.BackgroundColor3 = Color3.new(1, 1, 1)
	Holder.BackgroundTransparency = 1
	Holder.BorderColor3 = Color3.new(0, 0, 0)
	Holder.BorderSizePixel = 0
	Holder.Position = UDim2.new(0, 0, 0.0100000091, 0)
	Holder.Size = UDim2.new(0, 120, 0, 266)
	Holder.ScrollBarThickness = 0

	UIPadding.Parent = Holder

	UIListLayout.Parent = Holder
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 3.5)

	--tabpage.Name = "tabpage"
	--tabpage.Parent = Holder
	--tabpage.BackgroundColor3 = Color3.new(0.32549, 0.32549, 0.32549)
	--tabpage.BorderColor3 = Color3.new(0, 0, 0)
	--tabpage.BorderSizePixel = 0
	--tabpage.Position = UDim2.new(0, 0, 0.289962828, 0)
	--tabpage.Size = UDim2.new(0, 120, 0, 38)
	--tabpage.AutoButtonColor = false
	--tabpage.Image = "rbxassetid://18117415152"
	--tabpage.ImageTransparency = 1

	--tab_title.Name = "tab_title"
	--tab_title.Parent = tabpage
	--tab_title.BackgroundColor3 = Color3.new(1, 1, 1)
	--tab_title.BackgroundTransparency = 1
	--tab_title.BorderColor3 = Color3.new(0, 0, 0)
	--tab_title.BorderSizePixel = 0
	--tab_title.Position = UDim2.new(0, 0, 0.114285924, 0)
	--tab_title.Size = UDim2.new(0, 58, 0, 28)
	--tab_title.Font = Enum.Font.Arial
	--tab_title.Text = "tab1"
	--tab_title.TextColor3 = Color3.new(1, 1, 1)
	--tab_title.TextSize = 14
	--tab_title.TextXAlignment = Enum.TextXAlignment.Left

	UIPadding_2.Parent = tab_title
	UIPadding_2.PaddingBottom = UDim.new(0, 4)
	UIPadding_2.PaddingLeft = UDim.new(0, 4)
	UIPadding_2.PaddingRight = UDim.new(0, 4)
	UIPadding_2.PaddingTop = UDim.new(0, 4)

--

---------------------------------------------------------------------

	function createtab:CreateTab(tabname,number)
		
		--
		
		local innertab = {}
		local tabitems = {}
		
		local tabpage = Instance.new("ImageButton")
		
		tabpage.Name = tabname
		tabpage.Parent = Holder
		tabpage.Archivable = false
		tabpage.BackgroundColor3 = Color3.fromRGB(83,83,83)
		tabpage.BorderColor3 = Color3.new(0, 0, 0)
		tabpage.BorderSizePixel = 0
		tabpage.Position = UDim2.new(0, 0, 0.289962828, 0)
		tabpage.Size = UDim2.new(0, 120, 0, 38)
		tabpage.AutoButtonColor = false
		tabpage.Image = ""
		--rbxassetid://18117415152
		tabpage.ImageTransparency = 1
		tabpage.BorderColor3 = Color3.fromRGB(0,0,0)

		local tab_title = Instance.new("TextLabel")
		local UIPadding_2 = Instance.new("UIPadding")

		local function YZXT_fake_script() -- button_frame.anim 
			local script = Instance.new('LocalScript', tabpage)

			tabpage.MouseEnter:Connect(function()
				local tweenservice = game:GetService('TweenService')
				local animspeed = 0.2
				local tweenfunc = TweenInfo.new(animspeed, Enum.EasingStyle.Linear , Enum.EasingDirection.Out, 0)
				local entered = 0.5
				game:GetService('TweenService'):Create(script.Parent, TweenInfo.new(animspeed), {BackgroundTransparency = entered}):Play()
			end)	

			tabpage.MouseLeave:Connect(function()
				local tweenservice = game:GetService('TweenService')
				local animspeed = 0.2
				local tweenfunc = TweenInfo.new(animspeed, Enum.EasingStyle.Linear , Enum.EasingDirection.Out, 0)
				local left = 0
				game:GetService('TweenService'):Create(script.Parent, TweenInfo.new(animspeed), {BackgroundTransparency = left}):Play()
			end)
		end
		coroutine.wrap(YZXT_fake_script)()

		tab_title.Name = "tab_title"
		tab_title.Parent = tabpage
		tab_title.BackgroundColor3 = Color3.new(1, 1, 1)
		tab_title.BackgroundTransparency = 1
		tab_title.BorderColor3 = Color3.new(0, 0, 0)
		tab_title.BorderSizePixel = 0
		tab_title.Position = UDim2.new(0, 0, 0.114285924, 0)
		tab_title.Size = UDim2.new(0, 58, 0, 28)
		tab_title.Font = Enum.Font.Arial
		tab_title.Text = tabname or "tab"
		tab_title.TextColor3 = Color3.new(1, 1, 1)
		tab_title.TextSize = 14
		tab_title.TextXAlignment = Enum.TextXAlignment.Left

		UIPadding_2.Parent = tab_title
		UIPadding_2.PaddingBottom = UDim.new(0, 4)
		UIPadding_2.PaddingLeft = UDim.new(0, 4)
		UIPadding_2.PaddingRight = UDim.new(0, 4)
		UIPadding_2.PaddingTop = UDim.new(0, 4)
		
		--
		
		--local tab_template = Instance.new("ScrollingFrame")
		--local UIPadding_ = Instance.new("UIPadding")
		--local UIListLayout_ = Instance.new("UIListLayout")

		--tab_template.Name = "tab_template"
		--tab_template.Visible = false
		--tab_template.Parent = ContentHolder
		--tab_template.Active = true
		--tab_template.BackgroundColor3 = Color3.new(1, 1, 1)
		--tab_template.BackgroundTransparency = 1
		--tab_template.BorderColor3 = Color3.new(0, 0, 0)
		--tab_template.BorderSizePixel = 0
		--tab_template.Position = UDim2.new(0, 0, 0.138333336, 0)
		--tab_template.Size = UDim2.new(1, 0, 0.861666679, 0)
		--tab_template.ScrollBarThickness = 0
		--tab_template.CanvasSize = UDim2('set code')
		
		--UIPadding_.Parent = tab_template
		--UIPadding_.PaddingBottom = UDim.new(0, 1)
		--UIPadding_.PaddingLeft = UDim.new(0, 1)
		--UIPadding_.PaddingRight = UDim.new(0, 1)
		--UIPadding_.PaddingTop = UDim.new(0, 1)

		--UIListLayout_.Parent = tab_template
		--UIListLayout_.SortOrder = Enum.SortOrder.LayoutOrder
		--UIListLayout_.Padding = UDim.new(0, 4)
		
		--canvas stuff
		
		
		local tab_template = Instance.new("ScrollingFrame")
		local UIPadding_ = Instance.new("UIPadding")
		local UIListLayout_ = Instance.new("UIListLayout")

		tab_template.Name = "tab_template"
		tab_template.Visible = false	
		tab_template.Parent = ContentHolder
		tab_template.Active = true
		tab_template.BackgroundColor3 = Color3.new(1, 1, 1)
		tab_template.BackgroundTransparency = 1
		tab_template.BorderColor3 = Color3.new(0, 0, 0)
		tab_template.BorderSizePixel = 0
		tab_template.Position = UDim2.new(0, 0, 0.138, 0)
		tab_template.Size = UDim2.new(1, 0, 0.862, 0)
		tab_template.ScrollBarThickness = 0
		tab_template.CanvasSize = UDim2.new(0, 0, 0, 10000)

		UIPadding_.Parent = tab_template
		UIPadding_.PaddingBottom = UDim.new(0, 1)
		UIPadding_.PaddingLeft = UDim.new(0, 1)
		UIPadding_.PaddingRight = UDim.new(0, 1)
		UIPadding_.PaddingTop = UDim.new(0, 1)

		UIListLayout_.Parent = tab_template
		UIListLayout_.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_.Padding = UDim.new(0, 4)
		
		--canvas stuff
		
		
		local TweenService = game:GetService("TweenService")

		local currentTab = nil  -- Variable to keep track of the currently selected tab

		-- Function to handle tab button click
		local function onTabClick(selectedTab)
			for i,p in next, ContentHolder:GetChildren() do
				if p.Name == "tabname" then
					--print('tabname failed to go invis!')
				else
					p.Visible = false
				end
			end 
			tab_template.Visible = true
			tab_name.Text = tostring(tabname)
			-- Only proceed if the clicked tab is not already selected
			if selectedTab ~= currentTab then
				-- If there is a currently selected tab, tween its background color to the default color
				if currentTab then
					local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
					local goal = {BackgroundColor3 = Color3.fromRGB(83, 83, 83)}
					local tween = TweenService:Create(currentTab, tweenInfo, goal)
					tween:Play()
				end

				-- Tween the newly selected tab's background color to the highlighted color
				local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
				local goal = {BackgroundColor3 = Color3.fromRGB(63, 63, 63)}
				local tween = TweenService:Create(selectedTab, tweenInfo, goal)
				tween:Play()

				-- Update the current tab to the newly selected tab
				currentTab = selectedTab

				-- Show the content for the selected tab
				local tabContent = Holder:FindFirstChild(selectedTab.Name)
				if tabContent then
					tabContent.Visible = true
				end

				-- Optionally hide content for previously selected tab (if needed)
				-- if currentTab then
				--     local oldContent = Holder:FindFirstChild(currentTab.Name)
				--     if oldContent then
				--         oldContent.Visible = false
				--     end
				-- end
			end
		end

		-- Connect each tab button to the click handler
		for _, tab in ipairs(Holder:GetChildren()) do
			if tab:IsA("ImageButton") then
				tab.MouseButton1Click:Connect(function()
					onTabClick(tab)
				end)
			end
		end

		
		--
		local innertab = {}
		
		function innertab:CreateSlider(slidertitle, maxvalue, minvalue, callback)
			
			local slider = Instance.new("Frame")
			local slider_name = Instance.new("TextLabel")
			local UIPadding = Instance.new("UIPadding")
			local slider_val = Instance.new("TextLabel")
			local UIPadding_2 = Instance.new("UIPadding")
			local sliderbtn = Instance.new("ImageButton")
			
			-- Create the slider frame
			slider.Name = "slider"
			slider.Parent = tab_template
			slider.BackgroundColor3 = Color3.new(0.247059, 0.247059, 0.247059)
			slider.BorderColor3 = Color3.new(0, 0, 0)
			slider.BorderSizePixel = 0
			slider.Position = UDim2.new(0, 0, 0.630929172, 0)
			slider.Size = UDim2.new(0, 261, 0, 48)

			slider_name.Name = "slider_name"
			slider_name.Parent = slider
			slider_name.Active = true
			slider_name.BackgroundColor3 = Color3.new(1, 1, 1)
			slider_name.BackgroundTransparency = 1
			slider_name.BorderColor3 = Color3.new(0, 0, 0)
			slider_name.BorderSizePixel = 0
			slider_name.Position = UDim2.new(-0.00373132923, 0, 0.0789477006, 0)
			slider_name.Size = UDim2.new(0.570881248, 0, 0.433114141, 0)
			slider_name.Font = Enum.Font.Arial
			slider_name.Text = slidertitle or "untitled slider"
			slider_name.TextColor3 = Color3.new(1, 1, 1)
			slider_name.TextSize = 14
			slider_name.TextXAlignment = Enum.TextXAlignment.Left

			UIPadding.Parent = slider_name
			UIPadding.PaddingBottom = UDim.new(0, 6)
			UIPadding.PaddingLeft = UDim.new(0, 6)
			UIPadding.PaddingRight = UDim.new(0, 6)
			UIPadding.PaddingTop = UDim.new(0, 6)

			slider_val.Name = "slider_val"
			slider_val.Parent = slider
			slider_val.Active = true
			slider_val.BackgroundColor3 = Color3.new(1, 1, 1)
			slider_val.BackgroundTransparency = 1
			slider_val.BorderColor3 = Color3.new(0, 0, 0)
			slider_val.BorderSizePixel = 0
			slider_val.Position = UDim2.new(0.628452599, 0, 0.0789477006, 0)
			slider_val.Size = UDim2.new(0.379168272, 0, 0.433114141, 0)
			slider_val.Font = Enum.Font.Arial
			slider_val.Text = ""
			slider_val.TextColor3 = Color3.new(1, 1, 1)
			slider_val.TextSize = 14
			slider_val.TextXAlignment = Enum.TextXAlignment.Right

			UIPadding_2.Parent = slider_val
			UIPadding_2.PaddingBottom = UDim.new(0, 6)
			UIPadding_2.PaddingLeft = UDim.new(0, 6)
			UIPadding_2.PaddingRight = UDim.new(0, 6)
			UIPadding_2.PaddingTop = UDim.new(0, 6)

			sliderbtn.Name = "sliderbtn"
			sliderbtn.Parent = slider
			sliderbtn.BackgroundColor3 = Color3.new(1, 1, 1)
			sliderbtn.BorderColor3 = Color3.new(0, 0, 0)
			sliderbtn.BorderSizePixel = 0
			sliderbtn.Position = UDim2.new(0.042145595, 0, 0.657895386, 0)
			sliderbtn.Size = UDim2.new(0, 237, 0, 7)
			sliderbtn.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

			local mouse = game.Players.LocalPlayer:GetMouse()
			local uis = game:GetService("UserInputService")
			local tweenService = game:GetService("TweenService")
			local Value

			local MIN_WIDTH = 5
			local SLIDER_WIDTH = 237  -- Width of the slider bar

			-- Update slider value function
			local function updateSliderValue()
				local sliderWidth = sliderbtn.AbsoluteSize.X
				if sliderWidth <= MIN_WIDTH then
					Value = tonumber(minvalue)
				else
					Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / (SLIDER_WIDTH - MIN_WIDTH)) * (sliderWidth - MIN_WIDTH)) + tonumber(minvalue))
				end
				slider_val.Text = tostring(Value)
				pcall(function()
					callback(Value)
				end)
			end

			-- Slider button drag functionality
			sliderbtn.MouseButton1Down:Connect(function()
				local moveconnection
				local releaseconnection

				updateSliderValue()
				local initialSize = math.clamp(mouse.X - sliderbtn.AbsolutePosition.X, MIN_WIDTH, SLIDER_WIDTH)
				tweenService:Create(sliderbtn, TweenInfo.new(0.1), {Size = UDim2.new(0, initialSize, 0, 7)}):Play()

				moveconnection = mouse.Move:Connect(function()
					local newSize = math.clamp(mouse.X - sliderbtn.AbsolutePosition.X, MIN_WIDTH, SLIDER_WIDTH)
					updateSliderValue()
					tweenService:Create(sliderbtn, TweenInfo.new(0.1), {Size = UDim2.new(0, newSize, 0, 7)}):Play()
				end)

				releaseconnection = uis.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						local finalSize = math.clamp(mouse.X - sliderbtn.AbsolutePosition.X, MIN_WIDTH, SLIDER_WIDTH)
						updateSliderValue()
						tweenService:Create(sliderbtn, TweenInfo.new(0.1), {Size = UDim2.new(0, finalSize, 0, 7)}):Play()
						moveconnection:Disconnect()
						releaseconnection:Disconnect()
					end
				end)
			end)

		end


		
		function innertab:CreateSubDivider(name)
			local divider = Instance.new("Frame")
			local dividerLine = Instance.new("Frame")
			local divider_name = Instance.new("TextLabel")
			local UIPadding = Instance.new("UIPadding")

			-- Properties

			divider.Name = "divider"
			divider.Parent = tab_template
			divider.BackgroundColor3 = Color3.new(1, 1, 1)
			divider.BackgroundTransparency = 1
			divider.BorderColor3 = Color3.new(0, 0, 0)
			divider.BorderSizePixel = 0
			divider.Position = UDim2.new(0, 0, 0.354046583, 0)
			divider.Size = UDim2.new(0, 268, 0, 57)

			dividerLine.Name = "dividerLine"
			dividerLine.Parent = divider
			dividerLine.BackgroundColor3 = Color3.new(0.247059, 0.247059, 0.247059)
			dividerLine.BorderColor3 = Color3.new(0, 0, 0)
			dividerLine.BorderSizePixel = 0
			dividerLine.Position = UDim2.new(0, 0, 0.649122834, 0)
			dividerLine.Size = UDim2.new(0, 267, 0, 7)

			divider_name.Name = name
			divider_name.Parent = divider
			divider_name.Active = true
			divider_name.BackgroundColor3 = Color3.new(1, 1, 1)
			divider_name.BackgroundTransparency = 1
			divider_name.BorderColor3 = Color3.new(0, 0, 0)
			divider_name.BorderSizePixel = 0
			divider_name.Position = UDim2.new(-0.00373157114, 0, 0.0789479017, 0)
			divider_name.Size = UDim2.new(1.00000012, 0, 0.578947365, 0)
			divider_name.Font = Enum.Font.Arial
			divider_name.Text = name or "untitled_divider"
			divider_name.TextColor3 = Color3.new(1, 1, 1)
			divider_name.TextSize = 14
			divider_name.TextXAlignment = Enum.TextXAlignment.Left

			UIPadding.Parent = divider_name
			UIPadding.PaddingBottom = UDim.new(0, 6)
			UIPadding.PaddingLeft = UDim.new(0, 6)
			UIPadding.PaddingRight = UDim.new(0, 6)
			UIPadding.PaddingTop = UDim.new(0, 6)
		end
		
		function innertab:CreateCheckBox(name,callback)
			local checkbox = Instance.new("Frame")
			local checkboxname = Instance.new("TextLabel")
			local UIPadding = Instance.new("UIPadding")
			local toggler = Instance.new("ImageButton")

			-- Properties

			checkbox.Name = "checkbox"
			checkbox.Parent = tab_template
			checkbox.Active = true
			checkbox.BackgroundColor3 = Color3.new(0.247059, 0.247059, 0.247059)
			checkbox.BorderColor3 = Color3.new(0, 0, 0)
			checkbox.BorderSizePixel = 0
			checkbox.Size = UDim2.new(0, 269, 0, 35)

			checkboxname.Name = name or "untitled"
			checkboxname.Parent = checkbox
			checkboxname.Active = true
			checkboxname.BackgroundColor3 = Color3.new(1, 1, 1)
			checkboxname.BackgroundTransparency = 1
			checkboxname.BorderColor3 = Color3.new(0, 0, 0)
			checkboxname.BorderSizePixel = 0
			checkboxname.Position = UDim2.new(0, 0, 0.166666955, 0)
			checkboxname.Size = UDim2.new(0.784386635, 0, 0.666666746, 0)
			checkboxname.Font = Enum.Font.Arial
			checkboxname.Text = name or "untitled"
			checkboxname.TextColor3 = Color3.new(1, 1, 1)
			checkboxname.TextSize = 14
			checkboxname.TextXAlignment = Enum.TextXAlignment.Left

			UIPadding.Parent = checkboxname
			UIPadding.PaddingBottom = UDim.new(0, 6)
			UIPadding.PaddingLeft = UDim.new(0, 6)
			UIPadding.PaddingRight = UDim.new(0, 6)
			UIPadding.PaddingTop = UDim.new(0, 6)

			toggler.Name = "toggler"
			toggler.Parent = checkbox
			toggler.BackgroundColor3 = Color3.new(0.145098, 1, 0.972549)
			toggler.BackgroundTransparency = 1
			toggler.BorderColor3 = Color3.new(0, 0, 0)
			toggler.BorderSizePixel = 0
			toggler.Position = UDim2.new(0.921892226, 0, 0.285714298, 0)
			toggler.Size = UDim2.new(0, 14, 0, 15)
			toggler.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
			toggler.ImageColor3 = Color3.new(1, 0.309804, 0.309804)

			callback = callback or function() end

			local function VXMIPL_fake_script() -- checkbox.manage 
				local script = Instance.new('LocalScript', checkbox)

				local enabled = false
				toggler.MouseButton1Click:Connect(function()
					if enabled == false then
						enabled = true
						local speed = 0.2
						local tf = TweenInfo.new(speed, Enum.EasingStyle.Sine , Enum.EasingDirection.In, 0.5)
						local ts = game:GetService("TweenService")
						local checktrue = Color3.fromRGB(33, 149, 27)
						ts:Create(toggler,tf, {ImageColor3 = checktrue}):Play()
						--toggler.ImageColor3 = Color3.fromRGB(144,255,96)
					else
						enabled = false 
						local speed = 0.2
						local tf = TweenInfo.new(speed, Enum.EasingStyle.Sine , Enum.EasingDirection.Out, 0.5)
						local ts = game:GetService("TweenService")
						local checkfalse = Color3.fromRGB(255,79,79)	
						ts:Create(toggler,tf, {ImageColor3 = checkfalse}):Play()
						--toggler.ImageColor3 = Color3.fromRGB(255,79,79)
					end
					pcall(callback,enabled)
				end)
			end
			coroutine.wrap(VXMIPL_fake_script)()
		end
		function innertab:CreateButton(name,callback)
			
			local button = Instance.new("Frame")
			local buttonname = Instance.new("TextLabel")
			local UIPadding = Instance.new("UIPadding")
			local button_2 = Instance.new("ImageButton")
			local btn_content = Instance.new("TextButton")

			btn_content.Name = "btn_content"
			btn_content.Parent = button
			btn_content.BackgroundColor3 = Color3.new(1, 1, 1)
			btn_content.BackgroundTransparency = 1
			btn_content.BorderColor3 = Color3.new(0, 0, 0)
			btn_content.BorderSizePixel = 0
			btn_content.Size = UDim2.new(0, 268, 0, 35)
			btn_content.Font = Enum.Font.SourceSans
			btn_content.Text = ""
			btn_content.TextColor3 = Color3.new(0, 0, 0)
			btn_content.TextSize = 14
			
			button.Name = "button"
			button.Parent = tab_template
			button.Active = true
			button.BackgroundColor3 = Color3.new(0.247059, 0.247059, 0.247059)
			button.BorderColor3 = Color3.new(0, 0, 0)
			button.BorderSizePixel = 0
			button.Size = UDim2.new(0, 269, 0, 35)

			buttonname.Name = "buttonname"
			buttonname.Parent = button
			buttonname.Active = true
			buttonname.BackgroundColor3 = Color3.new(1, 1, 1)
			buttonname.BackgroundTransparency = 1
			buttonname.BorderColor3 = Color3.new(0, 0, 0)
			buttonname.BorderSizePixel = 0
			buttonname.Position = UDim2.new(0, 0, 0.166666672, 0)
			buttonname.Size = UDim2.new(0.843866169, 0, 0.666666687, 0)
			buttonname.Font = Enum.Font.Arial
			buttonname.Text = name or "blank button"
			buttonname.TextColor3 = Color3.new(1, 1, 1)
			buttonname.TextSize = 14
			buttonname.TextXAlignment = Enum.TextXAlignment.Left

			UIPadding.Parent = buttonname
			UIPadding.PaddingBottom = UDim.new(0, 6)
			UIPadding.PaddingLeft = UDim.new(0, 6)
			UIPadding.PaddingRight = UDim.new(0, 6)
			UIPadding.PaddingTop = UDim.new(0, 6)

			button_2.Name = "button"
			button_2.Parent = button
			button_2.BackgroundColor3 = Color3.new(1, 1, 1)
			button_2.BackgroundTransparency = 1
			button_2.BorderColor3 = Color3.new(0, 0, 0)
			button_2.BorderSizePixel = 0
			button_2.Position = UDim2.new(0.921892226, 0, 0.279142529, 0)
			button_2.Size = UDim2.new(0, 15, 0, 15)
			button_2.Image = "rbxassetid://18115336602"
			
			local function YZXT_fake_script() -- button_frame.anim 
				local script = Instance.new('LocalScript', button)

				button.MouseEnter:Connect(function()
					local tweenservice = game:GetService('TweenService')
					local animspeed = 0.2
					local tweenfunc = TweenInfo.new(animspeed, Enum.EasingStyle.Linear , Enum.EasingDirection.Out, 0)
					local entered = 0.5
					game:GetService('TweenService'):Create(script.Parent, TweenInfo.new(animspeed), {BackgroundTransparency = entered}):Play()
				end)

				btn_content.MouseButton1Click:Connect(function()
					pcall(callback)
				end)		

				button.MouseLeave:Connect(function()
					local tweenservice = game:GetService('TweenService')
					local animspeed = 0.2
					local tweenfunc = TweenInfo.new(animspeed, Enum.EasingStyle.Linear , Enum.EasingDirection.Out, 0)
					local left = 0
					game:GetService('TweenService'):Create(script.Parent, TweenInfo.new(animspeed), {BackgroundTransparency = left}):Play()
				end)
			end
			coroutine.wrap(YZXT_fake_script)()
			
		end

		return innertab
	end
	
	local function KSDLOBQ_fake_script() -- Main.drag 
		local script = Instance.new('LocalScript', Main)

		local UIS = game:GetService("UserInputService")
		local frame = script.Parent
		local dragToggle = nil
		local dragSpeed = 0.25 -- the amount of speed you want the drag to be
		local dragStart = nil
		local startPos = nil

		local function updateInput(input)
			local delta = input.Position - dragStart
			local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			game:GetService('TweenService'):Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
		end

		frame.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
				dragToggle = true
				dragStart = input.Position
				startPos = frame.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragToggle = false
					end
				end)
			end
		end)

		UIS.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				if dragToggle then
					updateInput(input)
				end
			end
		end)
	end
	coroutine.wrap(KSDLOBQ_fake_script)()
	return createtab
end

local zab = roblo_lib:CreateLib("skidware")
local main = zab:CreateTab("main","all script functions")
local extra = zab:CreateTab("credits","person who made this script")
local server_hop = zab:CreateTab("server hop","incase u wanna switch modes")

main:CreateSubDivider("player mods")

main:CreateSlider("walkspeed boost",100,16,function(s)
    _G.HackedWalkSpeed = s
    local Plrs = game:GetService("Players")
    local MyPlr = Plrs.LocalPlayer
    local function updateWalkSpeed(Hum)
        Hum.WalkSpeed = _G.HackedWalkSpeed
    end
    local function onCharacterAdded(Char)
        local Hum = Char:WaitForChild("Humanoid")
        Hum.Changed:Connect(function()
            updateWalkSpeed(Hum)
        end)
        updateWalkSpeed(Hum)
    end
    if MyPlr.Character then
        onCharacterAdded(MyPlr.Character)
    end
    MyPlr.CharacterAdded:Connect(onCharacterAdded)
end)

main:CreateSlider("jump power boost",300,50,function(s)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

main:CreateSubDivider("pvp/heal")

-- Variables
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Configuration
local checkRadius = 25 -- Radius in studs to check for nearby players
local tweenTime = 0.001 -- Time in seconds for fast tweening to the target player
local orbitRadius = 3 -- Radius of the orbit
local orbitSpeed = 250 -- Orbit speed in degrees per second
local orbitOffset = Vector3.new(0, 3.5, 0) -- Offset from the target player's torso

-- Initialize global control variable
_G.spam = false -- Default to false to prevent initial execution

local player = Players.LocalPlayer
local orbitConnection -- To store the connection for orbiting
local previousPlayer -- To track the previously targeted player

-- Function to move to a target player using TweenService
local function tweenToPlayer(character, targetPlayer)
    if not _G.spam then return false end -- Check if spam is enabled

    if character and targetPlayer and targetPlayer.Character then
        local targetRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local characterRootPart = character:FindFirstChild("HumanoidRootPart")

        if targetRootPart and characterRootPart then
            local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
            local goal = {CFrame = targetRootPart.CFrame}
            local tween = TweenService:Create(characterRootPart, tweenInfo, goal)
            tween:Play()
            tween.Completed:Wait() -- Wait until the tween completes
            return true -- Indicate that tweening is done
        end
    end
    return false
end

-- Function to get the closest player within the specified radius, excluding players on the same team
local function getNearbyPlayer(character, radius)
    local closestPlayer = nil
    local characterPosition = character:FindFirstChild("HumanoidRootPart").Position
    local localTeam = player.Team

    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= Players.LocalPlayer then
            -- Check if player is not on the same team
            if p.Team ~= localTeam then
                local playerPosition = p.Character.HumanoidRootPart.Position
                local dist = (playerPosition - characterPosition).magnitude
                if dist <= radius then
                    closestPlayer = p
                    break -- Exit loop if we found a player within the radius
                end
            end
        end
    end

    return closestPlayer
end

-- Function to orbit around the target player
local function orbitAroundPlayer(character, targetPlayer)
    if not _G.spam then return end -- Check if spam is enabled

    local targetRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRootPart then return end

    local angle = 0

    -- Clean up previous orbit connection if it exists
    if orbitConnection then
        orbitConnection:Disconnect()
    end

    -- Create a new connection for orbiting
    orbitConnection = RunService.RenderStepped:Connect(function()
        if character and targetPlayer and targetPlayer.Character and _G.spam then
            local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then
                -- Stop orbiting if the target player's health is 0
                previousPlayer = nil
                orbitConnection:Disconnect()
                return
            end

            local radian = math.rad(angle)
            local x = orbitRadius * math.cos(radian)
            local z = orbitRadius * math.sin(radian)
            local newPosition = targetRootPart.Position + Vector3.new(x, orbitOffset.Y, z)

            -- Update the character's CFrame to look at the target player's torso while orbiting
            character.HumanoidRootPart.CFrame = CFrame.new(newPosition, targetRootPart.Position + orbitOffset)

            angle = angle + orbitSpeed * RunService.RenderStepped:Wait()
            if angle >= 360 then
                angle = angle - 360
            end
        end
    end)
end

-- Function to handle the behavior based on spam flag
local function startBehavior()
    if not _G.spam then return end -- Ensure spam is enabled

    local closestPlayer = getNearbyPlayer(player.Character, checkRadius)
    if closestPlayer and closestPlayer ~= previousPlayer then
        local tweenDone = tweenToPlayer(player.Character, closestPlayer)
        if tweenDone then
            orbitAroundPlayer(player.Character, closestPlayer)
            previousPlayer = closestPlayer -- Update the previously targeted player
        end
    end
end

-- Function to continuously check for new players and start behavior
local function checkAndOrbit()
    while _G.spam do
        startBehavior()
        wait(0.001) -- Reduced wait time for faster checks
    end

    -- Stop orbiting if spam is disabled
    if orbitConnection then
        orbitConnection:Disconnect()
    end
end

-- Handle checkbox state
main:CreateCheckBox("killaura (team check)", function(s)
    _G.spam = s -- Set global control variable

    if s then
        previousPlayer = nil -- Reset previous player when re-enabling
        --delete line below if flagged error
        checkAndOrbit() -- Start checking and orbiting immediately
    else
        -- Stop the orbiting and clean up when checkbox is turned off
        if orbitConnection then
            orbitConnection:Disconnect()
        end
    end
end)



local autoHealActive3 = false
local autoHealActive2 = false
local autoHealActive = false

-- Function to create the checkboxes for auto-heal
main:CreateCheckBox("auto heal cooked meat (spam e)", function(s)
    autoHealActive3 = s
end)

main:CreateCheckBox("auto heal cooked morsel (spam e)", function(s)
    autoHealActive2 = s
end)

main:CreateCheckBox("auto heal blood fruit (spam e)", function(s)
    autoHealActive = s
end)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Combined function to handle key down events
local function onKeyDown(key)
    if key == "e" then
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local event = replicatedStorage:WaitForChild("Events"):WaitForChild("UseBagItem")

        if autoHealActive3 then
            local args = { [1] = "Cooked Meat" }
            event:FireServer(unpack(args))
        end

        if autoHealActive2 then
            local args = { [1] = "Cooked Morsel" }
            event:FireServer(unpack(args))
        end

        if autoHealActive then
            local args = { [1] = "Bloodfruit" }
            event:FireServer(unpack(args))
        end
    end
end

-- Connect key down event to handler
mouse.KeyDown:Connect(onKeyDown)



--

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create a global variable to track the auto-heal state
local autoHealActive = false

-- Function to create the checkbox for auto-heal
main:CreateCheckBox("auto heal blood fruit (HP based)", function(s)
    -- Update the global variable based on the checkbox state
    autoHealActive = s
end)

-- Function to perform auto-heal if HP falls below the threshold
local function checkHealth()
    if autoHealActive and humanoid.Health < 100 then
        local A_1 = "Bloodfruit"
        local Event = ReplicatedStorage.Events.UseBagItem
        Event:FireServer(A_1)
    end
end

-- Monitor health changes
humanoid.HealthChanged:Connect(function()
    checkHealth()
end)

local placeID = game.PlaceId


if placeID == 18629062294 then
    print('civ content')
    print('civ content_loaded')
    local civ = zab:CreateTab("civ teleports")
    -- Create a sub-divider for 'civilization teleports'
    civ:CreateSubDivider('civilization teleports')

	civ:CreateSubDivider('vast lands teleports')
    
    --all tp locations (civ)

    local function stringToCFrame(coordString)
        local x, y, z = coordString:match("([^,]+),%s*([^,]+),%s*([^,]+)")
        return CFrame.new(tonumber(x), tonumber(y), tonumber(z))
    end

    local vastEMERALD = "-370, 83, 590"

    local vastPINK_DIM = "-612, -35, 172"

    local vastOLD_GOOD = "-377, 13, 679"

    local vastDOCK = "14, -150, -12"

    local vastCRY = "-85, 1, -1216"

    local vastVOID = "-395, -7, -33"

    local vastEMCAVE = "-357, -53, 490"

    local vastANC_TREE = "-405, 94, 6"

--all tp locations (civ)

--all civilization telelports

    main:CreateButton("ancient tree", function()

    local targetCFrame = stringToCFrame(vastANC_TREE)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2 -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main:CreateButton("emerald cave", function()

    local targetCFrame = stringToCFrame(vastEMCAVE)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2 -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main:CreateButton("void", function()

    local targetCFrame = stringToCFrame(vastVOID)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2 -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main:CreateButton("crystal", function()

    local targetCFrame = stringToCFrame(vastCRY)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2 -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main:CreateButton("old good",function()

    local targetCFrame = stringToCFrame(vastOLD_GOOD)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2 -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main:CreateButton("pink diamond",function()

    local targetCFrame = stringToCFrame(vastPINK_DIM)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2 -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)



main:CreateButton("under map",function()

    local targetCFrame = stringToCFrame(vastDOCK)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = math.huge -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main:CreateButton("emerald",function()

    local targetCFrame = stringToCFrame(vastEMERALD)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2 -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

--all civilization teleports

else
    print('player is in different mode, loading init script')
end



if placeID == 18629053284 then
    print('normal content')
    print('normal content_loaded')
	local main_tp = zab:CreateTab("teleports")
    -- Create a sub-divider for 'normal teleports'
    main_tp:CreateSubDivider("normal teleports")

    
    --all tp locations (normal booga)

    local function stringToCFrame(coordString)
        local x, y, z = coordString:match("([^,]+),%s*([^,]+),%s*([^,]+)")
        return CFrame.new(tonumber(x), tonumber(y), tonumber(z))
    end

    --ice good
    local ICE_GOOD = "701, 235, -1206"

    --overgrown good
    local OVERGROWN_GOOD = "653.171265, -327.702515, 975.263672, -0.999445081, -0.0254688077, 0.0214857943, -0.0306843296, 0.954864562, -0.295452416, -0.0129912549, -0.295947611, -0.955116272"


    --miserable good
    local MISERABLE_GOOD = "246.062119, 157.708252, -431.478668, 0.996775031, 0.0511769578, 0.0618097, 0.0156590939, 0.631392956, -0.775304973, -0.0787039548, 0.773772538, 0.628555298"

    --frozen good
    local FROZEN_GOOD = "697.133911, 239.4095, -1253.38025, 0.561541498, -0.011656855, 0.819196582, 0.253329548, 0.97911036, -5.43221831e-05, -0.802577532, 0.0166597366, 0.573512912"

    --hateful good
    local HATEFUL_GOOD = "-516.527588, -153.272232, 942.607544, 0.98833102, 0.0376398005, -0.0147597522, -0.0618474297, 0.98468107, -0.0163028017, 0.0139250151, 0.0170254186, 0.975518763"

    --emerald cave
    local EMERALD = "-590, -73, -1030"

    --pink diamond
    local PINKDIM = "515, 284, -1257"

    --magnetite
    local MAG = "954, -628, 763"

    --crystal 
    local CRYSTAL = "-517, 384, 197"

    --first island
    local ISLAND = "245, 253, -319"

    --gold 
    local GOLD = "-47, 381, 175"
    local normOLD_GOOD  = "-54, -126, -946"

    --peace/spawn
    local PEACE = "1696, -2, 1991"

--all tp locations (normal)

--all normal teleports

main_tp:CreateButton("wealthy g", function()
    local WEALTHY = "1483, 5, 35"
    local targetCFrame = stringToCFrame(WEALTHY)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2 -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main_tp:CreateButton("old g",function()

    local targetCFrame = stringToCFrame(normOLD_GOOD)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2  -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main_tp:CreateButton("overgrown g",function()

    local targetCFrame = stringToCFrame(OVERGROWN_GOOD)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2  -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main_tp:CreateButton("miserable g",function()

    local targetCFrame = stringToCFrame(MISERABLE_GOOD)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2  -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main_tp:CreateButton("frozen g",function()

    local targetCFrame = stringToCFrame(ICE_GOOD)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2  -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main_tp:CreateButton("hateful g",function()

    local targetCFrame = stringToCFrame(HATEFUL_GOOD)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2  -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main_tp:CreateButton("peace island",function()

    local targetCFrame = stringToCFrame(PEACE)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2  -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main_tp:CreateButton("island",function()

    local targetCFrame = stringToCFrame(ISLAND)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2  -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main_tp:CreateButton("gold island",function()

    local targetCFrame = stringToCFrame(GOLD)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2  -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main_tp:CreateButton("crystal island",function()

    local targetCFrame = stringToCFrame(CRYSTAL)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2  -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main_tp:CreateButton("magnetite cave",function()

    local targetCFrame = stringToCFrame(MAG)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2  -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)

main_tp:CreateButton("emerald cave", function()

local targetCFrame = stringToCFrame(EMERALD)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2  -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()


end)

main_tp:CreateButton("pink diamond island",function()

    local targetCFrame = stringToCFrame(PINKDIM)

    local tolerance = 0.5  -- How close to the target CFrame you need to be to stop teleporting
    local teleportDelay = 0.000001  -- Delay between teleports
    local teleportDuration = 2  -- Duration to keep teleporting in seconds

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local startTime = tick()  -- Record the start time

    local function isCloseToTarget()
        local distance = (humanoidRootPart.Position - targetCFrame.Position).magnitude
        return distance < tolerance
    end

    local function teleportToTarget()
        while tick() - startTime < teleportDuration do
            if not isCloseToTarget() then
                humanoidRootPart.CFrame = targetCFrame
            end
            wait(teleportDelay)
        end
    end

teleportToTarget()

end)


else
    print('player is in different mode, loading init script')
end


server_hop:CreateSubDivider("server hop(s)")

server_hop:CreateButton("void (TELEPORTS YOU)",function()
    -- Teleports player to void

    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    -- The Place ID of the game you want to teleport to
    local destinationPlaceId = 18629058177

    -- Teleport the player
    TeleportService:Teleport(destinationPlaceId, player) 
end)

server_hop:CreateButton("normal map (TELEPORTS YOU)",function()

-- Teleports player to og

    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    -- The Place ID of the game you want to teleport to
    local destinationPlaceId = 18629053284

    -- Teleport the player
    TeleportService:Teleport(destinationPlaceId, player) 
end)

--all normal teleports

main:CreateSubDivider('build/place')

main:CreateButton("wood fullbox",function(s)
    -- Fetch the player and their character
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    -- Get the position of the LowerTorso
    local lowerTorso = character:WaitForChild("LowerTorso")
    local pos = lowerTorso.Position

    -- Define the distance for the box
    local boxWidth = 30  -- Increased width for a larger box
    local boxHeight = 10  -- Adjust as needed for the height of the box

    -- Define the ReplicatedStorage event
    local placeStructureEvent = game:GetService("ReplicatedStorage").Events.PlaceStructure

    -- Create a function to place a wall with debugging and delay
    local function placeWall(name, position, orientation)
        local wallCFrame = CFrame.new(position) * orientation
        placeStructureEvent:FireServer(name, wallCFrame, 0)
        print("Placed wall:", name, "at", position, "with orientation", orientation)  -- Debugging output
    end

    -- Calculate the offset for placing walls
    local halfWidth = boxWidth / 2

    -- Define the positions and orientations for the four walls
    local frontWallPos = pos + Vector3.new(0, -2.5, -halfWidth) -- Front wall
    local backWallPos = pos + Vector3.new(0, -2.5, halfWidth)  -- Back wall
    local leftWallPos = pos + Vector3.new(-halfWidth, -2.5, 0) -- Left wall
    local rightWallPos = pos + Vector3.new(halfWidth, -2.5, 0) -- Right wall

    -- Define orientations based on wall positions
    local frontWallOrientation = CFrame.Angles(0, math.pi, 0)   -- Front wall facing player
    local backWallOrientation = CFrame.Angles(0, 0, 0)          -- Back wall facing away
    local leftWallOrientation = CFrame.Angles(0, -math.pi / 2, 0) -- Left wall facing player
    local rightWallOrientation = CFrame.Angles(0, math.pi / 2, 0) -- Right wall facing player

    -- Place the four walls around the player with a shorter delay
    local delay = 0.175  -- Shorter delay in seconds

    -- Function to place walls with delay
    local function placeWallsWithDelay()
        placeWall("Wood Wall", frontWallPos, frontWallOrientation)
        wait(delay)  -- Wait before placing the next wall
        placeWall("Wood Wall", backWallPos, backWallOrientation)
        wait(delay)  -- Wait before placing the next wall
        placeWall("Wood Wall", leftWallPos, leftWallOrientation)
        wait(delay)  -- Wait before placing the next wall
        placeWall("Wood Wall", rightWallPos, rightWallOrientation)
    end

    -- Execute the function to place walls
    placeWallsWithDelay()
end)


main:CreateButton("plant 3by3 plantboxes",function()
-- Client-Side Script

-- Get the player's current position
local player = game.Players.LocalPlayer
local char = player.Character
local lowerTorso = char and char:FindFirstChild("LowerTorso")
if not lowerTorso then
    warn("LowerTorso not found in player's character.")
    return
end

local position = lowerTorso.Position

-- Set the spacing for the 3x3 grid
local spacing = 7 -- Updated spacing value

-- The event and parameters
local event = game:GetService("ReplicatedStorage").Events:WaitForChild("PlaceStructure")
local boxName = "Plant Box"
local parameter = 0 -- Adjust this if necessary for your server

-- Define grid positions relative to the center
local positions = {
    {x = -spacing, z = -spacing},
    {x = 0, z = -spacing},
    {x = spacing, z = -spacing},
    {x = -spacing, z = 0},
    {x = 0, z = 0},
    {x = spacing, z = 0},
    {x = -spacing, z = spacing},
    {x = 0, z = spacing},
    {x = spacing, z = spacing}
}

-- Function to place a box at a specified position
local function placeBox(index, posX, posY, posZ)
    local boxCFrame = CFrame.new(posX, posY, posZ)
    
    -- Print position for debugging
    print(string.format("Attempting to place box %d at: X=%.2f, Y=%.2f, Z=%.2f", index, posX, posY, posZ))
    
    -- Fire the server event to place the plant box
    local success, errorMsg = pcall(function()
        event:FireServer(boxName, boxCFrame, parameter)
    end)
    
    -- Print result of placement attempt
    if success then
        print(string.format("Successfully sent placement request for box %d", index))
    else
        warn(string.format("Failed to send placement request for box %d: %s", index, errorMsg))
    end
end

-- Function to validate and place boxes in the grid
local function placeBoxesInGrid()
    print("Starting to place boxes...")
    
    for i, pos in ipairs(positions) do
        local posX = position.x + pos.x
        local posY = position.y - 2.5 -- Adjust this value if needed
        local posZ = position.z + pos.z
        
        -- Print calculated position for debugging
        print(string.format("Calculated position for box %d: X=%.2f, Y=%.2f, Z=%.2f", i, posX, posY, posZ))
        
        -- Place the box
        placeBox(i, posX, posY, posZ)
        
        -- Increase delay between requests to ensure server processing
        wait(1) -- Adjust delay if needed
    end
    
    print("Finished attempting to place all boxes.")
end

-- Start placing boxes
placeBoxesInGrid()

end)

local placeID = game.PlaceId

if placeID == 18629058177 then
    print('void content')
    print('void content_loaded')
    main:CreateSubDivider('auto farm/features')
    main:CreateCheckBox('void rock autofarm soon?')

        -- Local Script (Client)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local checkDistance = 20 -- Distance to check for nearby objects
    local pickupEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Pickup")
    local autoPickupEnabled = false

    -- Recursive function to find all relevant objects: Part, UnionOperation, and MeshPart
    local function findRelevantObjects(parent)
        local objects = {}
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("Part") or child:IsA("UnionOperation") or child:IsA("MeshPart") then
                table.insert(objects, child)
            elseif child:IsA("Model") then
                for _, obj in pairs(findRelevantObjects(child)) do
                    table.insert(objects, obj)
                end
            end
        end
        return objects
    end

    -- Function to print and pick up nearby objects within a specified distance
    local function handleNearbyObjects()
        local myPos = humanoidRootPart.Position
        local itemsFolder = workspace:FindFirstChild("Important") and workspace.Important:FindFirstChild("Items")

        -- Check if the items folder exists
        if not itemsFolder then
            print("Items folder not found!")
            return
        end

        print("Items folder found. Checking objects...")

        local foundAny = false
        local objects = findRelevantObjects(itemsFolder)

        -- Iterate through all found objects
        for _, obj in pairs(objects) do
            local Pos = obj.Position
            local Distance = (myPos - Pos).magnitude

            -- Check if the object is within the specified distance
            if Distance <= checkDistance then
                -- Print object details
                print("Nearby Object found:", obj.Name, "at distance:", Distance, "ClassName:", obj.ClassName)
                
                -- Fire the Pickup event to pick up the object
                pickupEvent:FireServer(obj)
                print("Attempting to pick up:", obj.Name)
                
                foundAny = true
            end
        end

        -- Message if no objects are found nearby
        if not foundAny then
            print("No nearby objects within distance:", checkDistance)
        end
    end

    -- Function to toggle auto pickup based on checkbox state
    local function toggleAutoPickup(enabled)
        autoPickupEnabled = enabled
        if autoPickupEnabled then
            print("Auto pickup enabled.")
            while autoPickupEnabled do
                handleNearbyObjects()
                wait(1) -- Adjust the wait time as needed
            end
        else
            print("Auto pickup disabled.")
        end
    end

    -- Setup the checkbox UI to enable/disable auto pickup
    main:CreateCheckBox("auto pickup", function(isEnabled)
        toggleAutoPickup(isEnabled)
    end)
    else
    if placeID == 18629053284 then
        print('player is in normal content')
    end
end

if placeID == 18629062294 then
    print('civ content')
    print('civ content_loaded')
    main:CreateSubDivider('auto farm/features')

        -- Local Script (Client)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local checkDistance = 20 -- Distance to check for nearby objects
    local pickupEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Pickup")
    local autoPickupEnabled = false

    -- Recursive function to find all relevant objects: Part, UnionOperation, and MeshPart
    local function findRelevantObjects(parent)
        local objects = {}
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("Part") or child:IsA("UnionOperation") or child:IsA("MeshPart") then
                table.insert(objects, child)
            elseif child:IsA("Model") then
                for _, obj in pairs(findRelevantObjects(child)) do
                    table.insert(objects, obj)
                end
            end
        end
        return objects
    end

    -- Function to print and pick up nearby objects within a specified distance
    local function handleNearbyObjects()
        local myPos = humanoidRootPart.Position
        local itemsFolder = workspace:FindFirstChild("Important") and workspace.Important:FindFirstChild("Items")

        -- Check if the items folder exists
        if not itemsFolder then
            print("Items folder not found!")
            return
        end

        print("Items folder found. Checking objects...")

        local foundAny = false
        local objects = findRelevantObjects(itemsFolder)

        -- Iterate through all found objects
        for _, obj in pairs(objects) do
            local Pos = obj.Position
            local Distance = (myPos - Pos).magnitude

            -- Check if the object is within the specified distance
            if Distance <= checkDistance then
                -- Print object details
                print("Nearby Object found:", obj.Name, "at distance:", Distance, "ClassName:", obj.ClassName)
                
                -- Fire the Pickup event to pick up the object
                pickupEvent:FireServer(obj)
                print("Attempting to pick up:", obj.Name)
                
                foundAny = true
            end
        end

        -- Message if no objects are found nearby
        if not foundAny then
            print("No nearby objects within distance:", checkDistance)
        end
    end

    -- Function to toggle auto pickup based on checkbox state
    local function toggleAutoPickup(enabled)
        autoPickupEnabled = enabled
        if autoPickupEnabled then
            print("Auto pickup enabled.")
            while autoPickupEnabled do
                handleNearbyObjects()
                wait(1) -- Adjust the wait time as needed
            end
        else
            print("Auto pickup disabled.")
        end
    end

    -- Setup the checkbox UI to enable/disable auto pickup
    main:CreateCheckBox("auto pickup", function(isEnabled)
        toggleAutoPickup(isEnabled)
    end)
    else
    if placeID == 18629062294 then
        print('player is in normal civ')
    end
end

if placeID == 18629053284 then
    print('normal content')
    print('normal content_loaded')

        -- Reference to the folder containing all Gold Nodes
    local goldnodeFolder = game.Workspace.Map.Resources["Gold Node"]

    -- Initialize toggle state
    local isAutoGoldNodeActive = false
    local teleportToNewNodeIfUnavailable = true  -- Ensure this variable is defined

    -- Function to find the highest point of a goldNode
    local function getHighestPoint(node)
        local highestPoint = node.PrimaryPart.Position
        local parts = node:GetDescendants()
        for _, part in ipairs(parts) do
            if part:IsA("BasePart") then
                local partTop = part.Position + part.Size / 2
                if partTop.Y > highestPoint.Y then
                    highestPoint = partTop
                end
            end
        end
        return highestPoint
    end

    -- Function to get a list of all gold nodes
    local function getGoldNodes()
        local goldNodes = {}
        for _, goldNode in ipairs(goldnodeFolder:GetChildren()) do
            if goldNode:IsA("Model") and goldNode.PrimaryPart then
                table.insert(goldNodes, goldNode)
            end
        end
        return goldNodes
    end

    -- Function to find a new valid gold node if the current one is not available
    local function findNewValidNode()
        local goldNodes = getGoldNodes()

        -- Loop until we find a new valid node
        while #goldNodes > 0 do
            local randomIndex = math.random(1, #goldNodes)
            local newGoldNode = goldNodes[randomIndex]

            -- Ensure the new goldNode has a 'Health' IntValue
            local healthValue = newGoldNode:FindFirstChild("Health")
            if newGoldNode and newGoldNode.PrimaryPart and healthValue and healthValue:IsA("IntValue") then
                local highestPoint = getHighestPoint(newGoldNode)
                return newGoldNode, highestPoint
            else
                table.remove(goldNodes, randomIndex)
            end
        end
        return nil, nil
    end

    -- Function to teleport the player to a valid gold node
    local function teleportToValidGoldNode()
        local player = game.Players.LocalPlayer
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            warn("Player or player's character is not found")
            return
        end

        local humanoidRootPart = player.Character.HumanoidRootPart

        while isAutoGoldNodeActive do
            local goldNodes = getGoldNodes()

            if #goldNodes == 0 then
                print("No gold nodes available.")
                wait(10)  -- Wait before checking again to avoid excessive checks
                goldNodes = getGoldNodes()  -- Refresh the list of gold nodes
                continue
            end

            -- Select a random goldNode
            local randomIndex = math.random(1, #goldNodes)
            local currentGoldNode = goldNodes[randomIndex]

            -- Teleport player to the top of the current goldNode
            local highestPoint = getHighestPoint(currentGoldNode)
            humanoidRootPart.CFrame = CFrame.new(highestPoint)
            print("Teleported to gold node:", currentGoldNode.Name)

            -- Access the Health IntValue to check HP
            local healthValue = currentGoldNode:FindFirstChild("Health")
            if healthValue and healthValue:IsA("IntValue") then
                -- Wait until the health is 25 or lower
                while healthValue.Value > 25 do
                    wait(1)  -- Check every second
                    healthValue = currentGoldNode:FindFirstChild("Health")
                    if not healthValue or not healthValue:IsA("IntValue") then
                        warn("Health IntValue not found or removed for node", currentGoldNode.Name)
                        break
                    end
                end

                -- If health is 25 or lower, wait for an additional 4 seconds
                if healthValue and healthValue.Value <= 25 then
                    print("Gold node", currentGoldNode.Name, "is at or below 25 HP. Waiting for 4 seconds...")
                    wait(4)  -- Wait for 4 seconds before moving to the next node

                    -- Remove the current goldNode from the list
                    table.remove(goldNodes, randomIndex)
                    
                    -- Find and teleport to a new valid gold node if necessary
                    if teleportToNewNodeIfUnavailable then
                        local newGoldNode, newHighestPoint = findNewValidNode()
                        if newGoldNode then
                            -- Teleport to the new valid node
                            humanoidRootPart.CFrame = CFrame.new(newHighestPoint)
                            print("Teleported to new valid gold node:", newGoldNode.Name)
                        else
                            print("No new valid gold nodes found.")
                        end
                    else
                        print("Teleport to new node is disabled.")
                    end
                end
            else
                warn("No Health IntValue found for goldNode:", currentGoldNode.Name)
            end
        end

        print("All gold nodes have been visited or depleted.")
    end

    -- Function to start or stop the auto gold node feature based on checkbox
    local function toggleAutoGoldNodeFeature(toggle)
        isAutoGoldNodeActive = toggle

        if isAutoGoldNodeActive then
            print("Auto Gold Node feature enabled.")
            teleportToValidGoldNode()
        else
            print("Auto Gold Node feature disabled.")
        end
    end

    -- Checkbox setup
    --main:CreateSubDivider('auto farm/auto features')

    local ironNodeFolder = game.Workspace.Map.Resources["Iron Node"]

-- Initialize toggle state
local isAutoIronNodeActive = false
local teleportToNewNodeIfUnavailable = true  -- Ensure this variable is defined

-- Function to find the highest point of an ironNode
local function getHighestPoint(node)
    local highestPoint = node.PrimaryPart.Position
    local parts = node:GetDescendants()
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then
            local partTop = part.Position + part.Size / 2
            if partTop.Y > highestPoint.Y then
                highestPoint = partTop
            end
        end
    end
    return highestPoint
end

-- Function to get a list of all iron nodes
local function getIronNodes()
    local ironNodes = {}
    for _, ironNode in ipairs(ironNodeFolder:GetChildren()) do
        if ironNode:IsA("Model") and ironNode.PrimaryPart then
            table.insert(ironNodes, ironNode)
        end
    end
    return ironNodes
end

-- Function to find a new valid iron node if the current one is not available
local function findNewValidNode()
    local ironNodes = getIronNodes()

    -- Loop until we find a new valid node
    while #ironNodes > 0 do
        local randomIndex = math.random(1, #ironNodes)
        local newIronNode = ironNodes[randomIndex]

        -- Ensure the new ironNode has a 'Health' IntValue
        local healthValue = newIronNode:FindFirstChild("Health")
        if newIronNode and newIronNode.PrimaryPart and healthValue and healthValue:IsA("IntValue") then
            local highestPoint = getHighestPoint(newIronNode)
            return newIronNode, highestPoint
        else
            table.remove(ironNodes, randomIndex)
        end
    end
    return nil, nil
end

-- Function to teleport the player to a valid iron node
local function teleportToValidIronNode()
    local player = game.Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        warn("Player or player's character is not found")
        return
    end

    local humanoidRootPart = player.Character.HumanoidRootPart

    while isAutoIronNodeActive do
        local ironNodes = getIronNodes()

        if #ironNodes == 0 then
            print("No iron nodes available.")
            wait(10)  -- Wait before checking again to avoid excessive checks
            ironNodes = getIronNodes()  -- Refresh the list of iron nodes
            continue
        end

        -- Select a random ironNode
        local randomIndex = math.random(1, #ironNodes)
        local currentIronNode = ironNodes[randomIndex]

        -- Teleport player to the top of the current ironNode
        local highestPoint = getHighestPoint(currentIronNode)
        humanoidRootPart.CFrame = CFrame.new(highestPoint)
        print("Teleported to iron node:", currentIronNode.Name)

        -- Access the Health IntValue to check HP
        local healthValue = currentIronNode:FindFirstChild("Health")
        if healthValue and healthValue:IsA("IntValue") then
            -- Wait until the health is 25 or lower
            while healthValue.Value > 25 do
                wait(1)  -- Check every second
                healthValue = currentIronNode:FindFirstChild("Health")
                if not healthValue or not healthValue:IsA("IntValue") then
                    warn("Health IntValue not found or removed for node", currentIronNode.Name)
                    break
                end
            end

            -- If health is 25 or lower, wait for an additional 4 seconds
            if healthValue and healthValue.Value <= 25 then
                print("Iron node", currentIronNode.Name, "is at or below 25 HP. Waiting for 4 seconds...")
                wait(4)  -- Wait for 4 seconds before moving to the next node

                -- Remove the current ironNode from the list
                table.remove(ironNodes, randomIndex)
                
                -- Find and teleport to a new valid iron node if necessary
                if teleportToNewNodeIfUnavailable then
                    local newIronNode, newHighestPoint = findNewValidNode()
                    if newIronNode then
                        -- Teleport to the new valid node
                        humanoidRootPart.CFrame = CFrame.new(newHighestPoint)
                        print("Teleported to new valid iron node:", newIronNode.Name)
                    else
                        print("No new valid iron nodes found.")
                    end
                else
                    print("Teleport to new node is disabled.")
                end
            end
        else
            warn("No Health IntValue found for ironNode:", currentIronNode.Name)
        end
    end

    print("All iron nodes have been visited or depleted.")
end

-- Function to start or stop the auto iron node feature based on checkbox
local function toggleAutoIronNodeFeature(toggle)
    isAutoIronNodeActive = toggle

    if isAutoIronNodeActive then
        print("Auto Iron Node feature enabled.")
        teleportToValidIronNode()
    else
        print("Auto Iron Node feature disabled.")
    end
end

-- Checkbox setup
main:CreateSubDivider('auto farm/auto features')
main:CreateCheckBox("auto iron node", function(s)
    toggleAutoIronNodeFeature(s)
end)

    main:CreateCheckBox("auto gold node", function(s)
        toggleAutoGoldNodeFeature(s)
    end)

    -- Reference to the folder containing all Crystal Lodes
    local crystalLodeFolder = game.Workspace.Map.Resources:FindFirstChild("Crystal Lode")

    -- Initialize toggle state
    local isAutoCrystalLodeActive = false
    local teleportToNewLodeIfUnavailable = true  -- Ensure this variable is defined

    -- Function to find the highest point of a crystal lode
    local function getHighestPoint(node)
        local highestPoint = node.PrimaryPart.Position
        local parts = node:GetDescendants()
        for _, part in ipairs(parts) do
            if part:IsA("BasePart") then
                local partTop = part.Position + part.Size / 2
                if partTop.Y > highestPoint.Y then
                    highestPoint = partTop
                end
            end
        end
        return highestPoint
    end

    -- Function to get a list of all crystal lodes
    local function getCrystalLodes()
        local crystalLodes = {}
        if crystalLodeFolder then
            for _, crystalLode in ipairs(crystalLodeFolder:GetChildren()) do
                if crystalLode:IsA("Model") and crystalLode.PrimaryPart then
                    -- Ensure the lode is specifically a "Crystal Lode"
                    if crystalLode.Name == "Crystal Lode" then
                        table.insert(crystalLodes, crystalLode)
                    end
                end
            end
        else
            warn("Crystal Lode folder not found in Workspace.")
        end
        return crystalLodes
    end

    -- Function to find a new valid crystal lode if the current one is not available
    local function findNewValidLode()
        local crystalLodes = getCrystalLodes()

        -- Loop until we find a new valid lode
        while #crystalLodes > 0 do
            local randomIndex = math.random(1, #crystalLodes)
            local newCrystalLode = crystalLodes[randomIndex]

            -- Ensure the new crystalLode has a 'Health' IntValue
            local healthValue = newCrystalLode:FindFirstChild("Health")
            if newCrystalLode and newCrystalLode.PrimaryPart and healthValue and healthValue:IsA("IntValue") then
                local highestPoint = getHighestPoint(newCrystalLode)
                return newCrystalLode, highestPoint
            else
                table.remove(crystalLodes, randomIndex)
            end
        end
        return nil, nil
    end

    -- Function to teleport the player to a valid crystal lode
    local function teleportToValidCrystalLode()
        local player = game.Players.LocalPlayer
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            warn("Player or player's character is not found")
            return
        end

        local humanoidRootPart = player.Character.HumanoidRootPart

        while isAutoCrystalLodeActive do
            local crystalLodes = getCrystalLodes()

            if #crystalLodes == 0 then
                print("No crystal lodes available.")
                wait(10)  -- Wait before checking again to avoid excessive checks
                crystalLodes = getCrystalLodes()  -- Refresh the list of crystal lodes
                continue
            end

            -- Select a random crystalLode
            local randomIndex = math.random(1, #crystalLodes)
            local currentCrystalLode = crystalLodes[randomIndex]

            -- Teleport player to the top of the current crystalLode
            local highestPoint = getHighestPoint(currentCrystalLode)
            humanoidRootPart.CFrame = CFrame.new(highestPoint)
            print("Teleported to crystal lode:", currentCrystalLode.Name)

            -- Access the Health IntValue to check HP
            local healthValue = currentCrystalLode:FindFirstChild("Health")
            if healthValue and healthValue:IsA("IntValue") then
                -- Wait until the health is 75 or lower
                while healthValue.Value > 75 do
                    wait(1)  -- Check every second
                    healthValue = currentCrystalLode:FindFirstChild("Health")
                    if not healthValue or not healthValue:IsA("IntValue") then
                        warn("Health IntValue not found or removed for lode", currentCrystalLode.Name)
                        break
                    end
                end

                -- If health is 75 or lower, wait for an additional 8 seconds
                if healthValue and healthValue.Value <= 75 then
                    print("Crystal lode", currentCrystalLode.Name, "is at or below 75 HP. Waiting for 8 seconds...")
                    wait(8)  -- Wait for 8 seconds before moving to the next lode

                    -- Remove the current crystalLode from the list
                    table.remove(crystalLodes, randomIndex)
                    
                    -- Find and teleport to a new valid crystal lode if necessary
                    if teleportToNewLodeIfUnavailable then
                        local newCrystalLode, newHighestPoint = findNewValidLode()
                        if newCrystalLode then
                            -- Teleport to the new valid lode
                            humanoidRootPart.CFrame = CFrame.new(newHighestPoint)
                            print("Teleported to new valid crystal lode:", newCrystalLode.Name)
                        else
                            print("No new valid crystal lodes found.")
                        end
                    else
                        print("Teleport to new lode is disabled.")
                    end
                end
            else
                warn("No Health IntValue found for crystalLode:", currentCrystalLode.Name)
            end
        end

        print("All crystal lodes have been visited or depleted.")
    end

    -- Function to start or stop the auto crystal lode feature based on checkbox
    local function toggleAutoCrystalLodeFeature(toggle)
        isAutoCrystalLodeActive = toggle

        if isAutoCrystalLodeActive then
            print("Auto Crystal Lode feature enabled.")
            spawn(function()  -- Use spawn to run teleportToValidCrystalLode in a separate thread
                teleportToValidCrystalLode()
            end)
        else
            print("Auto Crystal Lode feature disabled.")
            isAutoCrystalLodeActive = false  -- Ensure it stops if toggled off
        end
    end

    -- Checkbox setup
    main:CreateCheckBox("auto crystal lode", function(s)
        toggleAutoCrystalLodeFeature(s)
    end)

    -- Local Script (Client)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local checkDistance = 20 -- Distance to check for nearby objects
    local pickupEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Pickup")
    local autoPickupEnabled = false

    -- Recursive function to find all relevant objects: Part, UnionOperation, and MeshPart
    local function findRelevantObjects(parent)
        local objects = {}
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("Part") or child:IsA("UnionOperation") or child:IsA("MeshPart") then
                table.insert(objects, child)
            elseif child:IsA("Model") then
                for _, obj in pairs(findRelevantObjects(child)) do
                    table.insert(objects, obj)
                end
            end
        end
        return objects
    end

    -- Function to print and pick up nearby objects within a specified distance
    local function handleNearbyObjects()
        local myPos = humanoidRootPart.Position
        local itemsFolder = workspace:FindFirstChild("Important") and workspace.Important:FindFirstChild("Items")

        -- Check if the items folder exists
        if not itemsFolder then
            print("Items folder not found!")
            return
        end

        print("Items folder found. Checking objects...")

        local foundAny = false
        local objects = findRelevantObjects(itemsFolder)

        -- Iterate through all found objects
        for _, obj in pairs(objects) do
            local Pos = obj.Position
            local Distance = (myPos - Pos).magnitude

            -- Check if the object is within the specified distance
            if Distance <= checkDistance then
                -- Print object details
                print("Nearby Object found:", obj.Name, "at distance:", Distance, "ClassName:", obj.ClassName)
                
                -- Fire the Pickup event to pick up the object
                pickupEvent:FireServer(obj)
                print("Attempting to pick up:", obj.Name)
                
                foundAny = true
            end
        end

        -- Message if no objects are found nearby
        if not foundAny then
            print("No nearby objects within distance:", checkDistance)
        end
    end

    -- Function to toggle auto pickup based on checkbox state
    local function toggleAutoPickup(enabled)
        autoPickupEnabled = enabled
        if autoPickupEnabled then
            print("Auto pickup enabled.")
            while autoPickupEnabled do
                handleNearbyObjects()
                wait(1) -- Adjust the wait time as needed
            end
        else
            print("Auto pickup disabled.")
        end
    end

    -- Setup the checkbox UI to enable/disable auto pickup
    main:CreateCheckBox("auto pickup", function(isEnabled)
        toggleAutoPickup(isEnabled)
    end)

    else
    if placeID == 18629058177 then
        print('player is in void')
    end
end


main:CreateSubDivider('extra scripts')

main:CreateButton("infinite yield (admin script)",function()

    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

end)

extra:CreateSubDivider("script created by lohjc")

return roblo_lib
