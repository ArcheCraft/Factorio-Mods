---@class ArgumentBuilder
---Handles positional and named arguments
local arguments = {}

---Defines arguments for a function. Use the returned object to parse a table into your arguments.
---@param args string[] The argument names for the function
function arguments.define(args)
    ---@class DefinedArguments
    local def = {}
    local size = #args

    local function parse(remaining_args, index, parsed)
        if index > size then
            return
        end

        local arg_name = args[index]
        local arg
        if remaining_args[arg_name] ~= nil then
            arg = remaining_args[arg_name]
        else
            arg = remaining_args[parsed]
            parsed = parsed + 1
        end

        return arg, parse(remaining_args, index + 1, parsed)
    end

    ---Parse the given arguments into a table with keys coresponding to the defined argument list
    ---@param call_args table Ther arguments as passed to the function
    ---@return table<string, any>
    function def:parse(call_args)
        return parse(call_args, 1, 1)
    end

    return def
end

return arguments