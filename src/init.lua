local toolbar = plugin:CreateToolbar("Bloxcode") -- create a new toolbar for your plugin
local pluginGui = plugin:CreateDockWidgetPluginGui(
	"MyPluginGui", DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Float, -- set the initial dock state of the window
		true, -- allow the window to be closed
		true, -- allow the window to be resized
		300, -- set the minimum width of the window
		200 -- set the minimum height of the window
	)
) -- create a new PluginGui object

local WORK_DURATION = 30 * 60
local BREAK_DURATION = 5 * 60
local INTERMISSION_DURATION = 5

local button = toolbar:CreateButton("Productivity", "Helps you increase your productivity using a timer!", "rbxassetid://xxxx") -- create a new button in the toolbar
local isOpen = false -- track whether the PluginGui is currently open
local isRunning = false
local remainingTime = WORK_DURATION
local currentState = "Work"

button.Click:Connect(function()
	isOpen = not isOpen -- toggle the value of isOpen
	pluginGui.Enabled = isOpen -- set the Enabled property of the PluginGui to the new value of isOpen
end)

-- Create a TextLabel element to display the timer
local timerLabel = Instance.new("TextLabel")
timerLabel.Parent = pluginGui
timerLabel.Size = UDim2.new(1, 0, 0, 50)
timerLabel.Position = UDim2.new(0, 0, 0.2, 0)
timerLabel.Font = Enum.Font.SourceSansBold
timerLabel.TextSize = 24
timerLabel.TextColor3 = Color3.new(1, 1, 1)
timerLabel.BackgroundTransparency = 1
timerLabel.TextXAlignment = Enum.TextXAlignment.Center

local startButton = Instance.new("TextButton")
startButton.Parent = pluginGui
startButton.Size = UDim2.new(0, 100, 0, 30)
startButton.Position = UDim2.new(0.5, -50, 0.5, 0)
startButton.Font = Enum.Font.SourceSansBold
startButton.TextSize = 18
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.BackgroundColor3 = Color3.fromRGB(255, 79, 79)
startButton.BorderSizePixel = 0
startButton.Text = "START"

local UICorner = Instance.new("UICorner", startButton)
UICorner.CornerRadius = UDim.new(0, 5)

function updateText()
	local hours = math.floor(remainingTime / 3600)
	local minutes = math.floor((remainingTime % 3600) / 60)
	local seconds = math.floor(remainingTime % 60)

	timerLabel.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

startButton.MouseButton1Click:Connect(function()
	isRunning = not isRunning
	
	startButton.Text = isRunning and "PAUSE" or "RESUME"
end)

updateText()

while true do
	local deltaTime = task.wait()

	if isRunning then
		remainingTime = math.max(0, remainingTime - deltaTime)

		updateText()
		
		if remainingTime == 0 then
			if currentState == "Work" then
				task.wait(1)
				
				timerLabel.Text = "Time for a break!"
				warn("Time for a break!")
				
				task.wait(INTERMISSION_DURATION - 1)
				
				isRunning = false
				startButton.Text = "OKAY"
				currentState = "Break"
				remainingTime = BREAK_DURATION
			elseif currentState == "Break" then
				task.wait(1)

				timerLabel.Text = "Time to work!"
				warn("Time to work!")
				
				task.wait(INTERMISSION_DURATION - 1)
				
				isRunning = false
				startButton.Text = "READY"
				currentState = "Work"
				remainingTime = WORK_DURATION
			end
		end
	end
end