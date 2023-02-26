world = require('lib/windfield/windfield').newWorld(0, 500)
  cam = require('lib/hump.camera')()
  Gamestate = require 'lib/hump.gamestate' 

menu, game = {}, {}

window = {}
window.width = love.graphics.getWidth()
window.height = love.graphics.getHeight()

function love.load()

  Gamestate.registerEvents()
  Gamestate.switch(menu)

end

function menu:init()

end

function game:init()

  board = {}

    board.collider = world:newLineCollider(window.width /5, 0, window.width /5, window.height)
    board.collider:setType('static')
    world:addCollisionClass('board')
    board.collider:setCollisionClass('board')

  target = {}

    world:addCollisionClass('target')
    target.collider = world:newCircleCollider(window.width /2, window.height *14 /15, window.height /45)
    target.collider:setCollisionClass('target')

  arrow = {}

    world:addCollisionClass('arrow')
    arrow.collider = world:newCircleCollider(window.width *4/5, target.collider:getY() *1.1, window.height /45)
    arrow.collider:setCollisionClass('arrow')

  target.collider:applyLinearImpulse(0, -2000)

end

function love.update(dt)
  
end

function menu:keyreleased(key)
  if key == 'space' then
    Gamestate.switch(game)
  end
end

function game:update(dt)
  
  world:update(dt)

  if love.keyboard.isDown('space') or love.keyboard.isDown('return') then
    arrow.collider:applyLinearImpulse(-200, -50)
    arrow.collider:applyAngularImpulse(0.2)
  end

  if arrow.collider:enter('target') then
    target.collider:destroy()
    target.collider = nil
  end

  if arrow.collider:enter('board') then
    arrow.collider:setType('static')
  end

  if target.collider ~= nil then
    cam:lookAt(target.collider:getX(), target.collider:getY())
    arrow.collider:setY(target.collider:getY() +30)
  else
    cam:lookAt(arrow.collider:getX(), arrow.collider:getY())
  end

end

function love.draw()

end 

function menu:draw()
  
  love.graphics.print("Press SPACE to continue")

end

function game:draw()
  
  cam:attach()

    world:draw()

  cam:detach()

end