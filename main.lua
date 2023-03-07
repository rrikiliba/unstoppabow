Gamestate = require 'lib/hump.gamestate' 
menu, game = {}, {}

data = {}
status = 0

function love.load()

  Gamestate.registerEvents()
  Gamestate.switch(menu)

end

function menu:init()

end

function game:init()

  world = require('lib/windfield/windfield').newWorld(0, 500)
  world:addCollisionClass('board')
  world:addCollisionClass('ground')
  world:addCollisionClass('limit')
  world:addCollisionClass('target')
  world:addCollisionClass('arrow')

  cam = require('lib/hump.camera')()

end

function menu:enter()

end

function game:enter()

  board = {}
    board.collider = world:newLineCollider(200, -768, 200, 768)
    board.collider:setType('static')
    board.collider:setCollisionClass('board')

  ground = {}
    ground.collider = world:newLineCollider(0, 768, 1024, 768)
    ground.collider:setType('static')
    ground.collider:setCollisionClass('ground')

  limit = {}
    limit.collider = world:newLineCollider(0, -2048, 0, 2048)
    limit.collider:setType('static')
    limit.collider:setCollisionClass('limit')

  target = {}
    target.collider = world:newCircleCollider(500, 700, 15)
    target.collider:setCollisionClass('target')
    target.sprite = love.graphics.newImage('assets/sprites/target00.png')
    target.rotation = 0

  arrow = {}
    arrow.collider = world:newCircleCollider(800, 730, 15)
    arrow.collider:setCollisionClass('arrow')
    arrow.sprite = love.graphics.newImage('assets/sprites/arrow.png')
    arrow.rotation = 0

  if status == 0 then
    status = 1
    target.collider:applyLinearImpulse(0, -2000)
  end

end

function game:leave()
  
  board.collider:destroy()
  arrow.collider:destroy()
  if target.collider ~= nil then
    target.collider:destroy()
  end
  status = 0

end

function love.update(dt)
  
end

function menu:keyreleased(key)

  if key == 'return' then
    Gamestate.switch(game)
  end
 
end

function game:update(dt)
  
  world:update(dt)

  if status < 3 then
    cam:lookAt(target.collider:getX(), target.collider:getY())
    arrow.collider:setY(target.collider:getY()+(arrow.collider:getX()-target.collider:getX())/2)
    if target.collider:enter('ground') then
      Gamestate.switch(menu)
    end
  else
    cam:lookAt(arrow.collider:getX(), arrow.collider:getY())
    if arrow.collider:enter('limit') then
      Gamestate.switch(menu)
    end
  end

  target.rotation = target.rotation + dt
  if status > 1 and status < 4 then 
    arrow.rotation = arrow.rotation - 0.005
    target.rotation = arrow.rotation
  end

  if arrow.collider:enter('target') then
    target.collider:destroy()
    target.collider = nil
    arrow.collider:applyLinearImpulse(0, -1000)
    status = 3
  end

  if arrow.collider:enter('board') then
    arrow.collider:setType('static')
    status = 4
  end

  if love.keyboard.isDown('space') then
    if status == 1 then
      arrow.collider:applyLinearImpulse(-3000, -3000)
      status = 2
    elseif status == 4 then
      Gamestate.switch(menu)
    end
    
  end

end

function love.draw()

end 

function menu:draw()
  
  local message = 'Press ENTER to continue'
  love.graphics.setFont(love.graphics.newFont(28))
  love.graphics.print(message, (love.graphics.getWidth()-love.graphics.getFont():getWidth(message))/2, love.graphics.getHeight()/3*2)

end

function game:draw()

  cam:attach()

    love.graphics.draw(arrow.sprite, arrow.collider:getX(), arrow.collider:getY(), arrow.rotation)
    if status < 3 then
      love.graphics.draw(target.sprite, target.collider:getX(), target.collider:getY(), target.rotation, nil, nil, target.sprite:getWidth()/2, target.sprite:getHeight()/2)
    end
    world:draw()

  cam:detach()

  love.graphics.setColor(1,0,0)
  local fps = string.format('%.0f', love.timer.getFPS())
  love.graphics.print(fps, love.graphics.getWidth() - love.graphics.getFont():getWidth(fps))
  love.graphics.setColor(1,1,1)
  
end

function data:read()
  --read csv/json file
end