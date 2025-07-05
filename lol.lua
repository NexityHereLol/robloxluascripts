local roblo_lib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function create(class, props, children)
	local inst = Instance.new(class)
	for k, v in pairs(props) do inst[k] = v end
	for _, c in ipairs(children or {}) do c.Parent = inst end
	return inst
end

local function addPadding(obj, pad)
	create("UIPadding", {
		Parent = obj,
		PaddingTop = UDim.new(0, pad),
		PaddingBottom = UDim.new(0, pad),
		PaddingLeft = UDim.new(0, pad),
		PaddingRight = UDim.new(0, pad)
	})
end

function roblo_lib:CreateLib(titleText)
	local lib = {}
	local gui = create("ScreenGui", {
		Name = "roblo_ui",
		ResetOnSpawn = false,
		Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	})

	local main = create("Frame", {
		Size = UDim2.new(0, 420, 0, 320),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(45, 45, 45),
		Active = true,
		Parent = gui
	})

	local top = create("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Color3.fromRGB(33, 149, 27),
		Parent = main
	})
	create("TextLabel", {
		Size = UDim2.new(1, -30, 1, 0),
		Position = UDim2.new(0, 5, 0, 0),
		Text = titleText,
		Font = Enum.Font.ArialBold,
		TextSize = 14,
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Parent = top
	})
	create("ImageButton", {
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(1, -25, 0.5, -10),
		Image = "rbxassetid://18114937392",
		BackgroundTransparency = 1,
		Parent = top
	}).MouseButton1Click:Connect(function()
		gui:Destroy()
	end)

	local dragging, dragStart, startPos
	top.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = i.Position
			startPos = main.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	local nav = create("Frame", {
		Size = UDim2.new(0, 120, 1, -30),
		Position = UDim2.new(0, 0, 0, 30),
		BackgroundColor3 = Color3.fromRGB(63, 63, 63),
		Parent = main
	})
	local tabList = create("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0, 0, 0, 1000),
		BackgroundTransparency = 1,
		Parent = nav
	})
	create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4),
		Parent = tabList
	})

	local content = create("Frame", {
		Size = UDim2.new(1, -130, 1, -40),
		Position = UDim2.new(0, 125, 0, 35),
		BackgroundTransparency = 1,
		Parent = main
	})

	local currentTab
	function lib:CreateTab(name, desc)
		local tabBtn = create("ImageButton", {
			Size = UDim2.new(1, -10, 0, 30),
			BackgroundColor3 = Color3.fromRGB(83, 83, 83),
			AutoButtonColor = false,
			Parent = tabList
		})
		create("TextLabel", {
			Text = name,
			Size = UDim2.new(1, 0, 1, 0),
			TextColor3 = Color3.new(1,1,1),
			Font = Enum.Font.Arial,
			TextSize = 14,
			BackgroundTransparency = 1,
			Parent = tabBtn
		})

		local tabContent = create("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 1000),
			ScrollBarThickness = 4,
			Visible = false,
			BackgroundTransparency = 1,
			Parent = content
		})
		create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
			Parent = tabContent
		})

		local tabApi = {}

		tabBtn.MouseButton1Click:Connect(function()
			for _, c in ipairs(content:GetChildren()) do if c:IsA("ScrollingFrame") then c.Visible = false end end
			if currentTab then currentTab.BackgroundColor3 = Color3.fromRGB(83,83,83) end
			tabBtn.BackgroundColor3 = Color3.fromRGB(63,63,63)
			tabContent.Visible = true
			currentTab = tabBtn
		end)

		function tabApi:CreateButton(text, callback)
			create("TextButton", {
				Text = text,
				Size = UDim2.new(1, -10, 0, 30),
				TextColor3 = Color3.new(1,1,1),
				Font = Enum.Font.Arial,
				TextSize = 14,
				BackgroundColor3 = Color3.fromRGB(60,60,60),
				Parent = tabContent
		 }).MouseButton1Click:Connect(function()
				pcall(callback)
			end)
		end

		function tabApi:CreateSubDivider(text)
			create("TextLabel", {
				Text = text,
				Size = UDim2.new(1, -10, 0, 20),
				Font = Enum.Font.ArialBold,
				TextSize = 13,
				TextColor3 = Color3.new(1,1,1),
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Parent = tabContent
			})
		end

		-- Auto-select first tab
		if not currentTab then
			tabBtn:Activate()
			tabBtn.BackgroundColor3 = Color3.fromRGB(63,63,63)
			tabContent.Visible = true
			currentTab = tabBtn
		end

		return tabApi
	end

	return lib
end

return roblo_lib
