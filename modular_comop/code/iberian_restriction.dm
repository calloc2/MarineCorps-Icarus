GLOBAL_LIST_INIT(allowed_countries, list(
	"ES", "MX", "AR", "CO", "PE", "VE", "CL", "EC", "GT", "CU", "BO", "DO", "HN", "PY", "SV", "NI", "CR", "PA", "UY", "GQ", "AD", "PR",
	"PT", "BR", "AO", "MZ", "CV", "ST", "TL", "GW", "MO"
))

/proc/check_gringo(ipaddr, client/origin)
	if(!origin)
		return //null source

	var/list/http_response[] = world.Export("http://ip-api.com/json/[ipaddr]")
	if(http_response) //check for a response
		var/page_content = http_response["CONTENT"]
		if(page_content)
			var/list/geodata = json_decode(html_decode(file2text(page_content)))
			var/country_code = geodata["countryCode"]
			if(!(country_code in GLOB.allowed_countries))
				log_access("GRINGO ALERT: [key_name(origin)]")
				to_chat(origin, SPAN_WARNING("You are not on the whitelist. If you are from a Spanish or Portuguese-speaking country, please contact us on our server: https://discord.gg/9bYHjc2N5C"))
				del(origin) // it isn't a portuguese or spanish country? kick him
	else //null response, ratelimited most likely. Try again in 60s
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(check_gringo), ipaddr, origin), 60 SECONDS)
