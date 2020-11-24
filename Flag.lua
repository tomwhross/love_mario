Flag = Class{}

function Flag:init(map)

    
    -- self.x = self.map.mapWidthPixels - 32
    -- self.y = self.map.mapHeightPixels / 2 - 48
    self.width = 16
    self.height = 16

    -- reference to map for checking tiles
    self.map = map
    self.texture = love.graphics.newImage('graphics/spritesheet.png')
    self.frames = {13, 14, 15}

    self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    self.sprites = generateQuads(self.spritesheet, 16, 16)

    -- current animation frame
    self.currentFrame = 13

    -- position on top of map tiles
    self.y = self.map.mapHeight / 2 * 16 - 80
    self.x = self.map.mapWidth * 16 - 32

    -- initialize all Flag animations
    self.animations = {
        ['waving'] = Animation({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(0, 48, 16, 16, self.texture:getDimensions()),
                love.graphics.newQuad(16, 48, 16, 16, self.texture:getDimensions()),
                love.graphics.newQuad(32, 48, 16, 16, self.texture:getDimensions()),
            },
            interval = 0.25
        })
    }

    -- initialize animation and current frame we should render
    self.animation = self.animations['waving']
    self.currentFrame = self.animation:getCurrentFrame()

    -- behavior map we can call based on Flag state
end

function Flag:update(dt)
    -- self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()

    if self.map.player:endGame() == true then
        if self.y <= self.map.player.y then
            self.y = self.y + 60 * dt
        end
    end

    if math.floor(self.y) >= math.floor(self.map.mapHeightPixels / 2)  - self.height * 2 + 4 then
        self.y = math.floor(self.map.mapHeightPixels / 2)  - self.height * 2 + 4
    end
    -- apply velocity
    -- self.y = self.y + self.dy * dt
end

function Flag:render()
    local scaleX

    -- set negative x scale factor if facing left, which will flip the sprite
    -- when applied
    if self.direction == 'right' then
        scaleX = 1
    else
        scaleX = -1
    end

    -- draw sprite with scale factor and offsets
    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x),
        math.floor(self.y))
end