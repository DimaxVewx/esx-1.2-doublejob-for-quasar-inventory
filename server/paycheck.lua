ESX.StartPayCheck = function()
	function payCheck()
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local job     = xPlayer.job.grade_name
			local salary  = xPlayer.job.grade_salary

			if salary > 0 then
				if job == 'unemployed' then -- unemployed
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('qs-core:Notify', xPlayer.source, "vous avez reçu une aide de l'état: ".. salary .." $", "success")
				elseif Config.EnableSocietyPayouts then -- possibly a society
					TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
						if society ~= nil then -- verified society
							TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
								if account.money >= salary then -- does the society money to pay its employees?
									xPlayer.addAccountMoney('bank', salary)
									account.removeMoney(salary)
									TriggerClientEvent('qs-core:Notify', xPlayer.source, "vous avez reçu votre salaire: ".. salary .." $", "success")
								else
									TriggerClientEvent('qs-core:Notify', xPlayer.source, "votre entreprise n'a plus d'argent pour vous payer !", "error")
									
								end
							end)
						else -- not a society
							xPlayer.addAccountMoney('bank', salary)
							TriggerClientEvent('qs-core:Notify', xPlayer.source, "vous avez reçu votre salaire: ".. salary .." $", "success")
						end
					end)
				else -- generic job
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('qs-core:Notify', xPlayer.source, "vous avez reçu votre salaire: ".. salary .." $", "success")
				end
			end

		end

		SetTimeout(Config.PaycheckInterval, payCheck)
	end

	SetTimeout(Config.PaycheckInterval, payCheck)
end
