local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj 
end)

--Callback de obtener las stats actuales
ESX.RegisterServerCallback("rhlm_habilidades:fetchStatus", function(source, cb)
     local src = source
     local user = ESX.GetPlayerFromId(src)


     local fetch = [[
          SELECT
               skills
          FROM
               users
          WHERE
               identifier = @identifier
     ]]

     MySQL.Async.fetchScalar(fetch, {
          ["@identifier"] = user.identifier

     }, function(status)
          
          if status ~= nil then
               cb(json.decode(status))
          else
               cb(nil)
          end
     
     end)
end)

--Actualizar stats
RegisterServerEvent("rhlm_habilidades:update")
AddEventHandler("rhlm_habilidades:update", function(data)
     local src = source
     local user = ESX.GetPlayerFromId(src)

     local insert = [[
          UPDATE
               users
          SET
               skills = @skills
          WHERE
               identifier = @identifier
     ]]

     MySQL.Async.execute(insert, {
          ["@skills"] = data,
          ["@identifier"] = user.identifier
     })

end)