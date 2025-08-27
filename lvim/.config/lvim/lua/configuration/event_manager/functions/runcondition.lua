local TypeSafe= {}

function TypeSafe.only_if()
 type(event.setup) == "function" 
end
