-- This file is for use with quick-cocos2d-x framework
-- https://github.com/dualface/quick-cocos2d-x
-- bugFixed by ChildhoodAndy on 2014/02/01
-- This file is automatically generated with PhysicsEdtior (http://physicseditor.de). Do not edit
--
-- Usage example:
--			local scaleFactor = 1.0
--			local physicsData = require("shapedefs").physicsData(scaleFactor)
--			local shape = display.newSprite("objectname.png")
--          physics.bindBody(shape, physicsData:get("objectname"))
--

-- copy needed functions to local scope
local pairs = pairs
local ipairs = ipairs

local M = {}

function M.physicsData(scale)
    local physics = {data = {}}

    {% for body in bodies %}

    physics.data["{{body.name}}"] = {
        anchorpoint = { {{body.anchorPointRel.x|floatformat:5}},{{body.anchorPointRel.y|floatformat:5}} },
        shapes = {
            {% for shape in body.fixtures %}
            {
                mass = {{shape.mass}},
                elasticity = {{shape.elasticity}},
                friction = {{shape.friction}},
                surface_velocity = { {{shape.surface_velocity_x|floatformat:5}},{{shape.surface_velocity_y|floatformat:5}} },
                layers = {{shape.layers}},
                group = {{shape.group}},
                collision_type = {{shape.collision_type}},
                isSensor = {% if shape.isSensor %}true{% else %}false{% endif %},
                shape_type = "{{shape.type}}",
                {% if shape.isCircle %}
                radius = {{shape.radius|floatformat:3}},
                position = { {{shape.center.x|floatformat:3}},{{shape.center.y|floatformat:3}} }
                {% else %}
                polygons = {
                    {% for polygon in shape.polygons %}
                    {{% for point in polygon %}{{point.x|floatformat:5}}, {{point.y|floatformat:5}}, {% endfor %}},
                    {% endfor %}
                }
                {% endif %}
            },
            {% endfor %}
        },
    }

    {% endfor %}

    -- apply scale factor
    local s = scale or 1.0
    for bi, body in pairs(physics.data) do
        for fi, shape in ipairs(body.shapes) do
            if shape.polygons then
                for ci, coordinate in ipairs(shape.polygons) do
                    for i, point in ipairs(coordinate) do
                        point = s * point
                    end
                end

            else
                shape.radius = s * shape.radius
            end
        end
    end

    function physics:get(name)
        return self.data[name]
    end

    return physics
end

return M
