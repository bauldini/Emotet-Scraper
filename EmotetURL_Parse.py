from OTXv2 import OTXv2
import json
import os


API_KEY = 'Enter your API Key Here'
pulse_id= 'Enter Your Pulse ID Here'
OTX_SERVER = 'https://otx.alienvault.com'

otx = OTXv2(API_KEY, server=OTX_SERVER)
x = "urls.txt"



def get_url():
    #print 'Getting indicators for pulse:'
    os.system('echo Getting IOCs from Pulse >> Emotet.log')
    indicators = otx.get_pulse_indicators(pulse_id=pulse_id)
    json_out = open('IOC_URL.json', 'a+')
    json_out.write('[')
    for indicator in indicators:
        file = open("urls.txt", 'a')
        file.write(indicator['indicator'])
        file.write("\n")
        file.close()


def outurl_json(x):
    with open(x , 'r') as in_file:
        json_out = open('IOC_URL.json', 'a+')
        for line in in_file:
            obj = {u"type": "URL", u"indicator":  line.rstrip()}
            json_out.write(json.dumps(obj, indent=9))
            json_out.write(',\n')
        json_out.write(']')
        json_out.close()
        os.system('head -n -2 IOC_URL.json | sed -e "\$a }\n" | sed -e "\$a ]" >> IOC_URL2.json')


def update_pulse():
    #print 'Updating indicators for pulse:'
    os.system('echo Updating Pulse >> Emotet.log')
    with open('IOC_URL2.json', 'r') as data_file:
        data = json.load(data_file)
		response = otx.replace_pulse_indicators(pulse_id, data)
        os.system('echo Done at $(date +%Y-%m-%d_%H:%M:%S) >> Emotet.log')
        print 'Response: ' + str(response)


get_url()
outurl_json(x)
update_pulse()
