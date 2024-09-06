local button = script.Parent
local screenGui = script.Parent.Parent
local textBox = screenGui:WaitForChild("TextBox") -- Supondo que o TextBox esteja na ScreenGui
local player = game.Players.LocalPlayer
local flying = false
local speed = 50  -- Velocidade padrão do voo
local bodyVelocity = nil

-- Função para atualizar a velocidade com base no valor do TextBox
local function updateSpeed()
    local newSpeed = tonumber(textBox.Text) -- Converte o texto do TextBox para número
    if newSpeed then
        speed = newSpeed
    else
        textBox.Text = "Número inválido" -- Mensagem de erro se o jogador inserir algo que não seja número
    end
end

-- Função para habilitar/desabilitar voo
local function toggleFly()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if flying then
        -- Desativa o voo
        flying = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    else
        -- Ativa o voo
        flying = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, speed, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Parent = humanoidRootPart
    end
end

-- Conecta o botão para ativar/desativar o voo
button.MouseButton1Click:Connect(toggleFly)

-- Atualizar a velocidade do voo quando o jogador alterar o valor no TextBox
textBox.FocusLost:Connect(updateSpeed)

-- Atualizar a direção do voo com base no movimento do jogador
game:GetService("RunService").RenderStepped:Connect(function()
    if flying and bodyVelocity then
        local moveDirection = Vector3.new(0, 0, 0)
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            moveDirection = humanoid.MoveDirection
        end

        bodyVelocity.Velocity = (moveDirection * speed) + Vector3.new(0, speed, 0)
    end
end)
