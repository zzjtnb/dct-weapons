local Unit				= require('Mission.Unit')
local Factory			= require('Factory')
local ModuleProperty	= require('ModuleProperty')

local M = {
	construct = function(self, name, x, y, radius, id, properties)
		self:setName(name)
		self:setRadius(radius)
		self:setHidden(false)
		self:setColor(1, 1, 1, 0.15)
		self:setProperties(properties)
		
		Unit.construct(self, x, y, id)
	end
}
	
ModuleProperty.makeClonable(M)

ModuleProperty.make1arg(M,	'setName',		'getName',		'name')
ModuleProperty.make1arg(M,	'setRadius',	'getRadius',	'radius')
ModuleProperty.make1arg(M,	'setHidden',	'getHidden',	'hidden')
ModuleProperty.make1arg(M,	'setProperties',	'getProperties',	'properties')
ModuleProperty.make4arg(M,	'setColor',		'getColor',		'red', 'green', 'blue', 'alpha')

ModuleProperty.cloneBase(M, Unit)

return Factory.createClass(M, Unit)