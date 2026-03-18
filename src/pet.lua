local Pet = {}
Pet.__index = Pet

function Pet.new(name, type)
  local self = setmetatable({}, Pet)
  self.name = name or "Buddy"
  self.type = type or "Pet"
  self.max = 100
  self.hunger = 100
  self.happiness = 100
  self.energy = 100
  self.alive = true
  return self
end

function Pet:update(dt)
  if not self.alive then return end
  -- decay rates per second
  self.hunger = self.hunger - 6 * dt
  self.happiness = self.happiness - 2 * dt
  self.energy = self.energy - 3 * dt
  if self.hunger <= 0 or self.happiness <= 0 or self.energy <= 0 then
    self.hunger = math.max(0, self.hunger)
    self.happiness = math.max(0, self.happiness)
    self.energy = math.max(0, self.energy)
    self.alive = false
  end
end

function Pet:feed()
  if not self.alive then return end
  self.hunger = math.min(self.max, self.hunger + 30)
  self.energy = math.max(0, self.energy - 5)
  self.happiness = math.min(self.max, self.happiness + 5)
end

function Pet:play()
  if not self.alive then return end
  self.happiness = math.min(self.max, self.happiness + 25)
  self.energy = math.max(0, self.energy - 20)
  self.hunger = math.max(0, self.hunger - 10)
end

function Pet:sleep()
  if not self.alive then return end
  self.energy = math.min(self.max, self.energy + 40)
  self.hunger = math.max(0, self.hunger - 8)
end

return Pet
