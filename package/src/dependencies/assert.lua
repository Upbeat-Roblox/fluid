--Lanred
--6/28/2023

--this is a assert wrapper but it only formats the string if the condition is false or nil

--//core
--main
return function(condition: any, errorMessage: string, ...: any): nil
	if condition ~= false and condition ~= nil then
		return
	end

	error(#{ ... } >= 1 and errorMessage:format(...) or errorMessage, 0)
end
